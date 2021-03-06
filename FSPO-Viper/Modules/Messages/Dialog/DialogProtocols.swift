//
//  DialogProtocols.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 05/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation
import UIKit

// MARK: Wireframe -
protocol DialogWireframeProtocol: class {

}
// MARK: Presenter -
protocol DialogPresenterProtocol: class {
    func updateView(cache: JSONDecoding.DialogsApi?)
    func dialogsFetched(data: JSONDecoding.DialogsApi)
    func prepareMessageForSend(message: String)
    func updateFailed(alertController: UIAlertController)
}

// MARK: Interactor -
protocol DialogInteractorProtocol: class {
    var dialog_user_id: Int? { get set }
    func fetchDialogs(cache: JSONDecoding.DialogsApi?)
    func sendMessage(text: String, id: String?)
    var presenter: DialogPresenterProtocol? { get set }
}

// MARK: View -
protocol DialogViewProtocol: class {
    func showNewRows(source: JSONDecoding.DialogsApi)
    func showError(alert: UIAlertController)
  var presenter: DialogPresenterProtocol? { get set }
}
