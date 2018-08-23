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
//        let width = wholeString.width(withConstrainedHeight: 10, font: UIFont.ITMOFont!.withSize(10)) + 50
        let presenseWidth = presense.width(withConstrainedHeight: 15, font: UIFont.ITMOFont!)
        let presenseDescriptionWidth = NSLocalizedString("Был", comment: "").width(withConstrainedHeight: 10, font: UIFont.ITMOFont!.withSize(10))
        var width: CGFloat = 0
        let presenseLabelWidth = max(presenseWidth, presenseDescriptionWidth)
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
        let nonPresenseWidth = nonPresense.width(withConstrainedHeight: 15, font: UIFont.ITMOFont!)
        let nonPresenseDescriptionWidth = NSLocalizedString("Не был", comment: "").width(withConstrainedHeight: 10, font: UIFont.ITMOFont!.withSize(10))
        let nonPresenseLabelWidth = max(nonPresenseWidth, nonPresenseDescriptionWidth)
        width += max(presenseLabelWidth, nonPresenseLabelWidth)
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
        let allPresenseWidth = allPresense.width(withConstrainedHeight: 15, font: UIFont.ITMOFont!)
        let allPresenseDescriptionWidth = NSLocalizedString("Всего", comment: "").width(withConstrainedHeight: 10, font: UIFont.ITMOFont!.withSize(10))
        width += max(allPresenseWidth, allPresenseDescriptionWidth)
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
        var att = attestation
        if attestation == "-1" {
            att = "-"
        }
        var fontSize: CGFloat = 15
        var textColor: UIColor = .black
        if attestation == "0" {
            att = NSLocalizedString("Незачёт", comment: "")
            fontSize = 11
            textColor = .ITMORed
        }
        if attestation == "1" {
            att = NSLocalizedString("Зачёт", comment: "")
            fontSize = 11
            textColor = UIColor(red: 0, green: 148/255, blue: 77/255, alpha: 1.0)
        }
        if attestation == "2" {
            textColor = .ITMORed
        }
        let attestationWidth = att.width(withConstrainedHeight: fontSize, font: UIFont.ITMOFont!.withSize(fontSize))
        let attestationDescriptionWidth = NSLocalizedString("Аттестация", comment: "").width(withConstrainedHeight: 10, font: UIFont.ITMOFont!.withSize(10))
        width += max(attestationDescriptionWidth, attestationWidth)
        let attestationLabel = LabelLayout(
            text: att,
            font: UIFont.ITMOFont!.withSize(fontSize),
            alignment: .center,
            config: { label in
                label.textColor = textColor
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
        var note = result
        if result == "-1" {
            note = "-"
        }
        var fontSizeResult: CGFloat = 15
        var textColorResult: UIColor = .black
        if result == "0" {
            note = NSLocalizedString("Незачёт", comment: "")
            fontSizeResult = 11
            textColorResult = .ITMORed
        }
        if result == "1" {
            note = NSLocalizedString("Зачёт", comment: "")
            fontSizeResult = 11
            textColorResult = UIColor(red: 0, green: 148/255, blue: 77/255, alpha: 1.0)
        }
        if result == "2" {
            textColorResult = .ITMORed
        }
        let resultWidth = note.width(withConstrainedHeight: fontSizeResult, font: UIFont.ITMOFont!.withSize(fontSizeResult))
        let resultDescriptionWidth = NSLocalizedString("Оценка", comment: "").width(withConstrainedHeight: 10, font: UIFont.ITMOFont!.withSize(10))
        width += max(resultDescriptionWidth, resultWidth)
        let resultLabel = LabelLayout(
            text: note,
            font: UIFont.ITMOFont!.withSize(fontSizeResult),
            alignment: .center,
            config: { label in
                label.textColor = textColorResult
                label.backgroundColor = .white
        })
        let resultLabelDescription = LabelLayout(
            text: NSLocalizedString("Оценка", comment: ""),
            font: UIFont.ITMOFont!.withSize(10),
            alignment: .center,
            config: { label in
                label.textColor = .black
                label.backgroundColor = .white
        })
        let resultStack = StackLayout(
            axis: .vertical,
            alignment: .center,
            sublayouts: [resultLabel, resultLabelDescription])
        width += 48
        let subjectLabel = SizeLayout(
            width: UIScreen.main.bounds.width - width - 16,
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
        super.init(
            insets: UIEdgeInsets(top: 12, left: 15, bottom: 12, right: 15),
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
                view.backgroundColor = .white
        })
    }
}
class MoreReloadableLayoutAdapter: ReloadableViewLayoutAdapter {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
