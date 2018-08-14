//
//  IdentityRequestRouter.swift
//  FSPO
//
//  Created Николай Борисов on 14/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class IdentityRequestRouter: IdentityRequestWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        let view = IdentityRequestViewController(nibName: nil, bundle: nil)
        let interactor = IdentityRequestInteractor()
        let router = IdentityRequestRouter()
        let presenter = IdentityRequestPresenter(interface: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }
}
