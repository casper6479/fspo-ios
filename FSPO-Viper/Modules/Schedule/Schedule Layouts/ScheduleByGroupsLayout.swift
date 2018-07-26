//
//  ScheduleByGroupsLayout.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 16/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation
import LayoutKit

open class ScheduleByGroupsLayout: InsetLayout<View> {
    public init() {
        super.init(
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
            sublayout: SizeLayout(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), sublayout: LabelLayout(text: "ScheduleByGroups")),
            config: { view in
                view.backgroundColor = .white
        })
    }
}
