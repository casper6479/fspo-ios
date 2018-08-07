//
//  MessagesPresenter.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class MessagesPresenter: MessagesPresenterProtocol {
    weak private var view: MessagesViewProtocol?
    var interactor: MessagesInteractorProtocol?
    private let router: MessagesWireframeProtocol

    init(interface: MessagesViewProtocol, interactor: MessagesInteractorProtocol?, router: MessagesWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    func updateView() {
        interactor?.fetchMessages()
    }
    func messagesFetched(data: JSONDecoding.MessagesApi) {
        view?.showNewRows(source: data)
    }
}
