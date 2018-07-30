//
//  JournalBySubjectLayout.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 27/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation
import UIKit
import LayoutKit

open class JournalBySubjectLayout: InsetLayout<View> {
    public init(sem: String, subject: String) {
        let semLabel = LabelLayout(
            text: "[\(sem) \(NSLocalizedString("сем", comment: ""))]",
            font: UIFont.ITMOFont!,
            alignment: .center,
            config: { label in
                label.textColor = .gray
                label.backgroundColor = .white
        })
        let subjectLabel = LabelLayout(
            text: subject,
            font: (UIFont.ITMOFont?.withSize(17))!,
            config: { label in
                label.textColor = .black
                label.backgroundColor = .white
        })
        super.init(
                insets: UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8),
                sublayout: StackLayout(
                    axis: .horizontal,
                    spacing: 8,
                    sublayouts: [
                        semLabel, subjectLabel
                    ],
                    config: { view in
                        view.backgroundColor = .white
                }),
                config: { view in
                    view.backgroundColor = .white
            })
    }
}
class JournalBySubjectReloadableLayoutAdapter: ReloadableViewLayoutAdapter {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
