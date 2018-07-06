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
        News.tabBarItem = UITabBarItem(title: "Новости", image: UIImage(), selectedImage: UIImage())
        News.title = "Новости"
        let Journal = JournalRouter.createModule()
        Journal.tabBarItem = UITabBarItem(title: "Журнал", image: UIImage(), selectedImage: UIImage())
        Journal.title = "Журнал"
        let Messages = MessagesRouter.createModule()
        Messages.tabBarItem = UITabBarItem(title: "Сообщения", image: UIImage(), selectedImage: UIImage())
        Messages.title = "Сообщения"
        let Schedule = ScheduleRouter.createModule()
        Schedule.tabBarItem = UITabBarItem(title: "Расписание", image: UIImage(), selectedImage: UIImage())
        Schedule.title = "Расписание"
        let Profile = ProfileRouter.createModule()
        Profile.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(), selectedImage: UIImage())
        Profile.title = "Профиль"
        let tabBarController = UITabBarController()
        let controllers = [News, Journal, Messages, Schedule, Profile]
        tabBarController.viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
        return tabBarController
    }
}
