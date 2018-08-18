//
//  ScheduleLayout.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 15/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation
import LayoutKit

open class ScheduleLayout: StackLayout<View> {
    public init(withMySchedule: Bool) {
        let studentSchedule = StudentScheduleLayout(withMy: withMySchedule)
        let scheduleByGroups = ScheduleByGroupsLayout(withMy: withMySchedule)
        let teachersList = TeachersListLayout(withMy: withMySchedule)
        var sublayouts = [scheduleByGroups, teachersList]
        if withMySchedule {
            sublayouts = [studentSchedule, scheduleByGroups, teachersList]
        }
        super.init(axis: .horizontal, spacing: 0,
                   sublayouts: sublayouts)
    }
}
