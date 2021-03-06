//
//  JournalBySubjectRouter.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 27/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class JournalBySubjectRouter: JournalBySubjectWireframeProtocol {
    weak var viewController: UIViewController?
    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = JournalBySubjectViewController(nibName: nil, bundle: nil)
        let interactor = JournalBySubjectInteractor()
        let router = JournalBySubjectRouter()
        let presenter = JournalBySubjectPresenter(interface: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
}
