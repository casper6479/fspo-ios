//
//  MessagesProtocols.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation
import UIKit

// MARK: Wireframe -
protocol MessagesWireframeProtocol: class {

}
// MARK: Presenter -
protocol MessagesPresenterProtocol: class {
    func updateView(cache: JSONDecoding.MessagesApi?)
    func messagesFetched(data: JSONDecoding.MessagesApi)
}

// MARK: Interactor -
protocol MessagesInteractorProtocol: class {
    func fetchMessages(cache: JSONDecoding.MessagesApi?)
  var presenter: MessagesPresenterProtocol? { get set }
}

// MARK: View -
protocol MessagesViewProtocol: class {
    func showNewRows(source: JSONDecoding.MessagesApi)
    var presenter: MessagesPresenterProtocol? { get set }
}
