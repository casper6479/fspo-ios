//
//  SearchLayout.swift
//  FSPO
//
//  Created by Николай Борисов on 06/09/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import LayoutKit
import Kingfisher

final class SearchLayout: InsetLayout<View> {
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
class SearchReloadableLayoutAdapter: ReloadableViewLayoutAdapter {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = tableView.controller() as? SearchViewController
        let datasource = vc!.publicDS
        var firstname = ""
        var lastname = ""
        var dialogId = 0
        if indexPath.section == 0 {
            firstname = datasource?.teachers[indexPath.row].firstname ?? ""
            lastname = datasource?.teachers[indexPath.row].lastname ?? ""
            dialogId = Int((datasource?.teachers[indexPath.row].user_id)!) ?? 0
        }
        if indexPath.section == 1 {
            firstname = datasource?.students[indexPath.row].firstname ?? ""
            lastname = datasource?.students[indexPath.row].lastname ?? ""
            dialogId = Int((datasource?.students[indexPath.row].user_id)!) ?? 0
        }
        tableView.navigationController()?.show(DialogRouter.createModule(dialog_id: dialogId, title: "\(firstname) \(lastname)"), sender: SearchViewController())
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
