//
//  JournalLayout.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 07/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import LayoutKit

open class JournalLayout: InsetLayout<View> {
    public init(body: String, time: String) {
        let bodyLayout = LabelLayout(text: body, font: (UIFont.ITMOFont?.withSize(17))!)
        let timeLayout = LabelLayout(
            text: time,
            font: UIFont.ITMOFont!,
            config: { label in
                label.textColor = .gray
        })
        let authorLayout = LabelLayout(
            text: "Завилейская Анастасия",
            font: (UIFont.ITMOFont?.withSize(17))!,
            config: { label in
                label.textColor = UIColor.ITMOBlue
        })
        super.init(
            insets: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0),
            sublayout: InsetLayout(
                insets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16),
                sublayout: StackLayout(
                    axis: .horizontal,
                    spacing: 5,
                    sublayouts: [
                        StackLayout(axis: .vertical, spacing: 8, sublayouts: [authorLayout, timeLayout, bodyLayout])
                    ],
                    config: { view in
                        view.backgroundColor = .white
                }),
                config: { view in
                    view.backgroundColor = .white
            }),
            config: { view in
                view.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        })
    }
}
