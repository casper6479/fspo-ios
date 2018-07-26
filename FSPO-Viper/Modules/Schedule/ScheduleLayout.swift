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
    public init() {
        let studentSchedule = StudentScheduleLayout()
        let scheduleByGroups = ScheduleByGroupsLayout()
        let teachersList = TeachersListLayout()
        super.init(axis: .horizontal, spacing: 0,
                   sublayouts: [
                    studentSchedule, scheduleByGroups, teachersList])
    }
}
