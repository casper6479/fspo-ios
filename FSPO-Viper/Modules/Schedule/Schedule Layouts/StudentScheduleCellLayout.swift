//
//  StudentScheduleCellLayout.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 02/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation
import UIKit
import LayoutKit
open class StudentScheduleCellLayout: InsetLayout<View> {
    // swiftlint:disable:next cyclomatic_complexity
    public init(schedule: JSONDecoding.StudentScheduleApi.Weekdays.Periods, type: String, isToday: Bool) {
        var scheduleCell = [Layout]()
        let paraCount = LabelLayout(text: "\(schedule.period)", font: (UIFont.ITMOFontBold?.withSize(23))!, alignment: .center, config: {label in
            label.backgroundColor = .white
        })
        let timeBegin = LabelLayout(text: "\(schedule.period_start)", font: (UIFont.ITMOFont?.withSize(16))!, alignment: .center, config: {label in
            label.backgroundColor = .white
        })
        let timeEnd = LabelLayout(text: "\(schedule.period_end)", font: (UIFont.ITMOFont?.withSize(16))!, alignment: .center, config: {label in
            label.backgroundColor = .white
        })
        var leftPartSublayouts: [Layout] = [StackLayout(
            axis: .vertical,
            spacing: 4,
            sublayouts: [paraCount, timeBegin, timeEnd])]
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "HH:mm"
        let start = dateFormatter.date(from: schedule.period_start)
        let end = dateFormatter.date(from: schedule.period_end)
        let start_time = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: start!), minute: Calendar.current.component(.minute, from: start!), second: 0, of: Date())
        let end_time = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: end!), minute: Calendar.current.component(.minute, from: end!), second: 0, of: Date())
        if Date() > start_time! && Date() < end_time! {
            if isToday {
                leftPartSublayouts.append(SizeLayout(width: 3, config: {view in
                    view.backgroundColor = UIColor(red: 1, green: 222/255, blue: 23/255, alpha: 1.0)
                    view.layer.cornerRadius = 1.5
                }))
            }
        }
        let leftPart = SizeLayout(
            height: 63,
            sublayout: StackLayout(
                axis: .horizontal,
                spacing: 6,
                sublayouts: leftPartSublayouts)
        )
        let leftPartSize = SizeLayout(width: 50, sublayout: leftPart)
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
            var color = UIColor.black
            if item.even != nil {
                color = UIColor.ITMOBlue
            }
            if item.odd != nil {
                color = UIColor.ITMORed
            }
            let paraName = LabelLayout(text: name, font: (UIFont.ITMOFontBold?.withSize(20))!, config: { label in
                label.textColor = color
                label.backgroundColor = .white
            })
            var teacher = LabelLayout(text: "\(item.lastname) \(item.firstname) \(item.middlename)", font: (UIFont.ITMOFont?.withSize(13))!, alignment: .bottomLeading, config: {label in
                label.backgroundColor = .white
            })
            if type == "teacher" {
                teacher = LabelLayout(text: "\(item.group_name)", font: (UIFont.ITMOFont?.withSize(13))!, alignment: .bottomLeading, config: {label in
                    label.backgroundColor = .white
                })
            }
            let auditory = LabelLayout(text: place, font: (UIFont.ITMOFont?.withSize(17))!, alignment: .center, config: { label in
                label.textColor = color
                label.backgroundColor = .white
            })
            let middlePart = StackLayout(axis: .vertical, spacing: 8, sublayouts: [paraName, teacher])
            let rightPart = auditory
            let middlePartSize = SizeLayout(width: UIScreen.main.bounds.width - 120, sublayout: middlePart)
            let rightPartSize = SizeLayout(width: 70, sublayout: rightPart)
            scheduleCell.append(StackLayout(
                    axis: .horizontal,
                    spacing: 5,
                    sublayouts: [middlePartSize, rightPartSize],
                    config: { view in
                        view.backgroundColor = .white
                }))
        }
        super.init(
            insets: UIEdgeInsets(top: 8, left: 6, bottom: 8, right: 6),
            sublayout: StackLayout(
                axis: .horizontal,
                spacing: 6,
                sublayouts: [leftPartSize,
                             StackLayout(
                                axis: .vertical,
                                spacing: 8,
                                sublayouts: scheduleCell
                            )]
                ),
            config: { view in
                view.backgroundColor = .white
        })
    }
}
open class NoScheduleCellLayout: InsetLayout<View> {
    public init() {
        super.init(
            insets: UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0),
            sublayout: LabelLayout(
                text: NSLocalizedString("Занятий нет", comment: ""),
                font: UIFont.ITMOFontBold!.withSize(18),
                alignment: .center),
            config: { view in
                view.backgroundColor = .white
        })
    }
}
class StudentScheduleReloadableLayoutAdapter: ReloadableViewLayoutAdapter {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let weekdays = [NSLocalizedString("Понедельник", comment: ""),
                        NSLocalizedString("Вторник", comment: ""),
                        NSLocalizedString("Среда", comment: ""),
                        NSLocalizedString("Четверг", comment: ""),
                        NSLocalizedString("Пятница", comment: ""),
                        NSLocalizedString("Суббота", comment: "")]
        return weekdays[section]
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.backgroundView?.backgroundColor = UIColor.ITMOBlue
        header?.textLabel?.font = UIFont.ITMOFontBold?.withSize(17)
        header?.textLabel?.backgroundColor = UIColor.ITMOBlue
        var day = Calendar.current.component(.weekday, from: Date())
        day -= 2
        if section == day {
            header?.backgroundView?.backgroundColor = UIColor(red: 65/255, green: 182/255, blue: 69/255, alpha: 1.0)
            header?.textLabel?.backgroundColor = UIColor(red: 65/255, green: 182/255, blue: 69/255, alpha: 1.0)
        }
        header?.textLabel?.textColor = .white
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = currentArrangement[indexPath.section].items[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReloadableViewLayoutAdapter.self), for: indexPath)
        DispatchQueue.main.async {
            item.makeViews(in: cell.contentView)
        }
        return cell
    }
}
