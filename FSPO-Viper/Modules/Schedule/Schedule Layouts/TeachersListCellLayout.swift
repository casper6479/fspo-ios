//
//  TeachersListCellLayout.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 04/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation
import LayoutKit
import Kingfisher

open class TeachersListCellLayout: InsetLayout<View> {
    public init(firstname: String, lastname: String, middlename: String, photo: String) {
        let firstnameLabel = LabelLayout(
            text: firstname,
            font: UIFont.ITMOFont!,
            alignment: .centerLeading,
            config: { label in
                label.backgroundColor = .white
        })
        let lastnameLabel = LabelLayout(
            text: lastname,
            font: UIFont.ITMOFont!,
            alignment: .centerLeading,
            config: { label in
                label.backgroundColor = .white
        })
        let middlenameLabel = LabelLayout(
            text: middlename,
            font: UIFont.ITMOFont!,
            alignment: .centerLeading,
            config: { label in
                label.backgroundColor = .white
        })
        let photoLayout = SizeLayout<UIImageView>(
            size: CGSize(width: 50, height: 50),
            config: { avatar in
                let resource = ImageResource(downloadURL: URL(string: photo)!, cacheKey: photo)
                avatar.kf.setImage(with: resource)
                avatar.contentMode = .scaleAspectFill
                avatar.layer.cornerRadius = avatar.frame.height / 2
                avatar.clipsToBounds = true
        })
        let nameStack = StackLayout(axis: .vertical, spacing: 2, alignment: .centerLeading, sublayouts: [lastnameLabel, firstnameLabel, middlenameLabel])
        let horizontalStack = StackLayout(axis: .horizontal, spacing: 8, sublayouts: [photoLayout, nameStack])
        super.init(
            insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8),
            sublayout: horizontalStack,
            config: { view in
                view.backgroundColor = .white
        })
    }
}
class TeacherListReloadableLayoutAdapter: ReloadableViewLayoutAdapter {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
