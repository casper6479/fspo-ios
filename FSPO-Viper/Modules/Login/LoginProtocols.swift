//
//  LoginProtocols.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 08/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

// MARK: Wireframe -
protocol LoginWireframeProtocol: class {

}
// MARK: Presenter -
protocol LoginPresenterProtocol: class {

}

// MARK: Interactor -
protocol LoginInteractorProtocol: class {

  var presenter: LoginPresenterProtocol? { get set }
}

// MARK: View -
protocol LoginViewProtocol: class {

  var presenter: LoginPresenterProtocol? { get set }
}
