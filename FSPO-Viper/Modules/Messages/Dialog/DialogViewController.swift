//
//  DialogViewController.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 05/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import LayoutKit
import NextGrowingTextView
import IQKeyboardManagerSwift
import Cache

class DialogViewController: UIViewController, DialogViewProtocol, UITextViewDelegate, UITabBarControllerDelegate {
    func showNewRows(source: JSONDecoding.DialogsApi) {
        DispatchQueue.main.async {
            self.reloadTableView(width: self.view.bounds.width, synchronous: false, data: source)
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            UIView.animate(withDuration: 0.1) {
                self.button.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.button.alpha = 0
            }
        } else {
            UIView.animate(withDuration: 0.1) {
                self.button.transform = CGAffineTransform.identity
                self.button.alpha = 1
            }
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            clearCache(forKey: "textField\(dialogId!)")
        } else {
            updateCache(with: textView.text.data(using: .utf8)!, forKey: "textField\(dialogId!)", expiry: .never)
        }
    }
	var presenter: DialogPresenterProtocol?
    private var reloadableViewLayoutAdapter: ReloadableViewLayoutAdapter!
    private var tableView: UITableView!
    private var growingTextView: NextGrowingTextView!
    private var button: UIButton!
    var dialogId: Int!
    var overheight: CGFloat = 0
    weak var cachedDelegate: UITabBarControllerDelegate?
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.delegate = cachedDelegate
    }
	override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        cachedDelegate = self.tabBarController?.delegate
        self.tabBarController?.delegate = self
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
        growingTextView.textView.delegate = self
        growingTextView.textView.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 8, right: 34)
        growingTextView.placeholderAttributedText = NSAttributedString(
            string: NSLocalizedString("Сообщение", comment: ""),
            attributes: [NSAttributedStringKey.font: self.growingTextView.textView.font!, NSAttributedStringKey.foregroundColor: UIColor.gray
            ]
        )
        growingTextView.maxNumberOfLines = 6
        growingTextView.scrollIndicatorInsets = UIEdgeInsets(top: 19, left: 0, bottom: 34, right: 0)
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
        button.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        button.alpha = 0
        storage?.async.object(forKey: "textField\(dialogId!)", completion: { result in
            switch result {
            case .value(let data):
                let text = String(data: data, encoding: .utf8)
                DispatchQueue.main.async {
                    self.growingTextView.textView.text = text
                    self.button.transform = CGAffineTransform.identity
                    self.button.alpha = 1
                }
            case .error(let error):
                print(error)
            }
        })
        view.addSubview(growingTextView)
        view.addSubview(button)
        tableView.alpha = 0
        storage?.async.object(forKey: "dialogs\(dialogId!)", completion: { result in
            switch result {
            case .value(let data):
                if let decoded = try? JSONDecoder().decode(JSONDecoding.DialogsApi.self, from: data) {
                    self.showNewRows(source: decoded)
                    self.presenter?.updateView(cache: decoded)
                } else {
                    self.presenter?.updateView(cache: nil)
                }
            case .error:
                self.presenter?.updateView(cache: nil)
            }
        })
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
        UIView.animate(withDuration: 0.1) {
            self.button.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.button.alpha = 0
        }
    }
    @objc func tapOnTableView() {
        _ = growingTextView.resignFirstResponder()
    }
    func showError(alert: UIAlertController) {
        self.navigationController?.popViewController(animated: true)
        present(alert, animated: true, completion: nil)
    }
    func getNewRows(data: JSONDecoding.DialogsApi) -> [Layout] {
        var layouts = [Layout]()
        let user_id = UserDefaults.standard.integer(forKey: "user_id")
        for item in data.messages {
            var isMe = false
            if item.user_id == "\(user_id)" {
                isMe = true
            } else {
                isMe = false
            }
            layouts.append(DialogsLayout(text: item.text, isMe: isMe, unread: !item.read))
        }
        return layouts
    }
    private func reloadTableView(width: CGFloat, synchronous: Bool, data: JSONDecoding.DialogsApi) {
        reloadableViewLayoutAdapter.reloading(width: width, synchronous: synchronous, layoutProvider: { [weak self] in
            return [Section(header: nil, items: self?.getNewRows(data: data) ?? [], footer: nil)]}, completion: {
                let lastRowIndex = self.tableView.numberOfRows(inSection: 0) - 1
                let pathToLastRow = IndexPath(row: lastRowIndex, section: 0)
                if data.messages.count > 0 {
                    self.tableView.scrollToRow(at: pathToLastRow, at: .bottom, animated: false)
                }
                UIView.animate(withDuration: 0.2, animations: {
                    self.tableView.alpha = 1
                })
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
    var inset: CGFloat = 0
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
                inset = keyboardSize.height - UITabBarController().tabBar.frame.height - safeInset!
            } else {
                inset = keyboardSize.height - UITabBarController().tabBar.frame.height
            }
            if overheight == cachedOverheight {
                tableView.scrollIndicatorInsets.bottom += inset - overheight
                tableView.contentOffset.y += inset - overheight
                tableView.contentInset.bottom += inset - overheight
                button.frame.origin.y -= inset - overheight
                growingTextView.frame.origin.y -= inset - overheight
            } else {
                tableView.scrollIndicatorInsets.bottom += inset
                tableView.contentOffset.y += inset
                tableView.contentInset.bottom += inset
                button.frame.origin.y -= inset
                growingTextView.frame.origin.y -= inset
            }
        } else {
            tableView.scrollIndicatorInsets.bottom += keyboardSize.height - cachedKeyboardSize
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
            tableView.scrollIndicatorInsets.bottom -= inset
            tableView.contentOffset.y -= inset
            tableView.contentInset.bottom -= inset
            button.frame.origin.y += inset
            growingTextView.frame.origin.y += inset
            cachedOverheight = overheight
        } else {
            tableView.scrollIndicatorInsets.bottom -= inset + overheight
            tableView.contentOffset.y -= inset + overheight
            tableView.contentInset.bottom -= inset + overheight
            button.frame.origin.y += inset + overheight
            growingTextView.frame.origin.y += inset + overheight
            cachedOverheight = 0
        }
        keyboardDidShow = false
    }
}
