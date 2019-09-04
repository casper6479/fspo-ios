//
//  MidPresence.swift
//  FSPO
//
//  Created by Николай Борисов on 24/09/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import AsyncDisplayKit

class MidPresence: ASDisplayNode {
    var presence: String
    public init(presence: String) {
        self.presence = presence
        super.init()
        automaticallyManagesSubnodes = true
    }
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let text = ASTextNode()
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        text.attributedText = NSAttributedString(string: "Вы посетили \(presence)% занятий", attributes: [.font: UIFont(name: "Helvetica-Bold", size: 17)!, .foregroundColor: UIColor.white, .paragraphStyle: paragraph])
        return ASCenterLayoutSpec(centeringOptions: .XY, child: text)
    }
}
