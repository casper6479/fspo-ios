//
//  DialogPresenter.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 05/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class DialogPresenter: DialogPresenterProtocol {

    weak private var view: DialogViewProtocol?
    var interactor: DialogInteractorProtocol?
    private let router: DialogWireframeProtocol

    init(interface: DialogViewProtocol, interactor: DialogInteractorProtocol?, router: DialogWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    func updateView() {
        interactor?.fetchDialogs()
    }
    func dialogsFetched(data: JSONDecoding.DialogsApi) {
        view?.showNewRows(source: data)
    }
}