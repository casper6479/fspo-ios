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
        News.title = "Изменения в расписании"
        News.tabBarItem = UITabBarItem(title: "Новости", image: UIImage(), selectedImage: UIImage())
        let Journal = JournalRouter.createModule()
        Journal.title = "Журнал"
        Journal.tabBarItem = UITabBarItem(title: "Журнал", image: UIImage(), selectedImage: UIImage())
        let Messages = MessagesRouter.createModule()
        Messages.title = "Сообщения"
        Messages.tabBarItem = UITabBarItem(title: "Сообщения", image: UIImage(), selectedImage: UIImage())
        let Schedule = ScheduleRouter.createModule()
        Schedule.title = "Расписание"
        Schedule.tabBarItem = UITabBarItem(title: "Расписание", image: UIImage(), selectedImage: UIImage())
        let Profile = ProfileRouter.createModule()
        Profile.title = "Профиль"
        Profile.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(), selectedImage: UIImage())
        let tabBarController = UITabBarController()
        let controllers = [News, Journal, Messages, Schedule, Profile]
        let navigationControllers = controllers.map {UINavigationController(rootViewController: $0)}
        tabBarController.viewControllers = navigationControllers
        return tabBarController
    }
}
