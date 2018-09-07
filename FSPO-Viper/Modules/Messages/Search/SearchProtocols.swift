//
//  SearchProtocols.swift
//  FSPO
//
//  Created Николай Борисов on 06/09/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation

// MARK: Wireframe -
protocol SearchWireframeProtocol: class {

}
// MARK: Presenter -
protocol SearchPresenterProtocol: class {
    func updateView(query: String)
    func searchFetched(data: JSONDecoding.SearchAPI)
}

// MARK: Interactor -
protocol SearchInteractorProtocol: class {
    func fetchSearch(query: String)
  var presenter: SearchPresenterProtocol? { get set }
}

// MARK: View -
protocol SearchViewProtocol: class {
    func showNewRows(source: JSONDecoding.SearchAPI)
  var presenter: SearchPresenterProtocol? { get set }
}
