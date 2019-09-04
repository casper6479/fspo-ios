//
//  JournalViewController.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import Cache
import AsyncDisplayKit
import Lottie

class JournalViewController: UIViewController, JournalViewProtocol, UITextFieldDelegate {
    func logOut() {
        LogOutHelper().logOut(vc: self)
    }
    
    var presenter: JournalPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = UIRectEdge()
        let clearData = JSONDecoding.JournalApi(avg_score: -1, debts: -1, visits: -1)
        storage?.async.object(forKey: "journal", completion: { result in
            switch result {
            case .value(let data):
                if let decoded = try? JSONDecoder().decode(JSONDecoding.JournalApi.self, from: data) {
                    DispatchQueue.main.async {
                        self.fillView(data: decoded)
                    }
                    self.presenter?.updateView(cache: decoded)
                } else {
                    DispatchQueue.main.async {
                        self.fillView(data: clearData)
                    }
                    self.presenter?.updateView(cache: nil)
                }
            case .error:
                DispatchQueue.main.async {
                    self.fillView(data: clearData)
                }
                self.presenter?.updateView(cache: nil)
            }
        })
    }
    func fillView(data: JSONDecoding.JournalApi) {
        let width = view.bounds.width
        DispatchQueue.global(qos: .userInteractive).async {
            var journalLayout = JournalLayout(
                dolgs: "\(data.debts)",
                percent: "\(data.visits) %",
                score: "\(data.avg_score)"
            )
            if data.debts == -1 && data.visits == -1 && data.avg_score == -1 {
                journalLayout = JournalLayout(
                    dolgs: "",
                    percent: "",
                    score: ""
                )
            }
            let arrangement = journalLayout.arrangement(width: width)
            DispatchQueue.main.async(execute: {
                arrangement.makeViews(in: self.view)
            })
        }
    }
    func show(vc: UIViewController) {
        self.navigationController?.show(vc, sender: self)
    }
    @objc func setNeedsShowByDate() {
        presenter?.showByDate()
    }
    @objc func setNeedsShowBySubject() {
        presenter?.showBySubject()
    }
    @objc func setNeedsShowMore() {
        presenter?.showMore()
    }
}
class TestJournalViewController: ASViewController<ASDisplayNode>, JournalViewProtocol, ASCollectionDelegate, ASCollectionDataSource, CellProtocol {
    var presenter: JournalPresenterProtocol?
    var didOpen = false
    func show(vc: UIViewController) {
        self.navigationController?.show(vc, sender: self)
    }
    @objc func setNeedsShowByDate() {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 10,
                       options: .curveEaseIn,
                       animations: {
                        self.closeBottom()
        })
        presenter?.showByDate()
    }
    @objc func setNeedsShowBySubject() {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 10,
                       options: .curveEaseIn,
                       animations: {
                        self.closeBottom()
        })
        presenter?.showBySubject()
    }
    @objc func setNeedsShowMore() {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 10,
                       options: .curveEaseIn,
                       animations: {
                        self.closeBottom()
        })
        presenter?.showMore()
    }
    var data: JSONDecoding.JournalApi?
    func fillView(data: JSONDecoding.JournalApi) {
        var casesCount = 0
        arr.removeAll()
        
        if (data.debts > 0) {
            casesCount += 1
        }
        if (data.visits < 100) {
            casesCount += 1
        } else if (data.visits < 70) {
            casesCount += 1
        }
        if (data.avg_score > 4.5) {
            casesCount += 1
        } else if (data.avg_score > 3.5) {
            casesCount += 1
        }
        
        for _ in 0...Int(1000/casesCount) {
            if (data.debts == 1) {
                arr.append(TipNode(type: .debts1))
            } else if (data.debts == 2) {
                arr.append(TipNode(type: .debts2))
            }  else if (data.debts > 2) {
                arr.append(TipNode(type: .debts3))
            }
            if (data.visits < 100) {
                arr.append(TipNode(type: .midPresence, textValue: "\(data.visits)"))
            } else if (data.visits < 70) {
                arr.append(TipNode(type: .lowPresence, textValue: "\(data.visits)"))
            }
            if (data.avg_score > 4.5 && data.debts == 0) {
                arr.append(TipNode(type: .bestStats))
            } else if (data.avg_score > 3.5 && data.debts == 0) {
                arr.append(TipNode(type: .middleStats))
            }
        }
        collectionNode.reloadData()
        collectionNode.scrollToItem(at: IndexPath(item: arr.count/2, section: 0), at: .centeredHorizontally, animated: false)
        if data.debts > 0 {
            let font = UIFont(name: "Helvetica-Bold", size: 17)
            //TODO: переделать
            var lastWord = "долг"
            if ((2...4).contains(data.debts)) {
                lastWord = "долга"
            } else if ((5...20).contains(data.debts)) {
                lastWord = "долгов"
            } else if (data.debts == 21) {
                lastWord = "долг"
            } else if data.debts == 1 {
                lastWord = "долг"
            } else {
                lastWord = "долга"
            }
            layout.tip.attributedText = NSAttributedString(string: "У вас \(data.debts) \(lastWord)!", attributes: [.font: font!, .foregroundColor: UIColor.white])
        }
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let avgsc = NSAttributedString(string: "\(data.avg_score)", attributes: [.font: UIFont(name: "Helvetica-Bold", size: 20)!, .paragraphStyle: paragraph])
        bottomLayout.avgScoreValue.attributedText = avgsc
        
        let debts = NSAttributedString(string: "\(data.debts)", attributes: [.font: UIFont(name: "Helvetica-Bold", size: 20)!, .paragraphStyle: paragraph])
        bottomLayout.debtsValue.attributedText = debts
        
        let pres = NSAttributedString(string: "\(data.visits) %", attributes: [.font: UIFont(name: "Helvetica-Bold", size: 20)!, .paragraphStyle: paragraph])
        bottomLayout.presenseValue.attributedText = pres
        
    }
    func logOut() {
        print("asd")
    }
    var tipHeight: CGFloat = 0
    var test: UIView?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.keyWindow?.backgroundColor = .mainColor
        self.navigationController?.navigationBar.barTintColor = .mainColor
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barTintColor = .ITMOBlue
        self.navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.keyWindow?.backgroundColor = .white
    }
    func openBottom() {
        didOpen = true
        self.bottomLayout.frame.origin.y = -(navigationController?.navigationBar.frame.height)! + 20
        self.bottomLayout.frame.origin.x = 0
        self.bottomLayout.view.frame.size.width = UIScreen.main.bounds.width
        self.bottomLayout.layer.cornerRadius = 10
//        navigationController?.navigationBar.frame.origin.y = UIApplication.shared.statusBarView!.frame.height
//        fakeNav.frame.size.width = view.bounds.width - 32
//        fakeNav.frame.origin.x = 16
//        let mask = CAShapeLayer()
//        let path = UIBezierPath(roundedRect: fakeNav.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10))
//        fakeNav.layer.mask = mask
//        mask.path = path.cgPath
    }
    func closeBottom() {
        didOpen = false
        self.bottomLayout.frame.origin.y = self.originalOrigin!
        self.bottomLayout.frame.origin.x = 16
        self.bottomLayout.frame.size.width = UIScreen.main.bounds.width - 32
        self.bottomLayout.layer.cornerRadius = 30
//        test?.removeFromSuperview()
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.mainColor
//        navigationController?.navigationBar.barTintColor = UIColor.mainColor
//        navigationController?.navigationBar.frame.origin.y = UIApplication.shared.statusBarView!.frame.height
    }
    let fakeNav = UIView()
    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: view)
        if panGesture.state == .began {
            currentPositionTouched = panGesture.location(in: view)
//            fakeNav.frame = navigationController!.navigationBar.bounds
//            fakeNav.backgroundColor = UIColor.mainColor
//            navigationController!.navigationBar.barTintColor = .clear
//            fakeNav.frame.size.height = navigationController!.navigationBar.bounds.height + UIApplication.shared.statusBarView!.frame.height
//            navigationController?.navigationBar.insertSubview(fakeNav, at: 1)
//            navigationController?.navigationBar.layer.masksToBounds = false
//            let mask = CAShapeLayer()
//            let path = UIBezierPath(roundedRect: fakeNav.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10))
//            fakeNav.layer.mask = mask
//            mask.path = path.cgPath
        } else if panGesture.state == .changed {
            bottomLayout.frame.origin.y += translation.y
            if bottomLayout.frame.origin.y <= -(navigationController?.navigationBar.frame.height)! {
                bottomLayout.frame.origin.y = -(navigationController?.navigationBar.frame.height)!
            }
            print((view.bounds.height - bottomLayout.frame.origin.y) / originalOrigin!)
            if bottomLayout.frame.origin.y >= -(navigationController?.navigationBar.frame.height)! / 2 {
                navigationController?.navigationBar.layer.masksToBounds = false
                navigationController?.navigationBar.frame.origin.y = UIApplication.shared.statusBarView!.frame.height
            }
        } else if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: view)
            if velocity.y <= -500 || bottomLayout.frame.origin.y <= 0 {
                UIView.animate(withDuration: 0.4,
                               delay: 0,
                               usingSpringWithDamping: 0.4,
                               initialSpringVelocity: 10,
                               options: .curveEaseIn,
                               animations: {
                                    self.openBottom()
                })
            } else if velocity.y >= 500 || bottomLayout.frame.origin.y >= UIScreen.main.bounds.height / 2 {
                UIView.animate(withDuration: 0.4,
                               delay: 0,
                               usingSpringWithDamping: 0.4,
                               initialSpringVelocity: 10,
                               options: .curveEaseIn,
                               animations: {
                                    self.closeBottom()
                })
            } else {
                UIView.animate(withDuration: 0.4,
                               delay: 0,
                               usingSpringWithDamping: 0.4,
                               initialSpringVelocity: 10,
                               options: .curveEaseIn,
                               animations: {
                                    self.closeBottom()
                })
            }
        }
        panGesture.setTranslation(.zero, in: view)
    }
    var panGestureRecognizer: UIPanGestureRecognizer?
    var originalPosition: CGPoint?
    var currentPositionTouched: CGPoint?
    var originalOrigin: CGFloat?
    var collectionNode: ASCollectionNode!
    let layout = TestJournalLayout(avgScore: "", upperText: "")
    let bottomLayout = BottomJournalNode()
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIApplication.shared.keyWindow?.backgroundColor = .white
        view.backgroundColor = UIColor.mainColor
        navigationController?.navigationBar.shadowImage = UIImage()
        self.collectionNode = layout.collectionNode
        layout.frame = view.bounds
        collectionNode.delegate = self
        collectionNode.dataSource = self
        bottomLayout.frame = view.bounds
        bottomLayout.frame.size.width -= 32
        bottomLayout.frame.origin.x += 16
