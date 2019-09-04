//
//  LoginViewController.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 08/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import Alamofire
import Lottie

class LoginViewController: UIViewController, LoginViewProtocol, CAAnimationDelegate {
	var presenter: LoginPresenterProtocol?
    var defaultButtonState: CGRect!
    let loaderAnimation = LOTAnimationView(name: "loginloader")
    override func viewDidLoad() {
        super.viewDidLoad()
        loaderOrigin = self.view.bounds.width / 2 - buttonWidth / 2
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = UIRectEdge()
        let width = view.bounds.width
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            let loginLayout = LoginLayout()
            let arrangement = loginLayout.arrangement(width: width)
            DispatchQueue.main.async(execute: {
                arrangement.makeViews(in: self.view)
                self.defaultButtonState = LoginLayout.loginButton.frame
            })
        }
    }
    let buttonWidth: CGFloat = 40
    var loaderOrigin: CGFloat!
    func setLoadingFrame() {
        LoginLayout.loginButton.frame.size.width = buttonWidth
        LoginLayout.loginButton.frame.origin.x = loaderOrigin
        LoginLayout.loginButton.setTitle("", for: .normal)
    }
    var dataFetched: Bool?
    func setLoadingState() {
        UIView.animate(withDuration: 0.2, animations: {
            self.setLoadingFrame()
        }, completion: { _ in
            if self.dataFetched == nil {
                LoginLayout.loginButton.backgroundColor = .white
                self.loaderAnimation.frame = LoginLayout.loginButton.frame
                self.view.addSubview(self.loaderAnimation)
                self.loaderAnimation.loopAnimation = true
                self.loaderAnimation.play()
            }
        })
    }
    func expand(button: UIButton) {
        if LoginLayout.loginButton.frame.origin.x != self.loaderOrigin {
            UIView.animate(withDuration: 0.1) {
                self.setLoadingFrame()
            }
        }
        let expandAnim = CABasicAnimation(keyPath: "transform.scale")
        expandAnim.delegate = self
        expandAnim.fromValue = 1.0
        expandAnim.toValue = 26.0
        expandAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.95, 0.02, 1, 0.05)
        expandAnim.duration = 0.3
        expandAnim.fillMode = CAMediaTimingFillMode.forwards
        expandAnim.isRemovedOnCompletion = false
        button.layer.add(expandAnim, forKey: expandAnim.keyPath)
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.present(IdentityRequestRouter.createModule(), animated: true)
    }
    func setDefaultState() {
        dataFetched = true
        if !loaderAnimation.isAnimationPlaying {
            UIView.animate(withDuration: 0.1, animations: {
                LoginLayout.loginButton.frame = self.defaultButtonState
            }, completion: { _ in
                LoginLayout.loginButton.backgroundColor = .clear
                LoginLayout.loginButton.setTitle(NSLocalizedString("Вход", comment: ""), for: .normal)
            })
        } else {
            loaderAnimation.pause()
            loaderAnimation.loopAnimation = false
            loaderAnimation.play(toProgress: 1) { _ in
                self.loaderAnimation.removeFromSuperview()
                self.loaderAnimation.stop()
                LoginLayout.loginButton.backgroundColor = .clear
                UIView.animate(withDuration: 0.2, animations: {
                    LoginLayout.loginButton.frame = self.defaultButtonState
                }, completion: { _ in
                    LoginLayout.loginButton.setTitle(NSLocalizedString("Вход", comment: ""), for: .normal)
                })
            }
        }
    }
    func transiteToAuthRequest() {
        dataFetched = true
        if !loaderAnimation.isAnimationPlaying {
            UIView.animate(withDuration: 0.1, animations: {
                self.setLoadingFrame()
            }, completion: { _ in
                LoginLayout.loginButton.backgroundColor = .clear
                self.expand(button: LoginLayout.loginButton)
            })
        } else {
            loaderAnimation.pause()
            loaderAnimation.loopAnimation = false
            loaderAnimation.play(toProgress: 1) { _ in
                self.loaderAnimation.removeFromSuperview()
                self.loaderAnimation.stop()
                LoginLayout.loginButton.backgroundColor = .clear
                self.expand(button: LoginLayout.loginButton)
            }
        }
    }
    @objc func loginUpInside() {
        dataFetched = nil
        self.view.endEditing(true)
        if Connectivity.isConnectedToInternet() {
            setLoadingState()
        }
        presenter?.loginUser()
    }
    @objc func scheduleUpInside() {
        navigationController?.show(ScheduleRouter.createModule(withMy: false), sender: self)
    }
    @objc func returnKeyPressed(sender: UITextField) {
        if sender == LoginLayout.loginTextField {
            LoginLayout.passwordTextField.becomeFirstResponder()
        } else {
            loginUpInside()
            sender.resignFirstResponder()
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
