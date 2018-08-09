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
open class JournalLessonCellLayout: InsetLayout<View> {
    // swiftlint:disable:next cyclomatic_complexity
    public init(data: JSONDecoding.JournalByDateAPI.Exercises) {
        let lessonNameLabel = LabelLayout(text: data.ex_topic, font: (UIFont.ITMOFontBold?.withSize(18))!, config: { label in
            label.backgroundColor = .white
        })
        var presenceText = NSLocalizedString("Присутствие", comment: "")
        if !data.student_presence {
            presenceText = NSLocalizedString("Отсутствие", comment: "")
        }
        let presenceTextLabel = LabelLayout(text: presenceText, font: UIFont.ITMOFont!.withSize(15), config: { label in
            if data.student_presence {
                label.textColor = UIColor(red: 0, green: 148/255, blue: 77/255, alpha: 1.0)
            } else {
                label.textColor = .red
            }
            label.backgroundColor = .white
        })
        var lessonTypeText = ""
        switch data.ex_type {
        case "1":
            lessonTypeText = NSLocalizedString("лекция", comment: "")
        case "2":
            lessonTypeText = NSLocalizedString("лабараторная", comment: "")
        case "3":
            lessonTypeText = NSLocalizedString("аттестация", comment: "")
        case "4":
            lessonTypeText = NSLocalizedString("зачёт", comment: "")
        case "5":
            lessonTypeText = NSLocalizedString("экзамен", comment: "")
        case "6":
            lessonTypeText = NSLocalizedString("практическая", comment: "")
        case "8":
            lessonTypeText = NSLocalizedString("контрольная работа", comment: "")
        default:
            lessonTypeText = ""
        }
        let lessonType = LabelLayout(text: "\(NSLocalizedString("Тип пары", comment: "")): \(lessonTypeText)", font: UIFont.ITMOFont!.withSize(15), config: { label in
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
        var sublayoutsForVerticalLike: [Layout] = [StackLayout(
            axis: .vertical,
            spacing: 16,
            sublayouts: [presenceTextLabel, lessonType])]
        var sublayouts: [Layout] = [lessonNameLabel]
        var optionalTexts = ["\(String(describing: data.student_mark))", "\(String(describing: data.student_delay))", "\(data.student_dropout)", "\(String(describing: data.student_performance))"]
        if optionalTexts[0] != "nil" {
            let noteLabel = LabelLayout(text: "\(NSLocalizedString("Оценка", comment: "")): \(data.student_mark!)", font: UIFont.ITMOFont!.withSize(15), config: { label in
                    label.textColor = .black
                    label.backgroundColor = .white
            })
            sublayouts.append(noteLabel)
        }
        if optionalTexts[1] != "nil" {
            var delayText = ""
            switch optionalTexts[1] {
            case "Optional(\"1\")":
                delayText = NSLocalizedString("Опоздание", comment: "")
            case "Optional(\"2\")":
                delayText = NSLocalizedString("Ранний уход", comment: "")
            case "Optional(\"3\")":
                delayText = NSLocalizedString("Опоздание и ранний уход", comment: "")
            default:
                delayText = ""
            }
            let delayLabel = LabelLayout(text: delayText, font: UIFont.ITMOFont!.withSize(15), config: { label in
                label.textColor = UIColor.ITMORed
                label.backgroundColor = .white
            })
            sublayouts.append(delayLabel)
        }
        if optionalTexts[2] == "true" {
            let dropoutLabel = LabelLayout(text: NSLocalizedString("Удаление с занятия", comment: ""), font: UIFont.ITMOFont!.withSize(15), config: { label in
                label.textColor = UIColor.ITMORed
                label.backgroundColor = .white
            })
            sublayouts.append(dropoutLabel)
        }
        if optionalTexts[3] != "nil" {
            let perfomanceImage = SizeLayout<UIImageView>(
                size: CGSize(width: 50, height: 50),
                config: {imageView in
                    if optionalTexts[3] == "Optional(\"1\")" {
                        imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                        imageView.image = UIImage(named: "like")
                    }
                    if optionalTexts[3] == "Optional(\"2\")" {
                        imageView.transform = CGAffineTransform(scaleX: 1, y: -1)
                        imageView.image = UIImage(named: "dislike")
                    }
            })
            sublayoutsForVerticalLike.append(perfomanceImage)
        }
        let typePresenseLikeStack = StackLayout(
            axis: .horizontal,
            sublayouts: sublayoutsForVerticalLike)
        sublayouts.insert(typePresenseLikeStack, at: 1)
        let bodyStack = StackLayout(
            axis: .vertical,
            spacing: 16,
            sublayouts: sublayouts)
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
            text: NSLocalizedString("В этот день занятий не было", comment: ""),
            font: UIFont.ITMOFontBold!.withSize(20),
            alignment: .topCenter,
            config: {label in
                label.textAlignment = .center
        })
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
    public init(text: String, inset: CGFloat) {
        super.init(
            insets: UIEdgeInsets(top: 4, left: inset, bottom: 0, right: 0),
            sublayout: SizeLayout(height: 22, sublayout: LabelLayout(
                text: text,
                font: UIFont.ITMOFontBold!.withSize(17),
                numberOfLines: 1,
                config: {label in
                    label.textColor = .white
                    label.backgroundColor = UIColor.ITMOBlue
                    label.lineBreakMode = .byTruncatingTail
            }), config: {view in
                view.backgroundColor = UIColor.ITMOBlue
            }),
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
        UIApplication.shared.keyWindow?.rootViewController?.childViewControllers[1].show(JournalByTeacherRouter.createModule(lessonId: Int((JournalByDateViewController.publicDS?.exercises[indexPath.section].lesson_id)!)!), sender: JournalByDateViewController())
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
