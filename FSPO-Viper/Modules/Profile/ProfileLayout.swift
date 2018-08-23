//
//  ProfileLayout.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 14/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation
import LayoutKit
import Kingfisher

open class ProfileLayout: InsetLayout<View> {
    public init(data: JSONDecoding.ProfileApi) {
        let role = UserDefaults.standard.string(forKey: "role")
        var school = "\(data.school ?? 0)"
        if school == "0" {
            school = NSLocalizedString("Не указано", comment: "")
        } else {
            school += " \(NSLocalizedString("классов", comment: ""))"
        }
        var segrys = "\(data.segrys ?? false)"
        if data.segrys == nil {
            segrys = NSLocalizedString("Не указано", comment: "")
        }
        if segrys == "true" {
            segrys = NSLocalizedString("Обучался(лась) в Сегрисе", comment: "")
        }
        if segrys == "false" {
            segrys = NSLocalizedString("Не обучался(лась) в Сегрисе", comment: "")
        }
        let email = data.email ?? NSLocalizedString("Не указано", comment: "")
        let phone = data.phone ?? NSLocalizedString("Не указано", comment: "")
        let birthday = data.birthday ?? NSLocalizedString("Не указано", comment: "")
        let nationality = data.nationality ?? NSLocalizedString("Не указано", comment: "")
        var textCases = [email, phone, birthday, nationality, school, segrys]
        if role == "teacher" || role == "parent" {
            textCases = [email, phone]
        }
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
            text: data.firstname,
            font: (UIFont.ITMOFont?.withSize(16))!,
            numberOfLines: 1,
            alignment: .center,
            flexibility: .flexible,
            config: { label in
                label.textAlignment = .center
                label.backgroundColor = .white
        })
        let lastnameLabel = LabelLayout(
            text: data.lastname,
            font: (UIFont.ITMOFont?.withSize(16))!,
            numberOfLines: 1,
            alignment: .center,
            flexibility: .flexible,
            config: { label in
                label.textAlignment = .center
                label.backgroundColor = .white
        })
        let middlenameLabel = LabelLayout(
            text: data.middlename,
            font: (UIFont.ITMOFont?.withSize(16))!,
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
                let resource = ImageResource(downloadURL: URL(string: data.photo)!, cacheKey: data.photo)
                avatar.kf.setImage(with: resource)
                avatar.contentMode = .scaleAspectFill
                avatar.layer.cornerRadius = avatar.frame.height / 2
                avatar.clipsToBounds = true
        })
        let namesStackLayout = StackLayout(axis: .vertical, spacing: 8, alignment: .center, sublayouts: [lastnameLabel, firstnameLabel, middlenameLabel])
        let nameAvatarLayout = StackLayout(axis: .horizontal, sublayouts: [photoLayout, namesStackLayout])
        let bottomButton = Button().createButton(title: NSLocalizedString("Родители", comment: ""), width: UIScreen.main.bounds.width - 32, height: 40, alignment: .bottomCenter, target: ProfileViewController(), action: #selector(ProfileViewController().setNeedsShowParents))
        var mainStack = [
            SizeLayout(
                size: CGSize(width: UIScreen.main.bounds.width, height: 132),
                sublayout: nameAvatarLayout),
            SizeLayout(
                size: CGSize(width: UIScreen.main.bounds.width, height: 260),
                sublayout: StackLayout(axis: .vertical, spacing: 16, sublayouts: profileLines)),
            SizeLayout(
                size: CGSize(width: UIScreen.main.bounds.width, height: Constants.safeHeight - 24 - 384),
                sublayout: bottomButton)
        ]
        if role == "teacher" {
            _ = mainStack.popLast()
        }
        let mainStackView = StackLayout (
            axis: .vertical,
            spacing: 0,
            sublayouts: mainStack)
        super.init(
            insets: UIEdgeInsets(top: 8, left: 16, bottom: 4, right: 16),
            sublayout: mainStackView,
            config: { view in
                view.backgroundColor = .white
        })
    }
}
