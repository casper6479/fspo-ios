//
//  tabBarBuilder.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import UserNotifications

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    var scrollEnabled: Bool = true
    private var previousIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        tabBar.backgroundColor = .white
        tabBar.tintColor = UIColor.ITMOBlue
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard scrollEnabled else {
            return
        }
        guard let index = viewControllers?.index(of: viewController) else {
            return
        }
        if index == previousIndex {
            DispatchQueue.main.async {
                [weak self] () in
                guard let tableView = self?.iterateThroughSubviews(parentView: self?.view) else {
                    return
                }
                tableView.setContentOffset(.zero, animated: true)
            }
        }
        previousIndex = index
    }
    private func iterateThroughSubviews(parentView: UIView?) -> UITableView? {
        guard let view = parentView else {
            return nil
        }
        for subview in view.subviews {
            if let tableView = subview as? UITableView, tableView.scrollsToTop == true {
                if let parentVC = tableView.controller() as? ScheduleViewController {
                    if parentVC.currentPage == 0 {
                        return StudentScheduleLayout.tableView
                    }
                    if parentVC.currentPage == 1 {
                        return ScheduleByGroupsLayout.tableView
                    }
                    if parentVC.currentPage == 2 {
                        return TeachersListLayout.tableView
                    }
                }
                return tableView
            }
            if let tableView = self.iterateThroughSubviews(parentView: subview) {
                return tableView
            }
        }
        return nil
    }
}
extension UITabBarController {
    func buildStudentsTabBar() -> UITabBarController {
        let News = NewsRouter.createModule()
        News.title = NSLocalizedString("Изменения в расписании", comment: "")
        News.tabBarItem = UITabBarItem(title: NSLocalizedString("Новости", comment: ""), image: UIImage(named: "news"), selectedImage: UIImage(named: "news-filled"))
        let Journal = JournalRouter.createModule()
        Journal.title = NSLocalizedString("Журнал", comment: "")
        Journal.tabBarItem = UITabBarItem(title: NSLocalizedString("Журнал", comment: ""), image: UIImage(named: "notes"), selectedImage: UIImage(named: "notes-filled"))
        Journal.tabBarItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -2, right: 0)
        let Messages = MessagesRouter.createModule()
        Messages.title = NSLocalizedString("Сообщения", comment: "")
        Messages.tabBarItem = UITabBarItem(title: NSLocalizedString("Сообщения", comment: ""), image: UIImage(named: "messages"), selectedImage: UIImage(named: "messages-filled"))
        let Schedule = ScheduleRouter.createModule(withMy: true)
        Schedule.title = NSLocalizedString("Расписание", comment: "")
        Schedule.tabBarItem = UITabBarItem(title: NSLocalizedString("Расписание", comment: ""), image: UIImage(named: "schedule"), selectedImage: UIImage(named: "schedule-filled"))
        Schedule.tabBarItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -2, right: 0)
        let Profile = ProfileRouter.createModule()
        Profile.title = NSLocalizedString("Профиль", comment: "")
        Profile.tabBarItem = UITabBarItem(title: NSLocalizedString("Профиль", comment: ""), image: UIImage(named: "profile"), selectedImage: UIImage(named: "profile-filled"))
        let tabBarController = TabBarController()
        let controllers = [News, Journal, Messages, Schedule, Profile]
        let navigationControllers = controllers.map {UINavigationController(rootViewController: $0)}
        tabBarController.viewControllers = navigationControllers
        tabBarController.selectedIndex = UserDefaults.standard.integer(forKey: "firstScreen")
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings { (settings) in
                if settings.authorizationStatus == .authorized {
                    if UserDefaults.standard.string(forKey: "role") != "parent" {
                        updateNotificationContext()
                    }
                }
            }
        }
        return tabBarController
    }
    func buildTeachersTabBar() -> UITabBarController {
        let News = NewsRouter.createModule()
        News.title = NSLocalizedString("Изменения в расписании", comment: "")
        News.tabBarItem = UITabBarItem(title: NSLocalizedString("Новости", comment: ""), image: UIImage(named: "news"), selectedImage: UIImage(named: "news-filled"))
//        let Journal = JournalRouter.createModule()
//        Journal.title = NSLocalizedString("Журнал", comment: "")
//        Journal.tabBarItem = UITabBarItem(title: NSLocalizedString("Журнал", comment: ""), image: UIImage(named: "notes"), selectedImage: UIImage(named: "notes-filled"))
//        Journal.tabBarItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -2, right: 0)
        let Messages = MessagesRouter.createModule()
        Messages.title = NSLocalizedString("Сообщения", comment: "")
        Messages.tabBarItem = UITabBarItem(title: NSLocalizedString("Сообщения", comment: ""), image: UIImage(named: "messages"), selectedImage: UIImage(named: "messages-filled"))
        let Schedule = ScheduleRouter.createModule(withMy: true)
        Schedule.title = NSLocalizedString("Расписание", comment: "")
        Schedule.tabBarItem = UITabBarItem(title: NSLocalizedString("Расписание", comment: ""), image: UIImage(named: "schedule"), selectedImage: UIImage(named: "schedule-filled"))
        Schedule.tabBarItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -2, right: 0)
        let Profile = ProfileRouter.createModule()
        Profile.title = NSLocalizedString("Профиль", comment: "")
        Profile.tabBarItem = UITabBarItem(title: NSLocalizedString("Профиль", comment: ""), image: UIImage(named: "profile"), selectedImage: UIImage(named: "profile-filled"))
        let tabBarController = TabBarController()
        let controllers = [News, Messages, Schedule, Profile]
        let navigationControllers = controllers.map {UINavigationController(rootViewController: $0)}
        tabBarController.viewControllers = navigationControllers
        tabBarController.selectedIndex = UserDefaults.standard.integer(forKey: "firstScreen")
//        if #available(iOS 10.0, *) {
//            let center = UNUserNotificationCenter.current()
//            center.getNotificationSettings { (settings) in
//                if settings.authorizationStatus == .authorized {
//                    updateNotificationContext()
//                }
//            }
//        }
        return tabBarController
    }
}
