//
//  tabBarBuilder.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation
import UIKit

extension UITabBarController {
    func buildStudentsTabBar() -> UITabBarController {
        let News = NewsRouter.createModule()
        News.title = NSLocalizedString("Изменения в расписании", comment: "")
        News.tabBarItem = UITabBarItem(title: NSLocalizedString("Новости", comment: ""), image: UIImage(), selectedImage: UIImage())
        let Journal = JournalRouter.createModule()
        Journal.title = NSLocalizedString("Журнал", comment: "")
        Journal.tabBarItem = UITabBarItem(title: NSLocalizedString("Журнал", comment: ""), image: UIImage(), selectedImage: UIImage())
        let Messages = MessagesRouter.createModule()
        Messages.title = NSLocalizedString("Сообщения", comment: "")
        Messages.tabBarItem = UITabBarItem(title: NSLocalizedString("Сообщения", comment: ""), image: UIImage(), selectedImage: UIImage())
        let Schedule = ScheduleRouter.createModule()
        Schedule.title = NSLocalizedString("Расписание", comment: "")
        Schedule.tabBarItem = UITabBarItem(title: NSLocalizedString("Расписание", comment: ""), image: UIImage(), selectedImage: UIImage())
        let Profile = ProfileRouter.createModule()
        Profile.title = NSLocalizedString("Профиль", comment: "")
        Profile.tabBarItem = UITabBarItem(title: NSLocalizedString("Профиль", comment: ""), image: UIImage(), selectedImage: UIImage())
        let tabBarController = UITabBarController()
        let controllers = [News, Journal, Messages, Schedule, Profile]
        let navigationControllers = controllers.map {UINavigationController(rootViewController: $0)}
        tabBarController.viewControllers = navigationControllers
        tabBarController.tabBar.backgroundColor = .white
        return tabBarController
    }
}
