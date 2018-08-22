//
//  IdentityRequestViewController.swift
//  FSPO
//
//  Created Николай Борисов on 14/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import LayoutKit

class IdentityRequestViewController: UIViewController, IdentityRequestViewProtocol {

	var presenter: IdentityRequestPresenterProtocol?

	override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = UIRectEdge()
        let width = view.bounds.width
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            let requestLayout = IdentityRequestLayout()
            let arrangement = requestLayout.arrangement(width: width)
            DispatchQueue.main.async(execute: {
                arrangement.makeViews(in: self.view)
            })
        }
    }
    @objc func allowUpInside() {
        UserDefaults.standard.set(true, forKey: "biometricEnabled")
        if UserDefaults.standard.string(forKey: "role") == "student" {
            self.present(UITabBarController().buildStudentsTabBar(), animated: true)
        }
        if UserDefaults.standard.string(forKey: "role") == "teacher" {
            self.present(UITabBarController().buildTeachersTabBar(), animated: true)
        }
        if UserDefaults.standard.string(forKey: "role") == "parent" {
            self.present(UITabBarController().buildStudentsTabBar(), animated: true)
        }
    }
    @objc func disallowUpInside() {
        UserDefaults.standard.set(false, forKey: "biometricEnabled")
        if UserDefaults.standard.string(forKey: "role") == "student" {
            self.present(UITabBarController().buildStudentsTabBar(), animated: true)
        }
        if UserDefaults.standard.string(forKey: "role") == "teacher" {
            self.present(UITabBarController().buildTeachersTabBar(), animated: true)
        }
        if UserDefaults.standard.string(forKey: "role") == "parent" {
            self.present(UITabBarController().buildStudentsTabBar(), animated: true)
        }
    }
}
