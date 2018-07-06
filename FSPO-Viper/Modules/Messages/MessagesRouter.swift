//
//  MessagesRouter.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class MessagesRouter: MessagesWireframeProtocol {
    weak var viewController: UIViewController?
    static func createModule() -> UIViewController {
        let view = MessagesViewController()
        let interactor = MessagesInteractor()
        let router = MessagesRouter()
        let presenter = MessagesPresenter(interface: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
}
