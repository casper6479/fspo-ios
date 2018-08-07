//
//  JournalByTeacherTeacherCellLayout.swift
//  FSPO
//
//  Created by Николай Борисов on 07/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation
import LayoutKit
import Kingfisher

open class JournalByTeacherHeaderLayout: InsetLayout<View> {
    public init(firstname: String, lastname: String, middlename: String, email: String, phone: String, photo: String) {
        let textCases = [email, phone]
        func profileIcon(image: UIImage) -> Layout {
            let profileIcon = SizeLayout<UIImageView>(
                size: CGSize(width: 30, height: 30),
                config: {imageView in imageView.image = image})
            return profileIcon
        }
        func generateProfileLines() -> [Layout] {
            var profileLine = [Layout]()
            var i = 0
            while i < textCases.count {
                profileLine.append(StackLayout(axis: .horizontal, spacing: 16, sublayouts: [profileIcon(image: UIImage(named: "profile_icon_\(i)")!), LabelLayout(text: textCases[i], font: (UIFont.ITMOFont?.withSize(16))!, numberOfLines: 1, alignment: .centerLeading)]))
                i+=1
            }
            return profileLine
        }
        let profileLines = generateProfileLines()
        let firstnameLabel = LabelLayout(
            text: firstname,
            font: (UIFont.ITMOFont?.withSize(16))!,
            numberOfLines: 1,
            alignment: .center,
            flexibility: .flexible,
            config: { label in
                label.textAlignment = .center
                label.backgroundColor = .white
        })
        let lastnameLabel = LabelLayout(
            text: lastname,
            font: (UIFont.ITMOFont?.withSize(16))!,
            numberOfLines: 1,
            alignment: .center,
            flexibility: .flexible,
            config: { label in
                label.textAlignment = .center
                label.backgroundColor = .white
        })
        let middlenameLabel = LabelLayout(
            text: middlename,
            font: (UIFont.ITMOFont?.withSize(17))!,
            numberOfLines: 1,
            alignment: .center,
            flexibility: .flexible,
            config: { label in
                label.textAlignment = .center
                label.backgroundColor = .white
        })
        let photoLayout = SizeLayout<UIImageView>(
            size: CGSize(width: 100, height: 100),
            config: { avatar in
                let resource = ImageResource(downloadURL: URL(string: photo)!, cacheKey: photo)
                avatar.kf.setImage(with: resource)
                avatar.contentMode = .scaleAspectFill
                avatar.layer.cornerRadius = avatar.frame.height / 2
                avatar.clipsToBounds = true
        })
        let namesStackLayout = StackLayout(axis: .vertical, spacing: 8, alignment: .center, sublayouts: [lastnameLabel, firstnameLabel, middlenameLabel])
        let nameAvatarLayout = StackLayout(axis: .horizontal, sublayouts: [photoLayout, namesStackLayout])
        let mainStackView = StackLayout (
            axis: .vertical,
            spacing: 0,
            sublayouts: [
                SizeLayout(
                    size: CGSize(width: UIScreen.main.bounds.width, height: 132),
                    sublayout: nameAvatarLayout),
                SizeLayout(
                    size: CGSize(width: UIScreen.main.bounds.width, height: 84),
                    sublayout: StackLayout(axis: .vertical, spacing: 16, sublayouts: profileLines))
            ])
        let insetStack = InsetLayout (insets: UIEdgeInsets(top: 8, left: 16, bottom: 4, right: 16), sublayout: mainStackView)
        let finalStack = StackLayout(
            axis: .vertical,
            sublayouts: [insetStack, SizeLayout(
                                            height: 1,
                                            config: {view in
                                                view.backgroundColor = UIColor.backgroundGray
                                        })]
        )
        super.init(
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
            sublayout: finalStack,
            config: { view in
                view.backgroundColor = .white
        })
    }
}
