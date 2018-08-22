//
//  LoginProtocols.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 08/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

// MARK: Wireframe -
protocol LoginWireframeProtocol: class {

}
// MARK: Presenter -
protocol LoginPresenterProtocol: class {
    func loginUser()
    func userLoggedIn()
    func stopLoading()
}

// MARK: Interactor -
protocol LoginInteractorProtocol: class {

    var presenter: LoginPresenterProtocol? { get set }
    func login()
}

// MARK: View -
protocol LoginViewProtocol: class {

    var presenter: LoginPresenterProtocol? { get set }
    func transiteToAuthRequest()
    func setDefaultState()
}
