//
//  DialogRouter.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 05/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class DialogRouter: DialogWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule(dialog_id: Int) -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = DialogViewController(nibName: nil, bundle: nil)
        let interactor = DialogInteractor(dialog_user_id: dialog_id)
        let router = DialogRouter()
        let presenter = DialogPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}
