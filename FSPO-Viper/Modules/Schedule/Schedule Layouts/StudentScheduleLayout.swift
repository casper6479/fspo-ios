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
        super.init(
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
            sublayout: SizeLayout(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), sublayout: SizeLayout<UITableView>(
                size: UIScreen.main.bounds.size,
                config: {tab in
                    let footer = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
                    tab.tableFooterView = footer
                    StudentScheduleLayout.tableView = tab
            })),
            config: { view in
                view.backgroundColor = .white
        })
    }
}
