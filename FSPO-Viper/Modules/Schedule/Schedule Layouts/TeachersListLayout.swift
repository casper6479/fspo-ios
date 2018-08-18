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
    public init(withMy: Bool) {
        let height = withMy ? Constants.safeHeight : Constants.safeHeight + UITabBarController().tabBar.frame.height
        super.init(
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
            sublayout: SizeLayout<UITableView>(
                size: CGSize(width: UIScreen.main.bounds.width, height: height),
                config: {tab in
                    tab.separatorInset = UIEdgeInsets(top: 0, left: 66, bottom: 0, right: 0)
                    TeachersListLayout.tableView = tab
            }),
            config: { view in
                view.backgroundColor = .white
        })
    }
}
