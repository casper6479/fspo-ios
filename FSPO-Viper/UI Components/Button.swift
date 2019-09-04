//
//  Button.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 09/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import LayoutKit
import AsyncDisplayKit

class Button {
    func createButton(title: String, width: CGFloat, height: CGFloat, alignment: Alignment, target: Any, action: Selector) -> SizeLayout<UIButton> {
        let button = SizeLayout<UIButton>(
            size: CGSize(width: width, height: height),
            alignment: alignment,
            config: { button in
                button.setTitle(title, for: .normal)
                button.backgroundColor = .clear
                button.setTitleColor(.white, for: .normal)
                button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
                button.titleLabel?.font = UIFont.ITMOFontBold?.withSize(17)
                button.layer.cornerRadius = button.frame.height / 2
                button.layer.masksToBounds = true
                button.applyStyle()
                let gradient = CAGradientLayer()
                gradient.colors = [UIColor.ITMOBlue.cgColor, UIColor.ITMOBlue.withAlphaComponent(0.7).cgColor]
                gradient.locations = [0, 1]
                gradient.startPoint = CGPoint(x: 0, y: 0.5)
                gradient.endPoint = CGPoint(x: 1, y: 0.5)
                gradient.frame = button.layer.bounds
                button.layer.insertSublayer(gradient, at: 0)
                button.addTarget(target, action: action, for: .touchUpInside)
        })
        return button
    }
    func createUnactiveButton(title: String, width: CGFloat, height: CGFloat, alignment: Alignment) -> SizeLayout<UIButton> {
        let button = SizeLayout<UIButton>(
            size: CGSize(width: width, height: height),
            alignment: alignment,
            config: { button in
                button.setTitle(title, for: .normal)
                button.backgroundColor = .gray
                button.setTitleColor(.white, for: .normal)
                button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
                button.titleLabel?.font = UIFont.ITMOFontBold?.withSize(17)
                button.layer.cornerRadius = button.frame.height / 2
                button.layer.masksToBounds = true
                button.isUserInteractionEnabled = false
        })
        return button
    }
}

extension UIButton {
    func applyStyle() {
        self.addTarget(self, action: #selector(zoomIN), for: .touchDown)
        self.addTarget(self, action: #selector(zoomIN), for: .touchDragEnter)
        self.addTarget(self, action: #selector(normalize), for: .touchCancel)
        self.addTarget(self, action: #selector(normalize), for: .touchDragExit)
        self.addTarget(self, action: #selector(normalize), for: .touchUpInside)
    }
    @objc func zoomIN(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    @objc func normalize(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform.identity
        }
    }
}

extension ASButtonNode {
    func applyStyle() {
        self.addTarget(self, action: #selector(zoomIN), forControlEvents: .touchDown)
        self.addTarget(self, action: #selector(zoomIN), forControlEvents: .touchDragInside)
        self.addTarget(self, action: #selector(normalize), forControlEvents: .touchCancel)
        self.addTarget(self, action: #selector(normalize), forControlEvents: .touchDragOutside)
        self.addTarget(self, action: #selector(normalize), forControlEvents: .touchUpInside)
    }
    @objc func zoomIN(_ sender: ASButtonNode) {
        UIView.animate(withDuration: 0.1) {
            sender.view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    @objc func normalize(_ sender: ASButtonNode) {
        UIView.animate(withDuration: 0.1) {
            sender.view.transform = .identity
        }
    }
}
