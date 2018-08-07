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
    public init(schedule: JSONDecoding.StudentScheduleApi.Weekdays.Periods, subjects: Int) {
        var i = 0
        var scheduleCell = [Layout]()
        let paraCount = LabelLayout(text: "\(schedule.period)", font: (UIFont.ITMOFontBold?.withSize(23))!, alignment: .center)
        let timeBegin = LabelLayout(text: "\(schedule.period_start)", font: (UIFont.ITMOFont?.withSize(16))!, alignment: .center)
        let timeEnd = LabelLayout(text: "\(schedule.period_end)", font: (UIFont.ITMOFont?.withSize(16))!, alignment: .center)
        let leftPart = SizeLayout(height: 63, sublayout: StackLayout(axis: .vertical, spacing: 4, sublayouts: [paraCount, timeBegin, timeEnd]))
        let leftPartSize = SizeLayout(width: 50, sublayout: leftPart)
        while i < schedule.schedule.count {
            let paraName = LabelLayout(text: schedule.schedule[i].name, font: (UIFont.ITMOFontBold?.withSize(20))!)
            let teacher = LabelLayout(text: "\(schedule.schedule[i].lastname) \(schedule.schedule[i].firstname) \(schedule.schedule[i].middlename)", font: (UIFont.ITMOFont?.withSize(13))!, alignment: .bottomLeading)
            let auditory = LabelLayout(text: schedule.schedule[i].place, font: (UIFont.ITMOFont?.withSize(17))!, alignment: .center)
            let middlePart = StackLayout(axis: .vertical, sublayouts: [paraName, teacher])
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
            i+=1
        }
        super.init(
            insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8),
            sublayout: StackLayout(
                axis: .horizontal,
                spacing: 8,
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
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.backgroundView?.backgroundColor = UIColor.ITMOBlue
        header?.textLabel?.font = UIFont.ITMOFontBold?.withSize(17)
        header?.textLabel?.textColor = .white
    }
}
