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
        var textColor: UIColor?
        var alignment: Alignment
        var fontSize = 16
        let font = UIFont.MessagesFont?.withSize(CGFloat(fontSize))
        switch isMe {
        case true:
            textColor = .white
            backgroundColor = UIColor(red: 58/255, green: 123/255, blue: 246/255, alpha: 1)
            alignment = .centerTrailing
        default:
            textColor = UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 1)
            backgroundColor = .white
            alignment = .centerLeading
        }
        let constraintRect = CGSize(width: UIScreen.main.bounds.width - 84, height: .greatestFiniteMagnitude)
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byWordWrapping
        let bigFontBoundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: (font!.withSize(CGFloat(16))), .paragraphStyle: style], context: nil)
        if bigFontBoundingBox.width < 150 {
            fontSize = 20
        }
        let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: (font!.withSize(CGFloat(fontSize))), .paragraphStyle: style], context: nil)

        var width = ceil(boundingBox.width)
        let height = ceil(boundingBox.height)
        if width > UIScreen.main.bounds.width - 100 {
            width = UIScreen.main.bounds.width - 84
        }
        if width < 16 {
            width = 16
        }
        let subText: Layout = LabelLayout(
            text: text,
            font: (font?.withSize(CGFloat(fontSize)))!,
            alignment: .center,
            config: { label in
                label.textAlignment = .left
                label.backgroundColor = .clear
                label.textColor = textColor
        })
        let bubble = SizeLayout(
            width: width + 16,
            height: height + 16,
            alignment: alignment,
            sublayout: InsetLayout<InsetView>(
                insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8),
                sublayout: subText,
                config: { inse in
                    inse.backgroundColor = backgroundColor
                    inse.layer.cornerRadius = 16
                    inse.layer.shadowColor = textColor?.cgColor
                    inse.layer.shadowOffset = CGSize(width: 0, height: 2)
                    inse.layer.shadowRadius = 2
                    inse.layer.shadowOpacity = 0.1
            }),
            config: { view in
                view.backgroundColor = UIColor(red: 246/255, green: 251/255, blue: 254/255, alpha: 1)
        })
        super.init(
            insets: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8),
            sublayout: bubble,
            config: { view in
                view.backgroundColor = UIColor(red: 246/255, green: 251/255, blue: 254/255, alpha: 1)
        })
    }
}
class DialogsReloadableViewLayoutAdapter: ReloadableViewLayoutAdapter {
}
