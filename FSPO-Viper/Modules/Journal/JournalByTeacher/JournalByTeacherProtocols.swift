//
//  JournalByTeacherProtocols.swift
//  FSPO
//
//  Created Николай Борисов on 07/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation

// MARK: Wireframe -
protocol JournalByTeacherWireframeProtocol: class {

}
// MARK: Presenter -
protocol JournalByTeacherPresenterProtocol: class {
    func updateView()
    func journalByTeacherFetched(data: JSONDecoding.JournalByTeacherAPI)
}

// MARK: Interactor -
protocol JournalByTeacherInteractorProtocol: class {
    func fetchLessons()
    var presenter: JournalByTeacherPresenterProtocol? { get set }
}

// MARK: View -
protocol JournalByTeacherViewProtocol: class {
    func updateTableView(source: JSONDecoding.JournalByTeacherAPI)
    func setupHeader(data: JSONDecoding.JournalByTeacherAPI.TeacherInfo)
    var presenter: JournalByTeacherPresenterProtocol? { get set }
}
