//
//  3debts.swift
//  FSPO
//
//  Created by Николай Борисов on 15/09/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import AsyncDisplayKit

class Debts3: ASDisplayNode {
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
    }
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let text = ASTextNode()
        let paragraph = NSMutableParagraphStyle()
        let button = ASButtonNode()
        paragraph.alignment = .center
        text.attributedText = NSAttributedString(string: "Загляните в расписание консультаций", attributes: [.font: UIFont(name: "Helvetica-Bold", size: 17)!, .foregroundColor: UIColor.white, .paragraphStyle: paragraph])
        text.style.alignSelf = .center
        button.setTitle("Консультации", with: UIFont(name: "Helvetica-Bold", size: 17)!, with: .white, for: .normal)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.55)
        button.style.preferredSize = CGSize(width: 163, height: 40)
        button.layer.cornerRadius = 20
        button.style.alignSelf = .center
        if let superCell = supernode as? TipNode {
            button.addTarget(superCell, action: #selector(superCell.handler), forControlEvents: .touchUpInside)
            button.applyStyle()
        }
        let stack = ASStackLayoutSpec.vertical()
        stack.spacing = 24
        stack.children = [text, button]
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0), child: stack)
    }
}
