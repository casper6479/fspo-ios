//
//  ScheduleListRouter.swift
//  FSPO
//
//  Created Николай Борисов on 09/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class ScheduleListRouter: ScheduleListWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule(id: Int, type: String, title: String) -> UIViewController {
        let view = ScheduleListViewController()
        let interactor = ScheduleListInteractor(id: id, type: type)
        let router = ScheduleListRouter()
        let presenter = ScheduleListPresenter(interface: view, interactor: interactor, router: router)
        view.title = title
        view.id = id
        view.scheduleType = type
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
}
