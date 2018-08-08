//
//  DialogViewController.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 05/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import LayoutKit
import NextGrowingTextView
import IQKeyboardManagerSwift
class DialogViewController: UIViewController, DialogViewProtocol {
    func showNewRows(source: JSONDecoding.DialogsApi) {
        self.reloadTableView(width: view.bounds.width, synchronous: false, data: source)
    }
	var presenter: DialogPresenterProtocol?
    private var reloadableViewLayoutAdapter: ReloadableViewLayoutAdapter!
    private var tableView: UITableView!
    private var growingTextView: NextGrowingTextView!
    private var button: UIButton!
    var overheight: CGFloat = 0
	override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 246/255, green: 251/255, blue: 254/255, alpha: 1)
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        reloadableViewLayoutAdapter = DialogsReloadableViewLayoutAdapter(reloadableView: tableView)
        tableView.dataSource = reloadableViewLayoutAdapter
        tableView.delegate = reloadableViewLayoutAdapter
        tableView.separatorColor = .clear
        tableView.allowsSelection = false
        tableView.backgroundColor = UIColor(red: 246/255, green: 251/255, blue: 254/255, alpha: 1)
        let background = UIView(frame: view.bounds)
        let rofl = UILabel(frame: CGRect(x: 100, y: 100, width: 200, height: 100))
        rofl.text = "ЗАГРУЗКА"
        background.addSubview(rofl)
        background.backgroundColor = UIColor(red: 246/255, green: 251/255, blue: 254/255, alpha: 1)
        view.addSubview(background)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnTableView))
        tableView.addGestureRecognizer(tapGesture)
        view.addSubview(tableView)
        let width = UIScreen.main.bounds.width - 64
        growingTextView = NextGrowingTextView(frame: CGRect(x: view.center.x - width / 2, y: Constants.safeHeight - 40 - 8, width: width, height: 26.5))
        growingTextView.textView.font = UIFont.LongTextFont!.withSize(18)
        growingTextView.layer.cornerRadius = 19
        growingTextView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        growingTextView.textView.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 8, right: 34)
        growingTextView.placeholderAttributedText = NSAttributedString(
            string: NSLocalizedString("Сообщение", comment: ""),
            attributes: [NSAttributedStringKey.font: self.growingTextView.textView.font!, NSAttributedStringKey.foregroundColor: UIColor.gray
            ]
        )
        growingTextView.maxNumberOfLines = 6
        var cachedHeight: CGFloat = 40
        growingTextView.delegates.didChangeHeight = { [weak self] height in
            guard let `self` = self else { return }
            if cachedHeight < height {
                self.tableView.contentInset.bottom += height - cachedHeight
                self.growingTextView.frame.origin.y -= height - cachedHeight
                if !self.tableView.isDragging {
                    self.tableView.contentOffset.y += height - cachedHeight
                }
                self.overheight += height - cachedHeight
            } else if cachedHeight > height {
                self.tableView.contentInset.bottom -= cachedHeight - height
                self.growingTextView.frame.origin.y += cachedHeight - height
                if !self.tableView.isDragging {
                    self.tableView.contentOffset.y -= cachedHeight - height
                }
                self.overheight -= cachedHeight - height
            }
            cachedHeight = height
        }
        button = UIButton(frame: CGRect(x: view.frame.width - 64 - 4, y: Constants.safeHeight - 32 - 8 - 4, width: 32, height: 32))
        button.backgroundColor = UIColor.ITMOBlue
        button.layer.cornerRadius = button.frame.height / 2
        button.addTarget(self, action: #selector(sendUpInside), for: .touchUpInside)
        view.addSubview(growingTextView)
        view.addSubview(button)
        tableView.alpha = 0
        tableView.scrollIndicatorInsets = tableView.contentInset
        presenter?.updateView()
        registerKeyboardNotifications()
    }
    override func viewDidAppear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
        unRegisterKeyboardNotifications()
    }
    @objc func sendUpInside() {
        presenter?.prepareMessageForSend(message: growingTextView.textView.text)
        growingTextView.textView.text = ""
    }
    @objc func tapOnTableView() {
        _ = growingTextView.resignFirstResponder()
    }
    func getNewsRows(data: JSONDecoding.DialogsApi) -> [Layout] {
        var layouts = [Layout]()
        let user_id = UserDefaults.standard.integer(forKey: "user_id")
        for item in data.messages {
            var isMe = false
            if item.user_id == "\(user_id)" {
                isMe = true
            } else {
                isMe = false
            }
            layouts.append(DialogsLayout(text: item.text, isMe: isMe))
        }
        return layouts
    }
    private func reloadTableView(width: CGFloat, synchronous: Bool, data: JSONDecoding.DialogsApi) {
        reloadableViewLayoutAdapter.reloading(width: width, synchronous: synchronous, layoutProvider: { [weak self] in
            return [Section(header: nil, items: self?.getNewsRows(data: data) ?? [], footer: nil)]}, completion: {
                    let lastRowIndex = self.tableView.numberOfRows(inSection: 0) - 1
                    let pathToLastRow = IndexPath(row: lastRowIndex, section: 0)
                    self.tableView.scrollToRow(at: pathToLastRow, at: .bottom, animated: false)
                    self.tableView.alpha = 1
        })
    }
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    private func unRegisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    var inset: CGFloat!
    var cachedOverheight: CGFloat!
    var keyboardDidShow = false
    var cachedKeyboardSize: CGFloat!
    @objc private func keyboardShow(notification: NSNotification) {
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let value: NSValue = (info.value(forKey: UIKeyboardFrameEndUserInfoKey) as? NSValue)!
        let keyboardSize: CGSize = value.cgRectValue.size
        if !keyboardDidShow {
            if #available(iOS 11, *) {
                let safeInset = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom
                inset = tableView.contentInset.bottom + keyboardSize.height -  UITabBarController().tabBar.frame.height + safeInset!
            } else {
                inset = tableView.contentInset.bottom + keyboardSize.height -  UITabBarController().tabBar.frame.height
            }
            if overheight == cachedOverheight {
                tableView.contentOffset.y += inset - UITabBarController().tabBar.frame.height - overheight
                tableView.contentInset.bottom += inset - UITabBarController().tabBar.frame.height - overheight
                button.frame.origin.y -= inset - UITabBarController().tabBar.frame.height - overheight
                growingTextView.frame.origin.y -= inset - UITabBarController().tabBar.frame.height - overheight
            } else {
                tableView.contentOffset.y += inset - UITabBarController().tabBar.frame.height
                tableView.contentInset.bottom += inset - UITabBarController().tabBar.frame.height
                button.frame.origin.y -= inset - UITabBarController().tabBar.frame.height
                growingTextView.frame.origin.y -= inset - UITabBarController().tabBar.frame.height
            }
        } else {
            tableView.contentOffset.y += keyboardSize.height - cachedKeyboardSize
            tableView.contentInset.bottom += keyboardSize.height - cachedKeyboardSize
            button.frame.origin.y -= keyboardSize.height - cachedKeyboardSize
            growingTextView.frame.origin.y -= keyboardSize.height - cachedKeyboardSize
        }
        cachedKeyboardSize = keyboardSize.height
        keyboardDidShow = true
    }
    @objc private func keyboardHide(notification: NSNotification) {
        if cachedOverheight != overheight {
            tableView.contentOffset.y -= inset - UITabBarController().tabBar.frame.height
            tableView.contentInset.bottom -= inset - UITabBarController().tabBar.frame.height
            button.frame.origin.y += inset - UITabBarController().tabBar.frame.height
            growingTextView.frame.origin.y += inset - UITabBarController().tabBar.frame.height
            cachedOverheight = overheight
        } else {
            tableView.contentOffset.y -= inset - UITabBarController().tabBar.frame.height - overheight
            tableView.contentInset.bottom -= inset - UITabBarController().tabBar.frame.height - overheight
            button.frame.origin.y += inset - UITabBarController().tabBar.frame.height - overheight
            growingTextView.frame.origin.y += inset - UITabBarController().tabBar.frame.height - overheight
            cachedOverheight = 0
        }
        keyboardDidShow = false
    }
}
