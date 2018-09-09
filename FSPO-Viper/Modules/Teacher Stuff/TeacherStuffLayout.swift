//
//  TeacherStuffLayout.swift
//  FSPO
//
//  Created by Николай Борисов on 06/09/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import LayoutKit

final class TeacherStuffLayout: InsetLayout<View> {
    public init() {
        let createButtonTitle = NSLocalizedString("Создать занятие", comment: "")
        let pastLessonsTitle = NSLocalizedString("Проведённые занятия", comment: "")
        let journalTitle = NSLocalizedString("Журнал", comment: "")
        let studentsListTitle = NSLocalizedString("Список студентов", comment: "")
        let font = UIFont.ITMOFontBold!.withSize(17)
        let createButton = Button().createUnactiveButton(
            title: createButtonTitle,
            width: createButtonTitle.width(withConstrainedHeight: 17, font: font) + 30,
            height: 40,
            alignment: .center)
        let pastLessonsButton = Button().createUnactiveButton(
            title: pastLessonsTitle,
            width: pastLessonsTitle.width(withConstrainedHeight: 17, font: font) + 30,
            height: 40,
            alignment: .center)
        let journalButton = Button().createUnactiveButton(
            title: journalTitle,
            width: journalTitle.width(withConstrainedHeight: 17, font: font) + 30,
            height: 40,
            alignment: .center)
        let studentsListButton = Button().createUnactiveButton(
            title: studentsListTitle,
            width: studentsListTitle.width(withConstrainedHeight: 17, font: font) + 30,
            height: 40,
            alignment: .center)
        let whatButton = Button().createButton(
            title: "?",
            width: 40,
            height: 40,
            alignment: .center,
            target: TeacherStuffViewController(),
            action: #selector(TeacherStuffViewController().whatUpInside))
        let sublayouts = [createButton, pastLessonsButton, journalButton, studentsListButton, whatButton]
        let spacing = (Constants.safeHeight - 160 - 128) / CGFloat(sublayouts.count - 1)
        let buttonsStack = StackLayout(
            axis: .vertical,
            spacing: spacing,
            alignment: .center,
            sublayouts: sublayouts)
        let sizeLayout = SizeLayout(
            size: CGSize(width: UIScreen.main.bounds.width, height: Constants.safeHeight),
            sublayout: buttonsStack)
        super.init(
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
            alignment: .center,
            sublayout: sizeLayout
        )
    }
}
