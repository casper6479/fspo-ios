//
//  NewsPresenter.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class NewsPresenter: NewsPresenterProtocol {

    weak private var view: NewsViewProtocol?
    var interactor: NewsInteractorProtocol?
    private let router: NewsWireframeProtocol

    init(interface: NewsViewProtocol, interactor: NewsInteractorProtocol?, router: NewsWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    func updateView() {
        interactor?.fetchNews()
    }
    func updateData(data: [JSONDecoding.NewsApi.News]) {
        view?.showNews(source: data)
    }
}
