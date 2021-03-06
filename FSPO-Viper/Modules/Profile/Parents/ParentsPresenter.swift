//
//  ParentsPresenter.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 27/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class ParentsPresenter: ParentsPresenterProtocol {
    weak private var view: ParentsViewProtocol?
    var interactor: ParentsInteractorProtocol?
    private let router: ParentsWireframeProtocol

    init(interface: ParentsViewProtocol, interactor: ParentsInteractorProtocol?, router: ParentsWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    func updateView() {
        if Connectivity.isConnectedToInternet() {
            interactor?.fetchParents()
        }
    }
    func parentsFetched(firstname: String, lastname: String, middlename: String, email: String, phone: String, photo: String) {
        view?.fillView(firstname: firstname, lastname: lastname, middlename: middlename, email: email, phone: phone, photo: photo)
    }
}
