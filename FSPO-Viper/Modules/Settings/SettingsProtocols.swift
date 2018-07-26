//
//  SettingsProtocols.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 26/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation

// MARK: Wireframe -
protocol SettingsWireframeProtocol: class {

}
// MARK: Presenter -
protocol SettingsPresenterProtocol: class {

}

// MARK: Interactor -
protocol SettingsInteractorProtocol: class {

  var presenter: SettingsPresenterProtocol? { get set }
}

// MARK: View -
protocol SettingsViewProtocol: class {

  var presenter: SettingsPresenterProtocol? { get set }
}
