//
//  LoginPresenter.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 08/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class LoginPresenter: LoginPresenterProtocol {

    weak private var view: LoginViewProtocol?
    var interactor: LoginInteractorProtocol?
    private let router: LoginWireframeProtocol

    init(interface: LoginViewProtocol, interactor: LoginInteractorProtocol?, router: LoginWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    func loginUser() {
        if Connectivity.isConnectedToInternet() {
            interactor?.login()
        } else {
            showMessage(message: NSLocalizedString("Нет соединения с интернетом", comment: ""), y: 8)
        }
    }
    func userLoggedIn() {
        view?.transiteToAuthRequest()
    }
    func stopLoading() {
        view?.setDefaultState()
    }
}
