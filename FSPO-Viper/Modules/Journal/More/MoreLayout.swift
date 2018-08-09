//
//  MoreLayout.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 28/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation
import LayoutKit

open class MoreLayout: InsetLayout<View> {
    public init(subject: String, presense: String, nonPresense: String, allPresense: String, attestation: String, result: String) {
        var wholeString = ""
        if NSLocalizedString("Не был", comment: "").width(withConstrainedHeight: 10, font: UIFont.ITMOFont!.withSize(10)) > NSLocalizedString("Был", comment: "").width(withConstrainedHeight: 10, font: UIFont.ITMOFont!.withSize(10)) {
            wholeString = "\(NSLocalizedString("Не был", comment: ""))\(NSLocalizedString("Всего", comment: ""))\(NSLocalizedString("Аттестация", comment: ""))\(NSLocalizedString("Оценка", comment: ""))"
        } else {
            wholeString = "\(NSLocalizedString("Был", comment: ""))\(NSLocalizedString("Всего", comment: ""))\(NSLocalizedString("Аттестация", comment: ""))\(NSLocalizedString("Оценка", comment: ""))"
        }
        let width = wholeString.width(withConstrainedHeight: 10, font: UIFont.ITMOFont!.withSize(10)) + 50
        let subjectLabel = SizeLayout(
            width: UIScreen.main.bounds.width - width,
            sublayout: LabelLayout(
                text: subject,
                font: UIFont.ITMOFont!,
                alignment: .centerLeading,
                config: { label in
                    label.accessibilityIdentifier = "cellLabel"
                    label.lineBreakMode = .byWordWrapping
                    label.textColor = .black
                    label.backgroundColor = .white
            })
        )
        let presenseLabel = LabelLayout(
            text: presense,
            font: UIFont.ITMOFont!,
            alignment: .center,
            config: { label in
                label.textColor = .black
                label.backgroundColor = .white
        })
        let presenseLabelDescription = LabelLayout(
            text: NSLocalizedString("Был", comment: ""),
            font: UIFont.ITMOFont!.withSize(10),
            alignment: .center,
            config: { label in
                label.textColor = .black
                label.backgroundColor = .white
        })
        let presenseLabelStack = StackLayout(
            axis: .vertical,
            alignment: .center,
            sublayouts: [presenseLabel, presenseLabelDescription])
        let nonPresenseLabel = LabelLayout(
            text: nonPresense,
            font: UIFont.ITMOFont!,
            alignment: .center,
            config: { label in
                label.textColor = .black
                label.backgroundColor = .white
        })
        let nonPresenseLabelDescription = LabelLayout(
            text: NSLocalizedString("Не был", comment: ""),
            font: UIFont.ITMOFont!.withSize(10),
            alignment: .center,
            config: { label in
                label.textColor = .black
                label.backgroundColor = .white
        })
        let nonPresenseLabelStack = StackLayout(
            axis: .vertical,
            alignment: .center,
            sublayouts: [nonPresenseLabel, nonPresenseLabelDescription])
        let allPresenseLabel = LabelLayout(
            text: allPresense,
            font: UIFont.ITMOFont!,
            alignment: .center,
            config: { label in
                label.textColor = .black
                label.backgroundColor = .white
        })
        let allPresenseLabelDescription = LabelLayout(
            text: NSLocalizedString("Всего", comment: ""),
            font: UIFont.ITMOFont!.withSize(10),
            alignment: .center,
            config: { label in
                label.textColor = .black
                label.backgroundColor = .white
        })
        let allPresenseLabelStack = StackLayout(
            axis: .vertical,
            distribution: .fillEqualSpacing,
            alignment: .center,
            sublayouts: [allPresenseLabel, allPresenseLabelDescription])
        let presenseStack = StackLayout(
            axis: .vertical,
            spacing: 5,
            sublayouts: [presenseLabelStack, nonPresenseLabelStack])
        let attestationLabel = LabelLayout(
            text: attestation,
            font: UIFont.ITMOFont!,
            alignment: .center,
            config: { label in
                label.textColor = .black
                label.backgroundColor = .white
            })
        let attestationLabelDescription = LabelLayout(
            text: NSLocalizedString("Аттестация", comment: ""),
            font: UIFont.ITMOFont!.withSize(10),
            alignment: .center,
            config: { label in
                label.textColor = .black
                label.backgroundColor = .white
        })
        let attestationStack = StackLayout(
            axis: .vertical,
            alignment: .centerTrailing,
            sublayouts: [attestationLabel, attestationLabelDescription])
        let resultLabel = LabelLayout(
            text: result,
            font: UIFont.ITMOFont!,
            alignment: .center,
            config: { label in
                label.textColor = .black
                label.backgroundColor = .white
        })
        let resultLabelDescription = LabelLayout(
            text: NSLocalizedString("Оценка", comment: ""),
            font: UIFont.ITMOFont!.withSize(10),
            alignment: .centerLeading,
            config: { label in
                label.textColor = .black
                label.backgroundColor = .white
        })
        let resultStack = StackLayout(
            axis: .vertical,
            alignment: .center,
            sublayouts: [resultLabel, resultLabelDescription])
        super.init(
            insets: UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8),
            sublayout: StackLayout(
                axis: .horizontal,
                spacing: 8,
                sublayouts: [
                    subjectLabel, presenseStack, allPresenseLabelStack, attestationStack, resultStack
                ],
                config: { view in
                    view.backgroundColor = .white
            }),
            config: { view in
//                view.accessibilityIdentifier = "cellLabel"
                view.backgroundColor = .white
        })
    }
}
class MoreReloadableLayoutAdapter: ReloadableViewLayoutAdapter {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
