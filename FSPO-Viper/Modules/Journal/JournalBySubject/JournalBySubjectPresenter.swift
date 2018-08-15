//
//  JournalBySubjectPresenter.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 27/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class JournalBySubjectPresenter: JournalBySubjectPresenterProtocol {

    weak private var view: JournalBySubjectViewProtocol?
    var interactor: JournalBySubjectInteractorProtocol?
    private let router: JournalBySubjectWireframeProtocol

    init(interface: JournalBySubjectViewProtocol, interactor: JournalBySubjectInteractorProtocol?, router: JournalBySubjectWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    func updateView(cache: JSONDecoding.JournalBySubjectsApi?) {
        if Connectivity.isConnectedToInternet() {
            interactor?.fetchSubjects(cache: cache)
        }
    }
    func journalBySubjectFetched(data: JSONDecoding.JournalBySubjectsApi) {
        view?.showNewRows(source: data)
    }
}
