//
//  LoginRouter.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 08/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class LoginRouter: LoginWireframeProtocol {
    weak var viewController: UIViewController?
    static func createModule() -> UIViewController {
        let view = LoginViewController(nibName: nil, bundle: nil)
        let interactor = LoginInteractor()
        let router = LoginRouter()
        let presenter = LoginPresenter(interface: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
}
