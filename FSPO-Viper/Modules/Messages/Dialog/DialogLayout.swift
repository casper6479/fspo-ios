//
//  DialogLayout.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 05/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation
import LayoutKit

open class DialogsLayout: InsetLayout<View> {
    public init(text: String, isMe: Bool) {
        var backgroundColor: UIColor?
        var alignment: Alignment
        switch isMe {
        case true:
            backgroundColor = .red
            alignment = .centerTrailing
        default:
            backgroundColor = .blue
            alignment = .centerLeading
        }
        let constraintRect = CGSize(width: 0, height: 17)
        let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: (UIFont.ITMOFont?.withSize(17))!], context: nil)
        var width = ceil(boundingBox.width)
        let constraintRectForHeight = CGSize(width: UIScreen.main.bounds.width - 84, height: .greatestFiniteMagnitude)
        let boundingBoxForHeight = text.boundingRect(with: constraintRectForHeight, options: .usesLineFragmentOrigin, attributes: [.font: (UIFont.ITMOFont?.withSize(17))!], context: nil)
        let height = ceil(boundingBoxForHeight.height)
        if width > UIScreen.main.bounds.width - 100 {
            width = UIScreen.main.bounds.width - 84
        }
        if width < 17 {
            width = 17
        }
        let test = SizeLayout(
            width: width + 16,
            height: height + 16,
            alignment: alignment,
            sublayout: InsetLayout(
                insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8),
                sublayout: LabelLayout(
                    text: text,
                    font: (UIFont.ITMOFont?.withSize(17))!,
                    alignment: .center,
                    config: { label in
                        label.textAlignment = .left
                        label.backgroundColor = backgroundColor
                        label.textColor = .white
                    }),
                config: { inse in
                    inse.backgroundColor = backgroundColor
                    inse.layer.cornerRadius = 17
            }),
            config: { view in
                view.backgroundColor = .white
        })
        super.init(
            insets: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8),
            sublayout: test,
            config: { view in
                view.backgroundColor = .white
        })
    }
}
class DialogsReloadableViewLayoutAdapter: ReloadableViewLayoutAdapter {
}
