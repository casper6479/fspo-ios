//
//  JournalByDateProtocols.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 27/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation

// MARK: Wireframe -
protocol JournalByDateWireframeProtocol: class {

}
// MARK: Presenter -
protocol JournalByDatePresenterProtocol: class {
    func updateView(date: String)
    func journalByDateFetched(data: JSONDecoding.JournalByDateAPI)
    func journalByDateShowNoLessons()
    func jounalByDateHideNoLessons()
}

// MARK: Interactor -
protocol JournalByDateInteractorProtocol: class {
    func fetchJournalByDate(date: String)
    var presenter: JournalByDatePresenterProtocol? { get set }
}

// MARK: View -
protocol JournalByDateViewProtocol: class {
    func updateTableView(source: JSONDecoding.JournalByDateAPI)
    func showNoLessons()
    func hideNoLessons()
    var presenter: JournalByDatePresenterProtocol? { get set }
}
