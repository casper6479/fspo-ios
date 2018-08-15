//
//  MessagesPresenter.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
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
    func updateView(cache: JSONDecoding.MessagesApi?) {
        if Connectivity.isConnectedToInternet() {
            interactor?.fetchMessages(cache: cache)
        }
    }
    func messagesFetched(data: JSONDecoding.MessagesApi) {
        view?.showNewRows(source: data)
    }
}
