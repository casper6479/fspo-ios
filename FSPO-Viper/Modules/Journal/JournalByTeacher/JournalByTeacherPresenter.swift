//
//  JournalByTeacherPresenter.swift
//  FSPO
//
//  Created Николай Борисов on 07/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class JournalByTeacherPresenter: JournalByTeacherPresenterProtocol {

    weak private var view: JournalByTeacherViewProtocol?
    var interactor: JournalByTeacherInteractorProtocol?
    private let router: JournalByTeacherWireframeProtocol

    init(interface: JournalByTeacherViewProtocol, interactor: JournalByTeacherInteractorProtocol?, router: JournalByTeacherWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    func updateView() {
        interactor?.fetchLessons()
    }
    func journalByTeacherFetched(data: JSONDecoding.JournalByTeacherAPI) {
        view?.updateTableView(source: data)
        view?.setupHeader(data: data.teacher_info)
    }
}
