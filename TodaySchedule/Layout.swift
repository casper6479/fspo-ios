//
//  Layout.swift
//  TodaySchedule
//
//  Created by Николай Борисов on 10/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import LayoutKit

open class StudentScheduleCellLayout: InsetLayout<View> {
    public init(schedule: JSONDecoding.StudentScheduleApi.Weekdays.Periods, type: String) {
        var scheduleCell = [Layout]()
        let paraCount = LabelLayout(text: "\(schedule.period)", font: UIFont.boldSystemFont(ofSize: 15), alignment: .centerTrailing, config: {label in
            label.textColor = label.textColor.withAlphaComponent(0.8)
        })
        var leftPartSublayouts: [Layout] = [paraCount]
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "HH:mm"
        let start = dateFormatter.date(from: schedule.period_start)
        let end = dateFormatter.date(from: schedule.period_end)
        let start_time = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: start!), minute: Calendar.current.component(.minute, from: start!), second: 0, of: Date())
        let end_time = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: end!), minute: Calendar.current.component(.minute, from: end!), second: 0, of: Date())
        var leftwidth: CGFloat = 16
        if Date() > start_time! && Date() < end_time! {
            leftPartSublayouts.append(SizeLayout(width: 4, config: {view in
                view.backgroundColor = UIColor(red: 1, green: 222/255, blue: 23/255, alpha: 1.0)
                view.layer.cornerRadius = 2
            }))
            leftwidth += 12
        }
        let leftPartSize = SizeLayout(width: leftwidth, sublayout: StackLayout(
            axis: .horizontal,
            spacing: 8,
            sublayouts: leftPartSublayouts))
        for item in schedule.schedule {
            var name = item.name
            if item.group_part != 0 {
                name = "\(item.group_part):\(name)"
            }
            var place = item.place
            switch place {
            case "Ушинского":
                place = "У"
            case "Спортзал":
                place = "С"
            case "Ломоносова":
                place = "Л"
            default:
                place = item.place
            }
            var paraLabel = name
            if type == "teacher" {
                paraLabel = item.group_name
            }
            let paraName = LabelLayout(text: paraLabel, font: UIFont.systemFont(ofSize: 15), config: {label in
                label.textColor = label.textColor.withAlphaComponent(0.8)
            })
            let auditory = LabelLayout(text: place, font: UIFont.systemFont(ofSize: 16), alignment: .center, config: {label in
                label.textAlignment = .center
                label.textColor = label.textColor.withAlphaComponent(0.8)
            })
            let middlePart = StackLayout(axis: .vertical, sublayouts: [paraName])
            let extensionWidth = UIScreen.main.bounds.width - 16
            let middlePartSize = SizeLayout(width: extensionWidth - 74 - leftwidth, sublayout: middlePart)
            let rightPartSize = auditory
            scheduleCell.append(StackLayout(
                axis: .horizontal,
                spacing: 5,
                sublayouts: [middlePartSize, rightPartSize]))
        }
        super.init(
            insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 16),
            sublayout: StackLayout(
                axis: .horizontal,
                spacing: 13,
                sublayouts: [leftPartSize,
                             StackLayout(
                                axis: .vertical,
                                spacing: 8,
                                sublayouts: scheduleCell
                    )]
            ))
    }
}
open class NoScheduleCellLayout: InsetLayout<View> {
    public init() {
        super.init(
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
            sublayout: SizeLayout(
                size: CGSize(width: 200, height: 110),
                sublayout: LabelLayout(
                    text: NSLocalizedString("Занятий нет", comment: ""),
                    font: UIFont.boldSystemFont(ofSize: 15),
                    alignment: .center,
                    config: {label in
                        label.textAlignment = .center
                        label.textColor = label.textColor.withAlphaComponent(0.8)
                }
            )))
    }
}
