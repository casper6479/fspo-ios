//
//  DialogRouter.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 05/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class DialogRouter: DialogWireframeProtocol {
    weak var viewController: UIViewController?
    static func createModule(dialog_id: Int, title: String) -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = DialogViewController()
        let interactor = DialogInteractor(dialog_user_id: dialog_id)
        let router = DialogRouter()
        let presenter = DialogPresenter(interface: view, interactor: interactor, router: router)
        view.title = title
        view.dialogId = dialog_id
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        return view
    }
}