//        let mask = UIBezierPath(roundedRect: bottomLayout.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 30, height: 30))
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = mask.cgPath
//        bottomLayout.layer.mask = shapeLayer
        bottomLayout.layer.cornerRadius = 30
        view.addSubnode(layout)
        self.navigationController?.navigationBar.layer.zPosition = -1
        view.addSubnode(bottomLayout)
        collectionNode.reloadData()
        bottomLayout.button1.addTarget(self, action: #selector(setNeedsShowBySubject), forControlEvents: .touchUpInside)
        bottomLayout.button.addTarget(self, action: #selector(setNeedsShowByDate), forControlEvents: .touchUpInside)
        bottomLayout.moreButton.addTarget(self, action: #selector(setNeedsShowMore), forControlEvents: .touchUpInside)

        let clearData = JSONDecoding.JournalApi(avg_score: -1, debts: -1, visits: -1)
        storage?.async.object(forKey: "journal", completion: { result in
            switch result {
            case .value(let data):
                if let decoded = try? JSONDecoder().decode(JSONDecoding.JournalApi.self, from: data) {
                    DispatchQueue.main.async {
                        self.fillView(data: decoded)
                    }
                    self.presenter?.updateView(cache: decoded)
                } else {
                    DispatchQueue.main.async {
                        self.fillView(data: clearData)
                    }
                    self.presenter?.updateView(cache: nil)
                }
            case .error:
                DispatchQueue.main.async {
                    self.fillView(data: clearData)
                }
                self.presenter?.updateView(cache: nil)
            }
        })
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction))
        bottomLayout.view.addGestureRecognizer(panGestureRecognizer!)
    }
    override func viewDidAppear(_ animated: Bool) {
//        collectionNode.reloadData()
        tipHeight = layout.tip.frame.height
        if !didOpen {
            bottomLayout.frame.origin.y = layout.tip.frame.height + 160 + 32
        }
        originalOrigin = layout.tip.frame.height + 160 + 32
//        test = UIApplication.shared.keyWindow?.snapshotView(afterScreenUpdates: true)
//        collectionNode.scrollToItem(at: IndexPath(item: 500, section: 0), at: .left, animated: false)
    }
    var arr = [TipNode]()
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let cellNodeBlock = { () -> ASCellNode in
            let cellNode = self.arr[indexPath.row]
            cellNode.cellDelegate = self
            cellNode.selectionStyle = .none
            return cellNode
        }
        return cellNodeBlock
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//        print("test")
    }
    func didTapConsultations() {
        self.navigationController?.show(ConsultationsRouter.createModule(), sender: self)
    }
}
enum CellType {
    case debts3, bestStats, middleStats, debts2, debts1, midPresence, lowPresence
}
protocol CellProtocol: class {
    func didTapConsultations()
}
class TipNode: ASCellNode {
    weak var cellDelegate: CellProtocol?
    var textValue = ""
    @objc func handler() {
        self.cellDelegate?.didTapConsultations()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.1) {
            self.view.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.1) {
            self.view.transform = .identity
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        UIView.animate(withDuration: 0.1) {
            self.view.transform = .identity
        }
    }
    override func calculatedLayoutDidChange() {
        gradient.frame = self.bounds
//        gradient.frame.size.width -= 16
        gradientNode.layer.addSublayer(gradient)
        if type == .bestStats {
            DispatchQueue.main.async {
                self.setupGradientAnimation()
//                self.setupTrophyAnimation()
            }
        }
        if type == .middleStats {
            DispatchQueue.main.async {
                self.setupMidStatsNode()
            }
        }
        if type == .debts3 {
            DispatchQueue.main.async {
                self.setupDebts3Node()
            }
        }
        if type == .debts2 {
            DispatchQueue.main.async {
                self.setupDebts2Node()
            }
        }
        if type == .debts1 {
            DispatchQueue.main.async {
                self.setupDebts1Node()
            }
        }
        if type == .midPresence {
            DispatchQueue.main.async {
                self.setupMidPresenceNode(presence: self.textValue)
            }
        }
        if type == .lowPresence {
            DispatchQueue.main.async {
                self.setupLowPresenceNode(presence: self.textValue)
            }
        }
    }
    func setupGradientAnimation() {
        self.gradientAnimation = AnimationView(name: "gradient")
        self.gradientAnimation.frame = self.gradient.bounds
        self.gradientAnimation.contentMode = .center
        self.gradientAnimation.play()
        self.gradientAnimation.loopMode = .loop
        self.gradientAnimation.layer.cornerRadius = 15
        self.gradientNode.view.addSubview(self.gradientAnimation)
        let bestStats = BestStats(gradientNode: self.gradientNode)
        bestStats.frame = gradientAnimation.bounds
        self.gradientNode.addSubnode(bestStats)
    }
    func setupMidStatsNode() {
        let midStats = MidStats()
        midStats.frame = self.bounds
        self.addSubnode(midStats)
    }
    func setupDebts3Node() {
        let debts3 = Debts3()
        debts3.frame = self.bounds
        self.addSubnode(debts3)
    }
    func setupDebts2Node() {
        let debts2 = Debts2()
        debts2.frame = self.bounds
        self.addSubnode(debts2)
    }
    func setupDebts1Node() {
        let debts1 = Debts1()
        debts1.frame = self.bounds
        self.addSubnode(debts1)
    }
    func setupMidPresenceNode(presence: String) {
        let midPresence = MidPresence(presence: presence)
        midPresence.frame = self.bounds
        self.addSubnode(midPresence)
    }
    func setupLowPresenceNode(presence: String) {
        let lowPresence = LowPresence(presence: presence)
        lowPresence.frame = self.bounds
        self.addSubnode(lowPresence)
    }
    var gradientNode = ASDisplayNode()
    var gradientAnimation: AnimationView!
    var trophyAnimation: AnimationView!
    var gradient = CAGradientLayer()
    var type: CellType
    public init(type: CellType, textValue: String = "") {
        self.type = type
        super.init()
        self.textValue = textValue
        self.clipsToBounds = false
        automaticallyManagesSubnodes = true
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        switch type {
        case .bestStats:
//            print("asd")
            gradient.colors = [UIColor(rgb: 0xFEE140).cgColor, UIColor(rgb: 0xFA709A).cgColor]
        case .middleStats:
            gradient.colors = [UIColor(rgb: 0x37ECBA).cgColor, UIColor(rgb: 0x72AFD3).cgColor]
        case .debts3:
            gradient.colors = [UIColor(rgb: 0xF5515F).cgColor, UIColor(rgb: 0xA1051D).cgColor]
        case .debts2:
            gradient.startPoint = CGPoint(x: 0, y: 1)
            gradient.endPoint = CGPoint(x: 1, y: 0)
            gradient.colors = [UIColor(rgb: 0x36093F).cgColor, UIColor(rgb: 0xF05E57).cgColor]
        case .debts1:
            gradient.startPoint = CGPoint(x: 0, y: 1)
            gradient.endPoint = CGPoint(x: 1, y: 0)
            gradient.colors = [UIColor(rgb: 0x6094EA).cgColor, UIColor(rgb: 0xEF2FC1).cgColor]
        case .midPresence:
            gradient.startPoint = CGPoint(x: 0, y: 1)
            gradient.endPoint = CGPoint(x: 1, y: 0)
            gradient.colors = [UIColor(rgb: 0x4E6FFB).cgColor, UIColor(rgb: 0xDFAFFD).cgColor]
        case .lowPresence:
            gradient.startPoint = CGPoint(x: 0, y: 1)
            gradient.endPoint = CGPoint(x: 1, y: 0)
            gradient.colors = [UIColor(rgb: 0x21D4FD).cgColor, UIColor(rgb: 0xB721FF).cgColor]
        default:
            gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        }
        gradient.locations = [0, 1]
        gradient.cornerRadius = 15
    }
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let insets = ASInsetLayoutSpec(insets: .zero, child: gradientNode)
        insets.insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return insets
    }
}
extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
