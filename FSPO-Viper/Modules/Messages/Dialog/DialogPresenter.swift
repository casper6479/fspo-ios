//
//  DialogPresenter.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 05/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
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
    func updateView(cache: JSONDecoding.DialogsApi?) {
        if Connectivity.isConnectedToInternet() {
            interactor?.fetchDialogs(cache: cache)
        }
    }
    func dialogsFetched(data: JSONDecoding.DialogsApi) {
        view?.showNewRows(source: data)
    }
    func prepareMessageForSend(message: String) {
        interactor?.sendMessage(text: message)
    }
    func test() {
        print("test")
    }
}
