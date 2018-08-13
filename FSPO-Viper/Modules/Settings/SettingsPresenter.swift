//
//  SettingsPresenter.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 26/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class SettingsPresenter: SettingsPresenterProtocol {

    weak private var view: SettingsViewProtocol?
    var interactor: SettingsInteractorProtocol?
    private let router: SettingsWireframeProtocol

    init(interface: SettingsViewProtocol, interactor: SettingsInteractorProtocol?, router: SettingsWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

}
