//
//  LoginLayout.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 08/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation
import LayoutKit

private let JournalVC = JournalViewController()

open class LoginLayout: InsetLayout<UIView> {
    static var loginTextField = UITextField()
    static var passwordTextField = UITextField()
    public init() {
        let itmoLogo =  SizeLayout<UIImageView>(
            size: CGSize(width: 200, height: 150),
            alignment: .topCenter,
            config: { imageView in
                imageView.image = UIImage(named: "logo")
                imageView.contentMode = .scaleAspectFit
        })
//        let loginButton = SizeLayout(
//            size: CGSize(width: 80, height: 40),
//            sublayout: ButtonLayout(
//                type: .custom,
//                title: "Вход",
//                alignment: .center,
//                config: { button in
//                    button.backgroundColor = UIColor.ITMOBlue
//                    button.setTitleColor(.white, for: .normal)
//                    button.setTitleColor(.lightGray, for: .highlighted)
//                    button.titleLabel?.font = UIFont.ITMOFontBold?.withSize(17)
//            }),
//            config: { view in
//                view.backgroundColor = UIColor.ITMOBlue
//                view.layer.cornerRadius = view.frame.height / 2
//                view.layer.masksToBounds = true
//        })

        let loginButton = SizeLayout<UIButton>(
            size: CGSize(width: 80, height: 40),
            alignment: .center,
            config: { button in
                button.setTitle("Вход", for: .normal)
                button.backgroundColor = UIColor.ITMOBlue
                button.setTitleColor(.white, for: .normal)
                button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
                button.titleLabel?.font = UIFont.ITMOFontBold?.withSize(17)
                button.layer.cornerRadius = button.frame.height / 2
                button.layer.masksToBounds = true
                button.applyStyle()
                button.addTarget(LoginViewController(), action: #selector(LoginViewController().loginUpInside), for: .touchUpInside)
        })
        let scheduleButton = ButtonLayout(
            type: .custom,
            title: "Расписание",
            alignment: .bottomCenter,
            config: { button in
                button.setTitleColor(UIColor.ITMOBlue, for: .normal)
                button.setTitleColor(UIColor.ITMOBlue.withAlphaComponent(0.5), for: .highlighted)
                button.titleLabel?.font = UIFont.ITMOFontBold?.withSize(17)
        })
        let loginField = SizeLayout<UITextField>(
            size: CGSize(width: UIScreen.main.bounds.width - 128, height: 40),
            config: { textfield in
                textfield.placeholder = "Логин"
                textfield.font = UIFont.ITMOFontBold
                textfield.leftViewMode = .always
                textfield.rightViewMode = .always
                textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
                textfield.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
                textfield.textAlignment = .center
                textfield.layer.cornerRadius = textfield.frame.height / 2
                textfield.layer.borderColor = UIColor.ITMOBlue.cgColor
                textfield.layer.borderWidth = 1
                textfield.autocorrectionType = .no
                textfield.returnKeyType = .next
                textfield.delegate = JournalVC
                textfield.autocapitalizationType = .none
                if #available(iOS 11.0, *) {
                    textfield.textContentType = .username
                }
                LoginLayout.loginTextField = textfield
        })
        let passwordField = SizeLayout<UITextField>(
            size: CGSize(width: UIScreen.main.bounds.width - 128, height: 40),
            config: { textfield in
                textfield.placeholder = "Пароль"
                textfield.font = UIFont.ITMOFontBold
                textfield.leftViewMode = .always
                textfield.rightViewMode = .always
                textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
                textfield.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
                textfield.textAlignment = .center
                textfield.layer.cornerRadius = textfield.frame.height / 2
                textfield.layer.borderColor = UIColor.ITMOBlue.cgColor
                textfield.layer.borderWidth = 1
                textfield.autocorrectionType = .no
                textfield.returnKeyType = .done
                textfield.isSecureTextEntry = true
                textfield.delegate = JournalVC
                if #available(iOS 11.0, *) {
                    textfield.textContentType = .password
                }
                LoginLayout.passwordTextField = textfield
        })
        var safeHeight: CGFloat = 0
        if #available(iOS 11, *) {
            let safeInset = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom
            safeHeight = UIScreen.main.bounds.height - (UITabBarController().tabBar.frame.height + UINavigationController().navigationBar.frame.height + UIApplication.shared.statusBarFrame.height + 24 + safeInset!)
        } else {
            safeHeight = UIScreen.main.bounds.height - (UITabBarController().tabBar.frame.height + UINavigationController().navigationBar.frame.height + UIApplication.shared.statusBarFrame.height + 24)
        }
        let topContainer = SizeLayout(
            size: CGSize(width: UIScreen.main.bounds.width, height: safeHeight / 3),
            sublayout: itmoLogo
        )
        let centerContainer = SizeLayout(
            size: CGSize(width: UIScreen.main.bounds.width, height: safeHeight / 3 + 50),
            alignment: .center,
            sublayout: StackLayout(axis: .vertical, spacing: 16, alignment: .center, sublayouts: [loginField, passwordField, loginButton])
        )
        let bottomContainer = SizeLayout(
            size: CGSize(width: UIScreen.main.bounds.width, height: safeHeight / 3 - 50),
            sublayout: scheduleButton
        )
        super.init(
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0),
            alignment: .bottomCenter,
            sublayout: StackLayout(axis: .vertical, spacing: 0, alignment: .center, sublayouts: [topContainer, centerContainer, bottomContainer])
        )
    }
}
