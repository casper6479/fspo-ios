//
//  SearchPresenter.swift
//  FSPO
//
//  Created Николай Борисов on 06/09/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class SearchPresenter: SearchPresenterProtocol {

    weak private var view: SearchViewProtocol?
    var interactor: SearchInteractorProtocol?
    private let router: SearchWireframeProtocol

    init(interface: SearchViewProtocol, interactor: SearchInteractorProtocol?, router: SearchWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    func updateView(query: String) {
        interactor?.fetchSearch(query: query)
    }
    
    func searchFetched(data: JSONDecoding.SearchAPI) {
        view?.showNewRows(source: data)
    }
}
