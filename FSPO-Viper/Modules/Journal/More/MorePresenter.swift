//
//  MorePresenter.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 27/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
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
    func updateView() {
        interactor?.fetchMore()
    }
    func moreFetched(data: JSONDecoding.MoreApi) {
        view?.showNewRows(source: data)
    }
}
