//
//  MoreProtocols.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 27/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation

// MARK: Wireframe -
protocol MoreWireframeProtocol: class {

}
// MARK: Presenter -
protocol MorePresenterProtocol: class {
    func updateView(cache: JSONDecoding.MoreApi?)
    func moreFetched(data: JSONDecoding.MoreApi)
}

// MARK: Interactor -
protocol MoreInteractorProtocol: class {
    func fetchMore(cache: JSONDecoding.MoreApi?)
  var presenter: MorePresenterProtocol? { get set }
}

// MARK: View -
protocol MoreViewProtocol: class {
    func showNewRows(source: JSONDecoding.MoreApi)
    var presenter: MorePresenterProtocol? { get set }
}
