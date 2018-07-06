//
//  NewsRouter.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class NewsRouter: NewsWireframeProtocol {
    weak var viewController: UIViewController?
    static func createModule() -> UIViewController {
        let view = NewsViewController()
        let interactor = NewsInteractor()
        let router = NewsRouter()
        let presenter = NewsPresenter(interface: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
}
