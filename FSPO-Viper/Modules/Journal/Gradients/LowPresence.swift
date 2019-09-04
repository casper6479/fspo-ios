//
//  LowPresence.swift
//  FSPO
//
//  Created by Николай Борисов on 24/09/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import AsyncDisplayKit

class LowPresence: ASDisplayNode {
    var presence: String
    public init(presence: String) {
        self.presence = presence
        super.init()
        automaticallyManagesSubnodes = true
    }
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let text = ASTextNode()
        let tip = ASTextNode()
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        text.attributedText = NSAttributedString(string: "Вы посетили всего \(presence)% занятий", attributes: [.font: UIFont(name: "Helvetica-Bold", size: 17)!, .foregroundColor: UIColor.white, .paragraphStyle: paragraph])
        tip.attributedText = NSAttributedString(string: "Старайтесь чаще\nпосещать занятия", attributes: [.font: UIFont(name: "Helvetica-Bold", size: 17)!, .foregroundColor: UIColor.white, .paragraphStyle: paragraph])
        let stack = ASStackLayoutSpec.vertical()
        stack.spacing = 32
        stack.children = [text, tip]
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0), child: stack)
    }
}
