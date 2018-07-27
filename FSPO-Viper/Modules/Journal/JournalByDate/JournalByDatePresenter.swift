//
//  JournalByDatePresenter.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 27/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class JournalByDatePresenter: JournalByDatePresenterProtocol {

    weak private var view: JournalByDateViewProtocol?
    var interactor: JournalByDateInteractorProtocol?
    private let router: JournalByDateWireframeProtocol

    init(interface: JournalByDateViewProtocol, interactor: JournalByDateInteractorProtocol?, router: JournalByDateWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

}
