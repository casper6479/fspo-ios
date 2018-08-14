//
//  MessagesViewController.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import LayoutKit
import Crashlytics

class MessagesViewController: UIViewController, MessagesViewProtocol {
    var publicDS: JSONDecoding.MessagesApi?
    func showNewRows(source: JSONDecoding.MessagesApi) {
        publicDS = source
        DispatchQueue.main.async {
            self.reloadTableView(width: self.tableView.frame.width, synchronous: false, data: source)
        }
    }
	var presenter: MessagesPresenterProtocol?
    private var reloadableViewLayoutAdapter: ReloadableViewLayoutAdapter!
    private var tableView: UITableView!
	override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem()
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        reloadableViewLayoutAdapter = MessagesReloadableViewLayoutAdapter(reloadableView: tableView)
        tableView.dataSource = reloadableViewLayoutAdapter
        tableView.delegate = reloadableViewLayoutAdapter
        tableView.separatorColor = .clear
        tableView.backgroundColor = UIColor.backgroundGray
        view.addSubview(tableView)
        storage?.async.object(forKey: "messages", completion: { result in
            switch result {
            case .value(let data):
                if let decoded = try? JSONDecoder().decode(JSONDecoding.MessagesApi.self, from: data) {
                    self.showNewRows(source: decoded)
                    self.presenter?.updateView(cache: decoded)
                } else {
                    self.presenter?.updateView(cache: nil)
                }
            case .error:
                self.presenter?.updateView(cache: nil)
            }
        })
    }
    func getNewRows(data: JSONDecoding.MessagesApi) -> [Layout] {
        var layouts = [Layout]()
        let user_id = UserDefaults.standard.integer(forKey: "user_id")
        for item in data.dialogs {
            var message = ""
            if item.msg_user_id == user_id {
                message = "Я: \(item.msg_text)"
            } else {
                message = "\(item.msg_text)"
            }
            layouts.append(MessagesLayout(name: "\(item.dialog_firstname) \(item.dialog_lastname)", lastMessage: message, photo: item.dialog_photo, date: DateToString().formatDateMessages(item.msg_datetime)))
        }
        return layouts
    }
    private func reloadTableView(width: CGFloat, synchronous: Bool, data: JSONDecoding.MessagesApi) {
        reloadableViewLayoutAdapter.reloading(width: width, synchronous: synchronous, layoutProvider: { [weak self] in
            return [Section(header: nil, items: self?.getNewRows(data: data) ?? [], footer: nil)]
        })
    }
}
extension MessagesReloadableViewLayoutAdapter {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = tableView.controller() as? MessagesViewController
        let datasource = vc!.publicDS
        let firstname = datasource?.dialogs[indexPath.row].dialog_firstname
        let lastname = datasource?.dialogs[indexPath.row].dialog_lastname
        let dialogId = (datasource?.dialogs[indexPath.row].dialog_user_id)!
        tableView.navigationController()?.show(DialogRouter.createModule(dialog_id: dialogId, title: "\(firstname!) \(lastname!)"), sender: MessagesViewController())
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
