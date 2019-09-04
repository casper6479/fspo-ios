//
//  AppDelegate.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 21/06/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications
import LocalAuthentication
import Fabric
import Crashlytics
import Kingfisher
import Firebase

var remoteConfig: RemoteConfig!//c78bf5636f9cf36763b511184c572e8f9341cb08
var remoteDict: [String: NSObject] = ["app_key": "b13f556af4ed3da2f8d484a617fee76d78be1166" as NSString,
                                      "remote_message": "none" as NSString,
                                      "isISUApi": true as NSNumber,
                                      "ISULogin": "ifmo01" as NSString,
                                      "ISUPassword": "01ifmo04" as NSString,
                                      "ISUModule": "schedule_lessons" as NSString]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var biometricView: UIView!
    let authContex = LAContext()
    var defaults = UserDefaults(suiteName: "group.itmo.fspo.app")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        UIColor.ITMOBlue = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)

        StoreReviewHelper.incrementAppOpenedCount()

        FirebaseApp.configure()

        remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.setDefaults(remoteDict)
        Constants.AppKey = remoteConfig.configValue(forKey: "app_key").stringValue!
        RemoteCfg.isISUApi = remoteConfig.configValue(forKey: "isISUApi").boolValue
        RemoteCfg.ISULogin = remoteConfig.configValue(forKey: "ISULogin").stringValue!
        RemoteCfg.ISUPassword = remoteConfig.configValue(forKey: "ISUPassword").stringValue!
        RemoteCfg.ISUModule = remoteConfig.configValue(forKey: "ISUModule").stringValue!
        defaults?.set(RemoteCfg.isISUApi, forKey: "isISUApi")
        defaults?.set(RemoteCfg.ISULogin, forKey: "ISULogin")
        defaults?.set(RemoteCfg.ISUPassword, forKey: "ISUPassword")
        defaults?.set(RemoteCfg.ISUModule, forKey: "ISUModule")
        print(Constants.AppKey)
        remoteConfig.fetch(withExpirationDuration: 60*30) { [unowned self] (status, error) in
            if status == .success {
                print("Config fetched!")
                remoteConfig.activateFetched()
                Constants.AppKey = remoteConfig.configValue(forKey: "app_key").stringValue!
                RemoteCfg.isISUApi = remoteConfig.configValue(forKey: "isISUApi").boolValue
                RemoteCfg.ISULogin = remoteConfig.configValue(forKey: "ISULogin").stringValue!
                RemoteCfg.ISUPassword = remoteConfig.configValue(forKey: "ISUPassword").stringValue!
                RemoteCfg.ISUModule = remoteConfig.configValue(forKey: "ISUModule").stringValue!
                self.defaults?.set(RemoteCfg.isISUApi, forKey: "isISUApi")
                self.defaults?.set(RemoteCfg.ISULogin, forKey: "ISULogin")
                self.defaults?.set(RemoteCfg.ISUPassword, forKey: "ISUPassword")
                self.defaults?.set(RemoteCfg.ISUModule, forKey: "ISUModule")
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
        ScheduleStorage().setExludedFromBackup()

        clearSessionOnce()

        window = UIWindow(frame: UIScreen.main.bounds)

        let loginModule = NavigationController(rootViewController: LoginRouter.createModule())
        if UserDefaults.standard.integer(forKey: "user_id") != 0 {
            if UserDefaults.standard.string(forKey: "role") == "student" {
                window?.rootViewController = UITabBarController().buildStudentsTabBar()
            }
            if UserDefaults.standard.string(forKey: "role") == "teacher" {
                if defaults?.integer(forKey: "user_id") == 0 {
                    defaults?.set(UserDefaults.standard.integer(forKey: "user_id"), forKey: "user_id")
                }
                window?.rootViewController = UITabBarController().buildTeachersTabBar()
            }
            if UserDefaults.standard.string(forKey: "role") == "parent" {
               window?.rootViewController = UITabBarController().buildStudentsTabBar()
            }
        } else {
            window?.rootViewController = loginModule
        }
        if (keychain["token"] == nil) {
            window?.rootViewController = loginModule
        }
        window?.makeKeyAndVisible()
        if window?.rootViewController != loginModule {
            var authError: NSError?
            if UserDefaults.standard.bool(forKey: "biometricEnabled") {
                if authContex.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
                    if let rootController = window?.rootViewController as? UITabBarController {
                        if let currentNavigationController = rootController.selectedViewController as? NavigationController {
                            currentController = currentNavigationController
                            currentController?.isBlack = true
                            currentController?.setNeedsStatusBarAppearanceUpdate()
                        }
                    }
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
        UINavigationBar.appearance().barTintColor = .ITMOBlue
        UIApplication.shared.keyWindow?.backgroundColor = .white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        if #available(iOS 11, *) {
            let safeInset = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom
            Constants.safeHeight = UIScreen.main.bounds.height - (UITabBarController().tabBar.frame.height + UINavigationController().navigationBar.frame.height + UIApplication.shared.statusBarFrame.height + safeInset!)
        } else {
            Constants.safeHeight = UIScreen.main.bounds.height - (UITabBarController().tabBar.frame.height + UINavigationController().navigationBar.frame.height + UIApplication.shared.statusBarFrame.height)
        }
        UIApplication.shared.keyWindow?.layer.cornerRadius = 8
        UIApplication.shared.keyWindow?.layer.masksToBounds = true
        return true
    }
    func clearSessionOnce() {
        if !UserDefaults.standard.bool(forKey: "logout1.0.6") {
            SettingsViewController().logOut()
            UserDefaults.standard.set(true, forKey: "logout1.0.6")
        }
    }
    private var currentController: NavigationController?
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
    func clearCache() {
        storage?.async.removeAll(completion: {_ in })
        do {
            try ScheduleStorage().storage?.removeAll()
        } catch {
            print(error)
        }
        ImageCache.default.clearDiskCache()
        ImageCache.default.clearMemoryCache()
    }
    func authUser() {
        authContex.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: NSLocalizedString("Подтвердите личность", comment: "")) { (success, error) in
            if success {
                DispatchQueue.main.async {
                    self.currentController?.isBlack = false
                    self.currentController?.setNeedsStatusBarAppearanceUpdate()
                    self.biometricView.removeFromSuperview()
                }
            } else {
                switch error {
                case LAError.authenticationFailed?:
                    DispatchQueue.main.async {
                        BiometricLayout.label.text = NSLocalizedString("Возникла ошибка", comment: "")
                    }
                case LAError.userCancel?:
                    DispatchQueue.main.async {
                        BiometricLayout.label.text = NSLocalizedString("Отменено пользователем", comment: "")
                    }
                case LAError.userFallback?:
                    DispatchQueue.main.async {
                        BiometricLayout.label.text = NSLocalizedString("Введите пароль", comment: "")
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
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return true
    }
}
