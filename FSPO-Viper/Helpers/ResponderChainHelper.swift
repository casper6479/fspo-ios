//
//  ResponderChainNavigationController.swift
//  FSPO
//
//  Created by Николай Борисов on 10/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//
import UIKit

extension UIView {

    func controller() -> UIViewController? {
        if let nextViewControllerResponder = next as? UIViewController {
            return nextViewControllerResponder
        } else if let nextViewResponder = next as? UIView {
            return nextViewResponder.controller()
        } else {
            return nil
        }
    }

    func navigationController() -> UINavigationController? {
        if let controller = controller() {
            return controller.navigationController
        } else {
            return nil
        }
    }
}
