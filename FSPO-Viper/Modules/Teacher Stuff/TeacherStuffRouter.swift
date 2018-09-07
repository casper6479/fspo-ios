//
//  TeacherStuffRouter.swift
//  FSPO
//
//  Created Николай Борисов on 06/09/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class TeacherStuffRouter: TeacherStuffWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        let view = TeacherStuffViewController(nibName: nil, bundle: nil)
        let interactor = TeacherStuffInteractor()
        let router = TeacherStuffRouter()
        let presenter = TeacherStuffPresenter(interface: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }
}
