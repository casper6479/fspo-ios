//
//  JournalProtocols.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation
import UIKit

// MARK: Wireframe -
protocol JournalWireframeProtocol: class {

}
// MARK: Presenter -
protocol JournalPresenterProtocol: class {
    func updateView(cache: JSONDecoding.JournalApi?)
    func journalFetched(data: JSONDecoding.JournalApi)
    func showByDate()
    func showBySubject()
    func showMore()
    func logOut()
}

// MARK: Interactor -
protocol JournalInteractorProtocol: class {
    func fetchJournal(cache: JSONDecoding.JournalApi?)
  var presenter: JournalPresenterProtocol? { get set }
}

// MARK: View -
protocol JournalViewProtocol: class {
    var presenter: JournalPresenterProtocol? { get set }
    func fillView(data: JSONDecoding.JournalApi)
    func show(vc: UIViewController)
    func logOut()
}
