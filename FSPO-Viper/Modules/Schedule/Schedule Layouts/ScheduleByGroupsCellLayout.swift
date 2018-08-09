//
//  ScheduleByGroupsCellLayout.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 04/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation
import LayoutKit

open class ScheduleByGroupsCellLayout: InsetLayout<View> {
    public init(group: String) {
        let groupLabel = LabelLayout(
            text: group,
            font: UIFont.ITMOFontBold!,
            alignment: .centerLeading,
            config: { label in
                label.backgroundColor = .white
        })
        super.init(
            insets: UIEdgeInsets(top: 12, left: 15, bottom: 12, right: 8),
            sublayout: groupLabel,
            config: { view in
                view.backgroundColor = .white
        })
    }
}
class ScheduleByGroupsReloadableLayoutAdapter: ReloadableViewLayoutAdapter {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let weekdays = ["1 \(NSLocalizedString("курс", comment: ""))",
                        "2 \(NSLocalizedString("курс", comment: ""))",
                        "3 \(NSLocalizedString("курс", comment: ""))",
                        "4 \(NSLocalizedString("курс", comment: ""))"]
        return weekdays[section]
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.backgroundView?.backgroundColor = UIColor.ITMOBlue
        header?.textLabel?.font = UIFont.ITMOFontBold?.withSize(17)
        header?.textLabel?.textColor = .white
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    UIApplication.shared.keyWindow?.rootViewController?.childViewControllers[3].show(ScheduleListRouter.createModule(id: Int((ScheduleViewController.publicGroupsDS?.courses[indexPath.section].groups[indexPath.row].group_id)!)!, type: "group"), sender: ScheduleViewController())
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
