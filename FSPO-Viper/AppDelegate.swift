//
//  AppDelegate.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 21/06/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import FPSCounter
import IQKeyboardManagerSwift
import UserNotifications
import LocalAuthentication
import Fabric
import Crashlytics
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var biometricView: UIView!
    let authContex = LAContext()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        ScheduleStorage().setExludedFromBackup()

        UIApplication.shared.statusBarStyle = .lightContent
        window = UIWindow(frame: UIScreen.main.bounds)

        let loginModule = UINavigationController.init(rootViewController: LoginRouter.createModule())
        if UserDefaults.standard.integer(forKey: "user_id") != 0 {
            window?.rootViewController = UITabBarController().buildStudentsTabBar()
        } else {
            window?.rootViewController = loginModule
        }
        window?.makeKeyAndVisible()
        if window?.rootViewController != loginModule {
            var authError: NSError?
            if !UserDefaults.standard.bool(forKey: "biometricDisabled") {
                if authContex.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
                    showGuard(window: window!)
                } else {
                    showMessage(message: (authError?.localizedDescription)!, y: 16)
                }
            }
        }
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            let options: UNAuthorizationOptions = [.alert, .sound]
            center.requestAuthorization(options: options) { (_, error) in
                if error != nil {
                    print("Error in notification auth")
                }
            }
        } else {
            /*if(UIApplication.instancesRespond(to: #selector(UIApplication.registerUserNotificationSettings(_:)))) {
             UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types:[.alert, .sound], categories: nil))
             }*/
        }

        Fabric.with([Crashlytics.self])

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 5

        FPSCounter().startTracking()

        UINavigationBar.appearance().barTintColor = UIColor.ITMOBlue
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.backgroundColor: UIColor.ITMOBlue]

        if #available(iOS 11, *) {
            let safeInset = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom
            Constants.safeHeight = UIScreen.main.bounds.height - (UITabBarController().tabBar.frame.height + UINavigationController().navigationBar.frame.height + UIApplication.shared.statusBarFrame.height + safeInset!)
        } else {
            Constants.safeHeight = UIScreen.main.bounds.height - (UITabBarController().tabBar.frame.height + UINavigationController().navigationBar.frame.height + UIApplication.shared.statusBarFrame.height)
        }
        return true
    }
    func showGuard(window: UIWindow) {
        biometricView = UIView(frame: window.bounds)
        biometricView.backgroundColor = .white
        let width = UIScreen.main.bounds.width
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            let biometricScreen = BiometricLayout()
            let arrangement = biometricScreen.arrangement(width: width)
            DispatchQueue.main.async(execute: {
                arrangement.makeViews(in: self.biometricView)
            })
        }
        window.addSubview(biometricView)
        authUser()
    }
    func authUser() {
        authContex.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: NSLocalizedString("Подтвердите личность", comment: "")) { (success, error) in
            if success {
                DispatchQueue.main.async {
                    self.biometricView.removeFromSuperview()
                }
            } else {
                switch error {
                case LAError.authenticationFailed?:
                    DispatchQueue.main.async {
                        BiometricLayout.label.text = "Возникла ошибка"
                    }
                case LAError.userCancel?:
                    DispatchQueue.main.async {
                        BiometricLayout.label.text = "Отменено пользователем"
                    }
                case LAError.userFallback?:
                    DispatchQueue.main.async {
                        BiometricLayout.label.text = "Введите пароль"
                    }
                default:
                    showMessage(message: NSLocalizedString("Face ID/Touch ID не может настроиться", comment: ""), y: 16)
                }
            }
        }
    }
    @objc func againUpInside() {
        authUser()
    }
}
