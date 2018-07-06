//
//  NewsProtocols.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation

// MARK: Wireframe
protocol NewsWireframeProtocol: class {
}
// MARK: Presenter
protocol NewsPresenterProtocol: class {
    func updateView()
    func updateData(data: [JSONDecoding.NewsApi.News])
}
// MARK: Interactor
protocol NewsInteractorProtocol: class {
    var presenter: NewsPresenterProtocol? { get set }
    func fetchNews()
}
// MARK: View
protocol NewsViewProtocol: class {
    var presenter: NewsPresenterProtocol? { get set }
    func showNews(source: [JSONDecoding.NewsApi.News])
}
