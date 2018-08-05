//
//  JournalByDateLayout.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 05/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation
import LayoutKit

open class JournalByDateLayout: InsetLayout<View> {
    public init() {
        let datePicker = SizeLayout<UIDatePicker>(size: CGSize(width: UIScreen.main.bounds.width, height: 100), config: { datePicker in
            datePicker.setValue(UIColor.white, forKey: "textColor")
            datePicker.timeZone = .current
            datePicker.datePickerMode = .date
            datePicker.backgroundColor = UIColor.ITMOBlue
        })
        super.init(
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
            sublayout: datePicker,
            config: { view in
                view.backgroundColor = UIColor.white
        })
    }
}
