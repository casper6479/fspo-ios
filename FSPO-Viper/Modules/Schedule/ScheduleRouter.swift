//
//  ScheduleRouter.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class ScheduleRouter: ScheduleWireframeProtocol {
    weak var viewController: UIViewController?
    static func createModule() -> UIViewController {
        let view = ScheduleViewController()
        let interactor = ScheduleInteractor()
        let router = ScheduleRouter()
        let presenter = SchedulePresenter(interface: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
}
