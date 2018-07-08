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
    public init(dolgs: String, percent: String, score: String) {
        let byDate = SizeLayout(
            size: CGSize(width: 127, height: 40),
            sublayout: ButtonLayout(
                type: .custom,
                title: "По дате",
                alignment: .center,
                config: { button in
                    button.backgroundColor = UIColor.ITMOBlue
                    button.setTitleColor(.white, for: .normal)
                    button.setTitleColor(.lightGray, for: .highlighted)
                    button.titleLabel?.font = UIFont.ITMOFontBold?.withSize(17)
                }),
            config: { view in
                view.backgroundColor = UIColor.ITMOBlue
                view.layer.cornerRadius = 20
                view.layer.masksToBounds = true
        })
        let bySubject = SizeLayout(
            size: CGSize(width: 127, height: 40),
            sublayout: ButtonLayout(
                type: .custom,
                title: "По предметам",
                alignment: .center,
                config: { button in
                    button.backgroundColor = UIColor.ITMOBlue
                    button.setTitleColor(.white, for: .normal)
                    button.setTitleColor(.lightGray, for: .highlighted)
                    button.titleLabel?.font = UIFont.ITMOFontBold?.withSize(17)
                }),
            config: { view in
                view.backgroundColor = UIColor.ITMOBlue
                view.layer.cornerRadius = 20
                view.layer.masksToBounds = true
        })
        let more = SizeLayout(
            size: CGSize(width: 100, height: 29),
            alignment: .center,
            sublayout: ButtonLayout(
                type: .custom,
                title: "Подробнее",
                alignment: .center,
                config: { button in
                    button.backgroundColor = UIColor.ITMOBlue
                    button.setTitleColor(.white, for: .normal)
                    button.setTitleColor(.lightGray, for: .highlighted)
                    button.titleLabel?.font = UIFont.ITMOFontBold?.withSize(17)
            }),
            config: { view in
                view.backgroundColor = UIColor.ITMOBlue
                view.layer.cornerRadius = 29/2
                view.layer.masksToBounds = true
        })
        let avgScoreLabel = LabelLayout(text: "3.5", font: UIFont.ITMOFontBold!.withSize(24), alignment: .center)
        let avgScorePlaceholder = LabelLayout(text: "Средний балл", font: UIFont.ITMOFont!, alignment: .center)
        let avgScoreStack = StackLayout(axis: .vertical, spacing: 8, sublayouts: [avgScorePlaceholder, avgScoreLabel])
        let dolgsLabel = LabelLayout(text: "1", font: UIFont.ITMOFontBold!.withSize(24), alignment: .center)
        let dolgsPlaceholder = LabelLayout(text: "Долгов", font: UIFont.ITMOFont!, alignment: .center)
        let dolgsStack = StackLayout(axis: .vertical, spacing: 8, sublayouts: [dolgsPlaceholder, dolgsLabel])
        let precenseLabel = LabelLayout(text: "95%", font: UIFont.ITMOFontBold!.withSize(24), alignment: .center)
        let precensePlaceholder = LabelLayout(text: "Посещения", font: UIFont.ITMOFont!, alignment: .center)
        let precenseStack = StackLayout(axis: .vertical, spacing: 8, sublayouts: [precensePlaceholder, precenseLabel])
        let horizontalStack = StackLayout(axis: .horizontal,
                                          distribution: .fillEqualSize,
                                          sublayouts: [avgScoreStack, dolgsStack, precenseStack])
        let border = SizeLayout<UIView>(
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height / 3,
            alignment: .center,
            sublayout: InsetLayout(
                insets: UIEdgeInsets(top: 32, left: 0, bottom: 32, right: 0),
                sublayout: StackLayout(
                    axis: .vertical,
                    spacing: UIScreen.main.bounds.height / 20,
                    alignment: .bottomCenter,
                    sublayouts: [horizontalStack, more])),
            config: { view in
                view.layer.cornerRadius = 20
                view.layer.masksToBounds = true
                view.backgroundColor = UIColor.backgroundGray
        })
        super.init(
            insets: UIEdgeInsets(top: 16, left: 8, bottom: 8, right: 8),
            sublayout: StackLayout(
                axis: .vertical,
                spacing: UIScreen.main.bounds.height / 10,
                sublayouts: [
                    border,
                    StackLayout(axis: .vertical, spacing: UIScreen.main.bounds.height / 12, sublayouts: [byDate, bySubject])
                ]
            ),
            config: { view in
                view.backgroundColor = UIColor.white
        })
    }
}
