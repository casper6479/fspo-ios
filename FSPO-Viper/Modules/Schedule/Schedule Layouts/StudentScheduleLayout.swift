//
//  StudentScheduleLayout.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 15/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation
import LayoutKit

open class StudentScheduleLayout: InsetLayout<View> {
    static var tableView: UITableView?
    public init() {
        var safeHeight: CGFloat = 0
        if #available(iOS 11, *) {
            let safeInset = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom
            safeHeight = UIScreen.main.bounds.height - (UITabBarController().tabBar.frame.height + UINavigationController().navigationBar.frame.height + UIApplication.shared.statusBarFrame.height + safeInset!)
        } else {
            safeHeight = UIScreen.main.bounds.height - (UITabBarController().tabBar.frame.height + UINavigationController().navigationBar.frame.height + UIApplication.shared.statusBarFrame.height)
        }
        super.init(
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
            sublayout: SizeLayout<UITableView>(
                size: CGSize(width: UIScreen.main.bounds.width, height: safeHeight),
                config: {tab in
                    let footer = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
                    tab.tableFooterView = footer
                    StudentScheduleLayout.tableView = tab
            }),
            config: { view in
                view.backgroundColor = .white
        })
    }
}
