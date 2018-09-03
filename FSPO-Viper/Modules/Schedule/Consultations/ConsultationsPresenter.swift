//
//  ConsultationsPresenter.swift
//  FSPO
//
//  Created Николай Борисов on 03/09/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class ConsultationsPresenter: ConsultationsPresenterProtocol {

    weak private var view: ConsultationsViewProtocol?
    var interactor: ConsultationsInteractorProtocol?
    private let router: ConsultationsWireframeProtocol

    init(interface: ConsultationsViewProtocol, interactor: ConsultationsInteractorProtocol?, router: ConsultationsWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    func updateView() {
        if Connectivity.isConnectedToInternet() {
            interactor?.fetchConsultations()
        }
    }
    func consultationsFetched(data: [Dictionary<String, Any>]) {
        view?.showNewRows(data: data)
    }

}
