//
//  JournalByDatePresenter.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 27/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
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
    func updateView(date: String) {
        if Connectivity.isConnectedToInternet() {
            interactor?.fetchJournalByDate(date: date)
        }
    }
    func journalByDateFetched(data: JSONDecoding.JournalByDateAPI) {
        view?.updateTableView(source: data)
    }
    func journalByDateShowNoLessons() {
        view?.showNoLessons()
    }
}
