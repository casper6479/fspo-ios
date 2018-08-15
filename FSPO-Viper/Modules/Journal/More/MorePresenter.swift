//
//  MorePresenter.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 27/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class MorePresenter: MorePresenterProtocol {
    weak private var view: MoreViewProtocol?
    var interactor: MoreInteractorProtocol?
    private let router: MoreWireframeProtocol

    init(interface: MoreViewProtocol, interactor: MoreInteractorProtocol?, router: MoreWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    func updateView(cache: JSONDecoding.MoreApi?) {
        if Connectivity.isConnectedToInternet() {
            interactor?.fetchMore(cache: cache)
        }
    }
    func moreFetched(data: JSONDecoding.MoreApi) {
        view?.showNewRows(source: data)
    }
}
