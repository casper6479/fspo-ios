//
//  NewsPostLayout.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//
import UIKit
import LayoutKit

open class NewsPostLayout: InsetLayout<View> {
    public init(body: String, time: String) {
        let bodyLayout = LabelLayout(
            text: body,
            font: (UIFont.LongTextFont?.withSize(16))!,
            config: { label in
                label.backgroundColor = .white
                label.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 32
            })
        let timeLabel = LabelLayout(
            text: time,
            font: UIFont.ITMOFont!.withSize(14),
            alignment: .center,
            config: { label in
                label.textColor = .white
                label.backgroundColor = UIColor.ITMOBlue
                label.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 32
            })
        let timeWidth = time.width(withConstrainedHeight: 14, font: UIFont.ITMOFont!.withSize(14))
        let timeLayout = SizeLayout(
            size: CGSize(width: timeWidth + 16, height: 14 + 12),
            alignment: .centerLeading,
            sublayout: timeLabel,
            config: {view in
                view.backgroundColor = UIColor.ITMOBlue
                view.layer.cornerRadius = 7
        })
        let authorLayout = LabelLayout(
            text: NSLocalizedString("Завилейская Анастасия", comment: ""),
            font: (UIFont.ITMOFont?.withSize(18))!,
            config: { label in
                label.textColor = .black
                label.backgroundColor = .white
                label.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 32
            })
        super.init(
            insets: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0),
            sublayout: InsetLayout(
                insets: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16),
                sublayout: StackLayout(
                    axis: .horizontal,
                    spacing: 5,
                    sublayouts: [
                        StackLayout(axis: .vertical, spacing: 8, sublayouts: [authorLayout, timeLayout, bodyLayout])
                    ],
                    config: { view in
                        view.backgroundColor = .white
                    }),
                config: { view in
                    view.backgroundColor = .white
                }),
            config: { view in
                view.backgroundColor = UIColor.backgroundGray
            })
    }
}

class NewsReloadableViewLayoutAdapter: ReloadableViewLayoutAdapter {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
}
