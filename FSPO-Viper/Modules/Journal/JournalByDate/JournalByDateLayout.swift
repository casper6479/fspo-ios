//
//  JournalByDateLayout.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 05/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation
import LayoutKit
import UIKit
open class JournalByDateLayout: InsetLayout<View> {
    static var datePicker = UIDatePicker()
    public init() {
        let datePicker = SizeLayout<UIDatePicker>(size: CGSize(width: UIScreen.main.bounds.width, height: 100), config: { datePicker in
            datePicker.setValue(UIColor.white, forKey: "textColor")
            datePicker.timeZone = .current
            datePicker.datePickerMode = .date
            datePicker.backgroundColor = UIColor.ITMOBlue
            datePicker.addTarget(JournalByDateViewController(), action: #selector(JournalByDateViewController().dateDidChanged), for: .valueChanged)
            JournalByDateLayout.datePicker = datePicker
        })
        super.init(
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
            sublayout: datePicker,
            config: { view in
                view.backgroundColor = UIColor.white
        })
    }
}
open class JournalByDateCellLayout: InsetLayout<View> {
    public init(data: JSONDecoding.JournalByDateAPI.Exercises) {
        let lessonNameLabel = LabelLayout(text: data.ex_topic, font: (UIFont.ITMOFontBold?.withSize(18))!, config: { label in
            label.backgroundColor = .white
        })
        let presenceTextLabel = LabelLayout(text: "Присутствие: ", font: UIFont.ITMOFont!.withSize(15), config: { label in
            label.backgroundColor = .white
        })
        let presenceLabel = LabelLayout(text: "\(data.student_presence)", font: UIFont.ITMOFont!.withSize(15), config: { label in
            label.backgroundColor = .white
            label.textColor = .green
        })
        let presenceStack = StackLayout(axis: .horizontal, sublayouts: [presenceTextLabel, presenceLabel])
        let lessonType = LabelLayout(text: "Тип пары: \(data.ex_type)", font: UIFont.ITMOFont!.withSize(15), config: { label in
            label.textColor = UIColor.ITMOBlue
            label.backgroundColor = .white
        })
        let lessonNumberLabel = LabelLayout(
            text: data.ex_period,
            font: UIFont.ITMOFontBold!.withSize(21),
            alignment: .topCenter,
            config: { label in
                label.backgroundColor = .white
        })
        let lessonNumber = SizeLayout(width: 40, sublayout: lessonNumberLabel)
        let bodyStack = StackLayout(
            axis: .vertical,
            spacing: 16,
            sublayouts: [lessonNameLabel, presenceStack, lessonType])
        let mainStack = StackLayout(axis: .horizontal, sublayouts: [lessonNumber, bodyStack])
        super.init(
            insets: UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 16),
            sublayout: mainStack,
            config: { view in
                view.backgroundColor = UIColor.white
        })
    }
}
open class NoLessonsLayout: InsetLayout<View> {
    static var noLessonView = UIView()
    public init() {
        let noLessons = LabelLayout(
            text: "В этот день занятий не было",
            font: UIFont.ITMOFontBold!.withSize(20),
            alignment: .topCenter)
        super.init(
            insets: UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0),
            sublayout: noLessons,
            config: { view in
                NoLessonsLayout.noLessonView = view
                view.backgroundColor = UIColor.white
        })
    }
}
open class HeaderLayout: InsetLayout<UITableViewHeaderFooterView> {
    public init(text: String) {
        super.init(
            insets: UIEdgeInsets(top: 4, left: 40, bottom: 0, right: 0),
            sublayout: SizeLayout(height: 22, sublayout: LabelLayout(
                text: text,
                font: UIFont.ITMOFontBold!.withSize(17),
                numberOfLines: 1,
                config: {label in
                    label.textColor = .white
                    label.lineBreakMode = .byTruncatingTail
            })),
            config: {header in
                let background = UIView()
                background.backgroundColor = UIColor.ITMOBlue
                header.backgroundView = background
        })
    }
}
//let header = view as? UITableViewHeaderFooterView
//header?.backgroundView?.backgroundColor = UIColor.ITMOBlue
//header?.textLabel?.font = UIFont.ITMOFontBold?.withSize(17)
//header?.textLabel?.textColor = .white
class JournalByDateReloadableLayoutAdapter: ReloadableViewLayoutAdapter {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.keyWindow?.rootViewController?.childViewControllers[1].show(JournalByTeacherRouter.createModule(), sender: JournalByDateViewController())
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
