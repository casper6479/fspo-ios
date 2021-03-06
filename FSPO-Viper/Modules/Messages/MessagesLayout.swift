//
//  MessagesLayout.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 14/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation
import LayoutKit
import Kingfisher
import UIKit

open class MessagesLayout: InsetLayout<View> {
    public init(name: String, lastMessage: String, photo: String, date: String) {
        let nameLayout = LabelLayout(
            text: name,
            font: (UIFont.ITMOFont?.withSize(16))!,
            numberOfLines: 1,
            alignment: .centerLeading,
            flexibility: .flexible,
            config: { label in
                label.textAlignment = .left
                label.backgroundColor = .white
        })
        let lastMessageLayout = SizeLayout<UILabel>(
            size: CGSize(width: UIScreen.main.bounds.width - 84, height: 15),
            config: { label in
                label.text = lastMessage
                label.font = UIFont.LongTextFont!.withSize(14)
                label.numberOfLines = 1
                label.textColor = .gray
                label.backgroundColor = .white
        })
        let dateLayout = LabelLayout(
            text: date,
            font: UIFont.ITMOFont!.withSize(14),
            numberOfLines: 1,
            alignment: .fillTrailing,
            flexibility: .inflexible,
            config: { label in
                label.textAlignment = .right
                label.textColor = .gray
                label.backgroundColor = .white
        })
        let nameDateStack = StackLayout(
            axis: .horizontal,
            spacing: 8,
            sublayouts: [nameLayout, dateLayout]
        )
        let contentVerticalStack = StackLayout(
            axis: .vertical,
            spacing: 8,
            alignment: .centerLeading,
            sublayouts: [nameDateStack, lastMessageLayout])
        let photoLayout = SizeLayout<UIImageView>(
            size: CGSize(width: 60, height: 60),
            config: { avatar in
                let resource = ImageResource(downloadURL: URL(string: photo)!, cacheKey: photo)
                avatar.kf.setImage(with: resource)
                avatar.contentMode = .scaleAspectFill
                avatar.layer.cornerRadius = avatar.frame.height / 2
                avatar.clipsToBounds = true
        })
        super.init(
            insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8),
            sublayout: StackLayout(
                axis: .horizontal,
                spacing: 8,
                sublayouts: [photoLayout, contentVerticalStack]),
            config: { view in
                view.backgroundColor = .white
        })
    }
}
class MessagesReloadableViewLayoutAdapter: ReloadableViewLayoutAdapter {
}
