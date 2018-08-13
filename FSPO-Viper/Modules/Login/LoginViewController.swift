//
//  LoginViewController.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 08/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, LoginViewProtocol {
	var presenter: LoginPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = UIRectEdge()
        let width = view.bounds.width
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            let loginLayout = LoginLayout()
            let arrangement = loginLayout.arrangement(width: width)
            DispatchQueue.main.async(execute: {
                arrangement.makeViews(in: self.view)
            })
        }
    }
    @objc func loginUpInside() {
        presenter?.loginUser()
    }
    @objc func scheduleUpInside() {
        navigationController?.show(ScheduleRouter.createModule(withMy: false), sender: self)
    }
    @objc func returnKeyPressed(sender: UITextField) {
        if sender == LoginLayout.loginTextField {
            LoginLayout.passwordTextField.becomeFirstResponder()
        } else {
            sender.resignFirstResponder()
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func presentTabBar() {
        self.present(UITabBarController().buildStudentsTabBar(), animated: true)
    }
}
