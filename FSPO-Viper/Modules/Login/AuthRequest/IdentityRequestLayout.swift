//
//  IdentityRequestLayout.swift
//  FSPO
//
//  Created by Николай Борисов on 14/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import LayoutKit

open class IdentityRequestLayout: InsetLayout<UIView> {
    public init() {
        let touchIDLogo =  SizeLayout<UIImageView>(
            size: CGSize(width: 50, height: 50),
            config: { imageView in
                imageView.image = UIImage(named: "touchID")
                imageView.contentMode = .scaleAspectFit
        })
        let faceIDLogo =  SizeLayout<UIImageView>(
            size: CGSize(width: 50, height: 50),
            config: { imageView in
                imageView.image = UIImage(named: "faceID")
                imageView.contentMode = .scaleAspectFit
        })
        let label = InsetLayout(inset: 8, sublayout: LabelLayout(
            text: NSLocalizedString("Включить подтверждение личности при входе?", comment: ""),
            font: UIFont.ITMOFontBold!.withSize(17),
            alignment: .topCenter,
            config: {label in
                label.textAlignment = .center
        }))
        let iconsStack = StackLayout(axis: .vertical,
                                     spacing: 64,
                                     alignment: .center,
                                     sublayouts: [touchIDLogo, faceIDLogo])
        let yesButton = SizeLayout<UIButton>(
            size: CGSize(width: 150, height: 40),
            alignment: .center,
            config: { button in
                button.setTitle(NSLocalizedString("Конечно!", comment: ""), for: .normal)
                button.backgroundColor = UIColor.ITMOBlue
                button.setTitleColor(.white, for: .normal)
                button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
                button.titleLabel?.font = UIFont.ITMOFontBold?.withSize(17)
                button.layer.cornerRadius = button.frame.height / 2
                button.layer.masksToBounds = true
                button.applyStyle()
                button.addTarget(IdentityRequestViewController(), action: #selector(IdentityRequestViewController().allowUpInside), for: .touchUpInside)
        })
        let noButton = ButtonLayout(
            type: .custom,
            title: NSLocalizedString("Не нужно", comment: ""),
            alignment: .topCenter,
            config: { button in
                button.setTitleColor(UIColor.ITMOBlue, for: .normal)
                button.setTitleColor(UIColor.ITMOBlue.withAlphaComponent(0.5), for: .highlighted)
                button.titleLabel?.font = UIFont.ITMOFontBold?.withSize(17)
                button.addTarget(IdentityRequestViewController(), action: #selector(IdentityRequestViewController().disallowUpInside), for: .touchUpInside)
        })
        let topContainer = SizeLayout(
            size: CGSize(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height) / 3 + 100),
            sublayout: iconsStack
        )
        let centerContainer = SizeLayout(
            size: CGSize(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height) / 3 - 50),
            alignment: .center,
            sublayout: StackLayout(axis: .vertical, sublayouts: [label, yesButton]))
        let bottomSizeContaner = SizeLayout(height: (UIScreen.main.bounds.height / 3 - 50) / 3)
        let bottomSizeFilledContainer = SizeLayout(height: (UIScreen.main.bounds.height / 3 - 50) / 3,
                                                   sublayout: noButton)
        let bottomContainer = SizeLayout(
            size: CGSize(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height) / 3 - 50),
            sublayout: StackLayout(axis: .vertical, sublayouts: [bottomSizeContaner, bottomSizeContaner, bottomSizeFilledContainer]))
        super.init(
            insets: UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0),
            alignment: .bottomCenter,
            sublayout: StackLayout(axis: .vertical, spacing: 0, alignment: .center, sublayouts: [topContainer, centerContainer, bottomContainer])
        )
    }
}
