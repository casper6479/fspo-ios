//
//  ConsultationsRouter.swift
//  FSPO
//
//  Created Николай Борисов on 03/09/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class ConsultationsRouter: ConsultationsWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        let view = ConsultationsViewController(nibName: nil, bundle: nil)
        let interactor = ConsultationsInteractor()
        let router = ConsultationsRouter()
        let presenter = ConsultationsPresenter(interface: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }
}
