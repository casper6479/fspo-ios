//
//  ConsultationsLayout.swift
//  FSPO
//
//  Created by Николай Борисов on 03/09/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import LayoutKit

final class ConsultationsLayout: InsetLayout<View> {
    public init(data: [String: Any]) {
        var updatedText = ""
        if let updated = data["update"] as? String {
            updatedText = updated
        }
        let updatedLabel = LabelLayout(
            text: updatedText,
            font: UIFont.ITMOFont!,
            alignment: .center,
            config: { label in
                label.textColor = .gray
                label.textAlignment = .center
        })
        var teacherText = ""
        if let teacher = data["teacher"] as? String {
            teacherText = teacher
        }
        let teacherLabel = LabelLayout(
            text: teacherText,
            font: UIFont.ITMOFont!.withSize(17),
            alignment: .center,
            config: { label in
                label.textAlignment = .center
                label.textColor = .black
        })
        var sublayouts = [Layout]()
        if let subject = data["lessons"] as? [String] {
            for lesson in subject {
                sublayouts.append(LabelLayout(
                    text: lesson,
                    font: UIFont.LongTextFont!,
                    alignment: .center,
                    config: { label in
                        label.textColor = .white
                        label.textAlignment = .center
                }))
            }
        }
        let subjectLabel = InsetLayout(
            inset: 8,
            sublayout: StackLayout(
                axis: .vertical,
                spacing: 8,
                alignment: .center,
                sublayouts: sublayouts,
                config: { view in
                    view.backgroundColor = .ITMOBlue
            }),
            config: {view in
                view.layer.cornerRadius = 10
                view.backgroundColor = .ITMOBlue
        })
        var messageText = ""
        if let message = data["message"] as? String {
            messageText = message
        }
        let messageLabel = LabelLayout(
            text: messageText,
            font: UIFont.ITMOFontBold!,
            alignment: .center,
            config: { label in
                label.textAlignment = .center
        })
        var dateText = ""
        if let date = data["date"] as? String {
            func matches(for regex: String, in text: String) -> [String] {
                do {
                    let regex = try NSRegularExpression(pattern: regex)
                    let results = regex.matches(in: text,
                                                range: NSRange(text.startIndex..., in: text))
                    return results.map {
                        String(text[Range($0.range, in: text)!])
                    }
                } catch let error {
                    print("invalid regex: \(error.localizedDescription)")
                    return []
                }
            }
            var formatedDate = date.condenseWhitespacesAndNewLines().split(separator: "\n")
            for a in 0...formatedDate.count-1 {
                if formatedDate[a] == " " && formatedDate[a+1] == " " {
                    formatedDate[a] = "\n"
                    formatedDate[a+1] = ""
                }
            }
            let mappedDate = formatedDate.map { (test) -> String in
                return test.trimmingCharacters(in: .whitespaces)
            }
            dateText = mappedDate.joined()
        }
        let dateLabel = LabelLayout(
            text: dateText,
            font: UIFont.ITMOFontBold!,
            alignment: .center,
            config: { label in
                label.textAlignment = .center
                label.textColor = .ITMOBlue
        })
        let mainstackSublayouts: [Layout] = [teacherLabel, subjectLabel, messageLabel, dateLabel, updatedLabel]
        let mainStack = StackLayout(
            axis: .vertical,
            spacing: 8,
            sublayouts: mainstackSublayouts)
        super.init(
            insets: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8),
            sublayout: InsetLayout(
                insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
                sublayout: mainStack,
                config: { view in
                    view.layer.borderWidth = 0.2
                    view.layer.borderColor = UIColor.gray.cgColor
                    view.backgroundColor = .white
                    view.layer.cornerRadius = 10
            }),
            config: {view in
                view.backgroundColor = .backgroundGray
        })
    }
}
class ConsultationsReloadableLayoutAdapter: ReloadableViewLayoutAdapter {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return currentArrangement[indexPath.section].items[indexPath.item].frame.height
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = currentArrangement[indexPath.section].items[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReloadableViewLayoutAdapter.self), for: indexPath)
        DispatchQueue.main.async {
            item.makeViews(in: cell.contentView)
        }
        return cell
    }
}
extension String {
    func condenseWhitespacesAndNewLines() -> String {
        let components = self.components(separatedBy: .whitespaces)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}
