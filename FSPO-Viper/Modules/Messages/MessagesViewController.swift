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
    private var previousIndex = 0
    func showNewRows(source: JSONDecoding.MessagesApi) {
        publicDS = source
        DispatchQueue.main.async {
            self.reloadTableView(width: self.tableView.frame.width, synchronous: false, data: source)
        }
    }
	var presenter: MessagesPresenterProtocol?
    private var reloadableViewLayoutAdapter: ReloadableViewLayoutAdapter!
    private var tableView: UITableView!
    var filteredDialogs = [JSONDecoding.MessagesApi.DialogBody]()
    let refreshControl = UIRefreshControl()
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        self.presenter?.updateView(cache: nil)
    }
    let searchController = UISearchController(searchResultsController: nil)
	override func viewDidLoad() {
        super.viewDidLoad()
        let newButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let itemImage = UIImage(named: "new")
        newButton.setImage(itemImage, for: .normal)
        newButton.imageView?.contentMode = .scaleAspectFit
        newButton.addTarget(self, action: #selector(setNeedsShowNew), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: newButton)
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .ITMOBlue
        searchController.searchBar.barStyle = .blackTranslucent
        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        }
        definesPresentationContext = true
        self.extendedLayoutIncludesOpaqueBars = true
        UIApplication.shared.keyWindow?.backgroundColor = .white
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tableView = UITableView(frame: view.bounds, style: .plain)
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.backgroundView = refreshControl
        }
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        reloadableViewLayoutAdapter = MessagesReloadableViewLayoutAdapter(reloadableView: tableView)
        tableView.dataSource = reloadableViewLayoutAdapter
        tableView.delegate = reloadableViewLayoutAdapter
        tableView.separatorColor = .clear
        tableView.backgroundColor = .backgroundGray
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
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
    }
    @objc func setNeedsShowNew() {
        self.navigationController?.show(SearchRouter.createModule(), sender: self)
    }
    override func viewDidAppear(_ animated: Bool) {
        if #available(iOS 11, *) {
            if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
                textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                if let leftView = textfield.leftView as? UIImageView {
                    leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                    leftView.tintColor = UIColor.white
                }
            }
        }
    }
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredDialogs = publicDS!.dialogs.filter({(dialog: JSONDecoding.MessagesApi.DialogBody) -> Bool in
            return dialog.dialog_lastname.lowercased().contains(searchText.lowercased()) || dialog.dialog_firstname.lowercased().contains(searchText.lowercased())
        })
        let filteredData = JSONDecoding.MessagesApi(dialogs: filteredDialogs)
        if isFiltering() {
            reloadTableView(width: view.bounds.width, synchronous: false, data: filteredData)
        }
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
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    private func reloadTableView(width: CGFloat, synchronous: Bool, data: JSONDecoding.MessagesApi) {
        reloadableViewLayoutAdapter.reloading(width: width, synchronous: synchronous, layoutProvider: { [weak self] in
            return [Section(header: nil, items: self?.getNewRows(data: data) ?? [], footer: nil)]
            }, completion: {
                self.refreshControl.endRefreshing()
        })
    }
}
extension MessagesReloadableViewLayoutAdapter {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let controller = tableView.controller() as? MessagesViewController
        if controller!.isFiltering() {
            return controller!.filteredDialogs.count
        }
        return currentArrangement[section].items.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = tableView.controller() as? MessagesViewController
        let datasource = vc!.publicDS
        let firstname = vc!.isFiltering() ? vc!.filteredDialogs[indexPath.row].dialog_firstname : datasource?.dialogs[indexPath.row].dialog_firstname
        let lastname = vc!.isFiltering() ? vc!.filteredDialogs[indexPath.row].dialog_lastname : datasource?.dialogs[indexPath.row].dialog_lastname
        let dialogId = vc!.isFiltering() ? (vc!.filteredDialogs[indexPath.row].dialog_user_id) :(datasource?.dialogs[indexPath.row].dialog_user_id)!
        tableView.navigationController()?.show(DialogRouter.createModule(dialog_id: dialogId, title: "\(firstname!) \(lastname!)"), sender: MessagesViewController())
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = currentArrangement[indexPath.section].items[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReloadableViewLayoutAdapter.self), for: indexPath)
        DispatchQueue.main.async {
            item.makeViews(in: cell.contentView)
        }
        return cell
    }
}
extension MessagesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchBarIsEmpty() {
            self.reloadTableView(width: self.tableView.frame.width, synchronous: false, data: publicDS!)
        }
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
