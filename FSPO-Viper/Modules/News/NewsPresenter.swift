//
//  NewsPresenter.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import Alamofire
class NewsPresenter: NewsPresenterProtocol {

    weak private var view: NewsViewProtocol?
    var interactor: NewsInteractorProtocol?
    private let router: NewsWireframeProtocol

    init(interface: NewsViewProtocol, interactor: NewsInteractorProtocol?, router: NewsWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    func updateView(offset: Int, cache: [JSONDecoding.NewsApi.News]?) {
        if Connectivity.isConnectedToInternet() {
            interactor?.fetchNews(offset: offset, cache: cache)
        }
    }
    func updateData(data: JSONDecoding.NewsApi) {
        view?.showNews(source: data.news)
        view?.countAll = data.count_n
    }
    func updateFailed(alertController: UIAlertController) {
        view?.showError(alert: alertController)
    }
}
