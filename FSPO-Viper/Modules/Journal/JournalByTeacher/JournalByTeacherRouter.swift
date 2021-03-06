//
//  JournalByTeacherRouter.swift
//  FSPO
//
//  Created Николай Борисов on 07/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class JournalByTeacherRouter: JournalByTeacherWireframeProtocol {
    weak var viewController: UIViewController?
    static func createModule(lessonId: Int, title: String) -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = JournalByTeacherViewController(nibName: nil, bundle: nil)
        let interactor = JournalByTeacherInteractor(lessonId: lessonId)
        let router = JournalByTeacherRouter()
        let presenter = JournalByTeacherPresenter(interface: view, interactor: interactor, router: router)
        view.title = title
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
}
