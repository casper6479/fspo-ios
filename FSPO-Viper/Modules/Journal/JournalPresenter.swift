//
//  JournalPresenter.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class JournalPresenter: JournalPresenterProtocol {
    weak private var view: JournalViewProtocol?
    var interactor: JournalInteractorProtocol?
    private let router: JournalWireframeProtocol

    init(interface: JournalViewProtocol, interactor: JournalInteractorProtocol?, router: JournalWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    func updateView(cache: JSONDecoding.JournalApi?) {
        if Connectivity.isConnectedToInternet() {
            interactor?.fetchJournal(cache: cache)
        }
    }
    func logOut() {
        view?.logOut()
    }
    func journalFetched(data: JSONDecoding.JournalApi) {
        view?.fillView(data: data)
    }
    @objc func showByDate() {
        view?.show(vc: JournalByDateRouter.createModule())
    }
    @objc func showMore() {
        view?.show(vc: MoreRouter.createModule())
    }
    @objc func showBySubject() {
        view?.show(vc: JournalBySubjectRouter.createModule())
    }
}
