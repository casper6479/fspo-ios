//
//  ScheduleByTeachersLayout.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 16/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation
import LayoutKit

open class TeachersListLayout: InsetLayout<View> {
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
                    TeachersListLayout.tableView = tab
            }),
            config: { view in
                view.backgroundColor = .white
        })
    }
}
