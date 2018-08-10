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
    func updateView(offset: Int) {
        return (interactor?.fetchNews(offset: offset))!
    }
    func updateData(data: JSONDecoding.NewsApi) {
        view?.showNews(source: data.news)
        view?.countAll = data.count_n
    }
    func updateFailed(alertController: UIAlertController) {
        view?.showError(alert: alertController)
    }
}
