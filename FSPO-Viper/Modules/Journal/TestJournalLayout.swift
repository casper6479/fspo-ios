//
//  TestJournalLayout.swift
//  FSPO
//
//  Created by Николай Борисов on 14/09/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class TestJournalLayout: ASDisplayNode, ASCollectionDelegate, ASCollectionDataSource, UIScrollViewDelegate {
    var upperStack = ASStackLayoutSpec.vertical()
    var collectionNode: ASCollectionNode
    let tip = ASTextNode()
    public init(avgScore: String, upperText: String) {
//        let flowLayout = UICollectionViewFlowLayout()
        collectionNode = ASCollectionNode(collectionViewLayout: PagedFlowLayout())
        super.init()
//        flowLayout.minimumInteritemSpacing = 1
//        flowLayout.minimumLineSpacing = 16
//        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 160)
//        flowLayout.scrollDirection = .horizontal
        collectionNode.backgroundColor = .clear
        collectionNode.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
//        collectionNode.view.isPagingEnabled = true
        collectionNode.view.showsHorizontalScrollIndicator = false
        collectionNode.view.showsVerticalScrollIndicator = false
        collectionNode.style.preferredSize = CGSize(width: UIScreen.main.bounds.width, height: 160)
//        collectionNode.frame.origin.x = -8
        automaticallyManagesSubnodes = true
        let font = UIFont(name: "Helvetica-Bold", size: 17)
        tip.attributedText = NSAttributedString(string: upperText, attributes: [.font: font!, .foregroundColor: UIColor.white])
        upperStack.children = [ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16), child: tip), collectionNode]
    }
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero, child: upperStack)
    }
}
class PagedFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        self.scrollDirection = .horizontal
        self.minimumLineSpacing = 16
        self.minimumInteritemSpacing = 0
        if #available(iOS 11.0, *) {
            self.sectionInsetReference = .fromSafeArea // for iPhone X
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented")
    }
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        self.itemSize = CGSize(width: UIScreen.main.bounds.width - 48, height: 160)
    }
    // Table: Possible cases of targetContentOffset calculation
    // -------------------------
    // start |          |
    // near  | velocity | end
    // page  |          | page
    // -------------------------
    //   0   | forward  |  1
    //   0   | still    |  0
    //   0   | backward |  0
    //   1   | forward  |  1
    //   1   | still    |  1
    //   1   | backward |  0
    // -------------------------
    var prevOffset: CGFloat = 0
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//        guard let collectionView = collectionView else { return proposedContentOffset }
//        let pageWidth = itemSize.width + minimumLineSpacing
//        let currentPage: CGFloat = collectionView.contentOffset.x / pageWidth
//        let nearestPage: CGFloat = round(currentPage)
//        let isNearPreviousPage = nearestPage < currentPage
//        var pageDiff: CGFloat = 0
//        let velocityThreshold: CGFloat = 0.5
//        if isNearPreviousPage {
//            if velocity.x > velocityThreshold {
//                pageDiff = 1
//            }
//        } else {
//            if velocity.x < -velocityThreshold {
//                pageDiff = -1
//            }
//        }
//        let x = (nearestPage + pageDiff) * pageWidth - 24
//        let cappedX = max(-48, x)
//        //print("x:", x, "velocity:", velocity)
//        return CGPoint(x: cappedX, y: proposedContentOffset.y)
        let collectionViewSize = collectionView!.bounds.size
        let proposedContentOffsetCenterX = proposedContentOffset.x + collectionViewSize.width * 0.5
        
        var proposedRect = collectionView!.bounds
        
        proposedRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionViewSize.width, height: collectionViewSize.height)
        
        var candidateAttributes: UICollectionViewLayoutAttributes?
        for attributes in self.layoutAttributesForElements(in: proposedRect)! {
            if attributes.representedElementCategory != .cell {
                continue
            }
            let currentOffset = self.collectionView!.contentOffset
            if (attributes.center.x <= (currentOffset.x + collectionViewSize.width * 0.5) && velocity.x > 0) || (attributes.center.x >= (currentOffset.x + collectionViewSize.width * 0.5) && velocity.x < 0) {
                continue
            }
            if candidateAttributes == nil {
                candidateAttributes = attributes
                continue
            }
            
            let lastCenterOffset = candidateAttributes!.center.x - proposedContentOffsetCenterX
            let centerOffset = attributes.center.x - proposedContentOffsetCenterX
            
            if fabsf( Float(centerOffset) ) < fabsf( Float(lastCenterOffset) ) {
                candidateAttributes = attributes
            }
        }
        
        if candidateAttributes != nil {
            let x = candidateAttributes!.center.x - collectionViewSize.width * 0.5
            return CGPoint(x: x, y: proposedContentOffset.y)
        } else {
            let offset = proposedContentOffset
            return super.targetContentOffset(forProposedContentOffset: offset)
        }
    }
}
class BottomJournalNode: ASDisplayNode {
    var mainStack = ASStackLayoutSpec.vertical()
    let button = ASButtonNode()
    let bubble = ASDisplayNode()
    let button1 = ASButtonNode()
    let moreButton = ASButtonNode()
    let buttonsStack = ASStackLayoutSpec.horizontal()
    let labelsStack = ASStackLayoutSpec.horizontal()
    let valuesStack = ASStackLayoutSpec.horizontal()
    let avgScoreValue = ASTextNode()
    let debtsValue = ASTextNode()
    let presenseValue = ASTextNode()
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        backgroundColor = .white
        button.backgroundColor = UIColor(rgb: 0xD8D8D8)
        button.style.alignSelf = .start
        button.setTitle(NSLocalizedString("По дате", comment: ""), with: UIFont(name: "Helvetica-Bold", size: 12), with: .black, for: .normal)
        moreButton.backgroundColor = UIColor(rgb: 0xD8D8D8)
        moreButton.style.alignSelf = .start
        moreButton.setTitle(NSLocalizedString("Подробнее", comment: ""), with: UIFont(name: "Helvetica-Bold", size: 12), with: .black, for: .normal)
        button1.backgroundColor = UIColor(rgb: 0xD8D8D8)
        button1.style.alignSelf = .end
        button1.setTitle(NSLocalizedString("По предметам", comment: ""), with: UIFont(name: "Helvetica-Bold", size: 12), with: .black, for: .normal)
        buttonsStack.spacing = 16
        bubble.style.preferredSize = CGSize(width: 80, height: 4)
        bubble.backgroundColor = .gray
        bubble.layer.cornerRadius = 2
        bubble.style.alignSelf = .center
        button.style.flexGrow = 1.0
        button.style.flexShrink = 1.0
        button1.style.flexGrow = 1.0
        button1.style.flexShrink = 1.0
        moreButton.style.minHeight = ASDimension(unit: .points, value: 40)
        button1.style.minHeight = ASDimension(unit: .points, value: 40)
        button.style.minHeight = ASDimension(unit: .points, value: 40)
        button.layer.cornerRadius = 20
        button1.layer.cornerRadius = 20
        moreButton.layer.cornerRadius = 20
        button.style.minWidth = ASDimension(unit: .points, value: UIScreen.main.bounds.width / 2 - 16 - 32)
        button.style.maxWidth = ASDimension(unit: .points, value: UIScreen.main.bounds.width / 2 - 16)
        button1.style.minWidth = ASDimension(unit: .points, value: UIScreen.main.bounds.width / 2 - 16 - 32)
        button1.style.maxWidth = ASDimension(unit: .points, value: UIScreen.main.bounds.width / 2 - 16)
        let avgScoreLabel = ASTextNode()
        let debtsLabel = ASTextNode()
        let presenseLabel = ASTextNode()
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        avgScoreLabel.attributedText = NSAttributedString(string: NSLocalizedString("Средний балл", comment: ""), attributes: [.font: UIFont(name: "Helvetica-Bold", size: 12)!, .paragraphStyle: paragraph])
        avgScoreLabel.style.alignSelf = .center
//        avgScoreLabel.backgroundColor = .gray
        avgScoreLabel.style.minWidth = ASDimension(unit: .points, value: (UIScreen.main.bounds.width - 32 - 64) / 3)
//        avgScoreLabel.style.flexGrow = 1.0
        debtsLabel.attributedText = NSAttributedString(string: NSLocalizedString("Долгов", comment: ""), attributes: [.font: UIFont(name: "Helvetica-Bold", size: 12)!, .paragraphStyle: paragraph])
        debtsLabel.style.alignSelf = .center
        debtsLabel.style.minWidth = ASDimension(unit: .points, value: (UIScreen.main.bounds.width - 32 - 64) / 3)
//        debtsLabel.backgroundColor = .blue
        presenseLabel.attributedText = NSAttributedString(string: NSLocalizedString("Посещения", comment: ""), attributes: [.font: UIFont(name: "Helvetica-Bold", size: 12)!, .paragraphStyle: paragraph])
        presenseLabel.style.alignSelf = .center
//        presenseLabel.backgroundColor = .red
        presenseLabel.style.minWidth = ASDimension(unit: .points, value: (UIScreen.main.bounds.width - 32 - 64) / 3)
        avgScoreValue.attributedText = NSAttributedString(string: "", attributes: [.font: UIFont(name: "Helvetica-Bold", size: 20)!, .paragraphStyle: paragraph])
        avgScoreValue.style.alignSelf = .center
        avgScoreValue.style.minWidth = ASDimension(unit: .points, value: (UIScreen.main.bounds.width - 32 - 64) / 3)
        debtsValue.attributedText = NSAttributedString(string: "", attributes: [.font: UIFont(name: "Helvetica-Bold", size: 20)!, .paragraphStyle: paragraph])
        debtsValue.style.alignSelf = .center
        debtsValue.style.minWidth = ASDimension(unit: .points, value: (UIScreen.main.bounds.width - 32 - 64) / 3)
        presenseValue.attributedText = NSAttributedString(string: "", attributes: [.font: UIFont(name: "Helvetica-Bold", size: 20)!, .paragraphStyle: paragraph])
        presenseValue.style.alignSelf = .center
        presenseValue.style.minWidth = ASDimension(unit: .points, value: (UIScreen.main.bounds.width - 32 - 64) / 3)
        labelsStack.justifyContent = .spaceAround
        labelsStack.children = [debtsLabel, avgScoreLabel, presenseLabel]
        valuesStack.justifyContent = .spaceAround
        valuesStack.children = [debtsValue, avgScoreValue, presenseValue]
        buttonsStack.children = [button, button1]
        mainStack.spacing = 16

        let tempLabel = ASTextNode()
        tempLabel.attributedText = NSAttributedString(string: "Скоро тут будет кое-что интересное 😊", attributes: [.font: UIFont(name: "Helvetica-Bold", size: 15)!, .paragraphStyle: paragraph])
        tempLabel.style.alignSelf = .center
        mainStack.children = [bubble, ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8), child: buttonsStack), ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0), child: labelsStack), ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), child: valuesStack), ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8), child: moreButton), ASInsetLayoutSpec(insets: UIEdgeInsets(top: 64, left: 0, bottom: 8, right: 0), child: tempLabel)]
    }
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 16, left: 16, bottom: 8, right: 16), child: mainStack)
    }
}
