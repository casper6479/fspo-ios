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
    public init(subject: String, teacher: String, subjects: Int) {
        let paraCount = LabelLayout(text: "1", font: (UIFont.ITMOFontBold?.withSize(23))!, alignment: .center)
        let timeBegin = LabelLayout(text: "9:00", font: (UIFont.ITMOFont?.withSize(16))!, alignment: .center)
        let timeEnd = LabelLayout(text: "10:30", font: (UIFont.ITMOFont?.withSize(16))!, alignment: .center)
        let paraName = LabelLayout(text: "Предмет", font: (UIFont.ITMOFontBold?.withSize(20))!)
        let teacher = LabelLayout(text: "Препод", font: (UIFont.ITMOFont?.withSize(13))!, alignment: .bottomLeading)
        let auditory = LabelLayout(text: "Ауд", font: (UIFont.ITMOFont?.withSize(17))!, alignment: .center)
        let leftPart = SizeLayout(height: 63, sublayout: StackLayout(axis: .vertical, spacing: 4, sublayouts: [paraCount, timeBegin, timeEnd]))
        let middlePart = StackLayout(axis: .vertical, sublayouts: [paraName, teacher])
        let rightPart = auditory
        let leftPartSize = SizeLayout(width: 50, sublayout: leftPart)
        let middlePartSize = SizeLayout(width: UIScreen.main.bounds.width - 150, sublayout: middlePart)
        let rightPartSize = SizeLayout(width: 100, sublayout: rightPart)
        /*var subjectsArr = [Layout]()
        for _ in 0...subjects {
            subjectsArr.append(<#T##newElement: Layout##Layout#>)
        }*/
        super.init(
            insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8),
            sublayout: StackLayout(
                    axis: .horizontal,
                    spacing: 5,
                    sublayouts: [
                        leftPartSize, middlePartSize, rightPartSize
                    ],
                    config: { view in
                        view.backgroundColor = .white
                }),
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
        header?.textLabel?.textColor = .white
    }
}
