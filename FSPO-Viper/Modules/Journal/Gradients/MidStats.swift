//
//  MidStats.swift
//  FSPO
//
//  Created by Николай Борисов on 23/09/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import AsyncDisplayKit
import Lottie

class MidStats: ASDisplayNode {
//    var gradientNode: ASDisplayNode
    var trophyAnimation: LOTAnimationView?
    var animationContainer = ASDisplayNode()
    override func calculatedLayoutDidChange() {
        DispatchQueue.main.async {
            self.setupTrophyAnimation()
        }
    }
    override init() {
//        self.gradientNode = gradientNode
        super.init()
        automaticallyManagesSubnodes = true
        animationContainer.style.preferredSize = CGSize(width: 100, height: 100)
        animationContainer.style.alignSelf = .center
//        animationContainer.frame = gradientNode.bounds
    }
    func setupTrophyAnimation() {
        self.trophyAnimation = LOTAnimationView(name: "like")
        self.trophyAnimation?.frame = animationContainer.bounds
        self.trophyAnimation?.contentMode = .scaleAspectFit
        self.trophyAnimation?.play { _ in
            self.loopAnimation(animation: self.trophyAnimation!)
        }
        if !self.animationContainer.view.subviews.contains(self.trophyAnimation!) {
            self.animationContainer.view.addSubview(self.trophyAnimation!)
        }
    }
    func loopAnimation(animation: LOTAnimationView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            animation.play(completion: { _ in
                self.loopAnimation(animation: animation)
            })
        }
    }
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let text = ASTextNode()
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        text.attributedText = NSAttributedString(string: "Вы - хорошист!\nПродолжайте в том же духе", attributes: [.font: UIFont(name: "Helvetica-Bold", size: 17)!, .foregroundColor: UIColor.white, .paragraphStyle: paragraph])
        text.style.alignSelf = .center
        let stack = ASStackLayoutSpec.vertical()
        stack.spacing = 8
        stack.children = [animationContainer, text]
        return stack
    }
}
