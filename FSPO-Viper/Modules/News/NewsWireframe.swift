//
//  NewsWireframe.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 06/07/2018.
//  Copyright (c) 2018 Николай Борисов. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit

final class NewsWireframe: BaseWireframe {

    // MARK: - Private properties -

    private let _storyboard = UIStoryboard(name: <#Storyboard name#>, bundle: nil)

    // MARK: - Module setup -

    func configureModule(with viewController: NewsViewController) {
        let interactor = NewsInteractor()
        let presenter = NewsPresenter(wireframe: self, view: viewController, interactor: interactor)
        viewController.presenter = presenter
    }

    // MARK: - Transitions -

    func show(with transition: Transition, animated: Bool = true) {
        let moduleViewController = _storyboard.instantiateViewController(ofType: NewsViewController.self)
        configureModule(with: moduleViewController)

        show(moduleViewController, with: transition, animated: animated)
    }
}

// MARK: - Extensions -

extension NewsWireframe: NewsWireframeInterface {

    func navigate(to option: NewsNavigationOption) {
    }
}
