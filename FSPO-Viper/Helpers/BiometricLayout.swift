//
//  BiometricLayout.swift
//  FSPO
//
//  Created by Николай Борисов on 10/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import LayoutKit
import UIKit
open class BiometricLayout: InsetLayout<View> {
    static var label: UILabel!
    public init() {
        let labelLayout = SizeLayout<UILabel>(
            size: CGSize(width: UIScreen.main.bounds.width - 32, height: 40),
            alignment: .center,
            config: {label in
                label.text = NSLocalizedString("Подтверждение личности", comment: "")
                label.font = UIFont.ITMOFontBold!.withSize(17)
                label.textAlignment = .center
                BiometricLayout.label = label
        })
        let retryButton = ButtonLayout(
            type: .custom,
            title: NSLocalizedString("Повторить", comment: ""),
            alignment: .center,
            config: { button in
                button.setTitleColor(UIColor.ITMOBlue, for: .normal)
                button.setTitleColor(UIColor.ITMOBlue.withAlphaComponent(0.5), for: .highlighted)
                button.titleLabel?.font = UIFont.ITMOFontBold?.withSize(17)
                button.addTarget(AppDelegate(), action: #selector(AppDelegate().againUpInside), for: .touchUpInside)
        })
        super.init(
            insets: UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0),
            sublayout: SizeLayout(height: UIScreen.main.bounds.height, sublayout: StackLayout(axis: .vertical, sublayouts: [labelLayout, retryButton])),
            config: { view in
                view.backgroundColor = .white
        })
    }
}
