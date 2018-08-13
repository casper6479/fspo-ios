//
//  JournalBySubjectProtocols.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 27/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation

// MARK: Wireframe -
protocol JournalBySubjectWireframeProtocol: class {

}
// MARK: Presenter -
protocol JournalBySubjectPresenterProtocol: class {
    func updateView(cache: JSONDecoding.JournalBySubjectsApi?)
    func journalBySubjectFetched(data: JSONDecoding.JournalBySubjectsApi)
}

// MARK: Interactor -
protocol JournalBySubjectInteractorProtocol: class {
    func fetchSubjects(cache: JSONDecoding.JournalBySubjectsApi?)
    var presenter: JournalBySubjectPresenterProtocol? { get set }
}

// MARK: View -
protocol JournalBySubjectViewProtocol: class {
    func showNewRows(source: JSONDecoding.JournalBySubjectsApi)
    var presenter: JournalBySubjectPresenterProtocol? { get set }
}
