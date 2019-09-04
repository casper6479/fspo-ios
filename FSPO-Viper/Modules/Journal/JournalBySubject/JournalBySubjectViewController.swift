//
//  JournalBySubjectViewController.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 27/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import LayoutKit

class JournalBySubjectViewController: UIViewController, JournalBySubjectViewProtocol {
    var dataSource: JSONDecoding.JournalBySubjectsApi?
	var presenter: JournalBySubjectPresenterProtocol?
    private var reloadableViewLayoutAdapter: ReloadableViewLayoutAdapter!
    private var tableView: UITableView!
    func showNewRows(source: JSONDecoding.JournalBySubjectsApi) {
        dataSource = source
        self.reloadTableView(width: tableView.frame.width, synchronous: false)
    }
	override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("По предметам", comment: "")
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        reloadableViewLayoutAdapter = JournalBySubjectReloadableLayoutAdapter(reloadableView: tableView)
        tableView.dataSource = reloadableViewLayoutAdapter
        tableView.delegate = reloadableViewLayoutAdapter
        tableView.backgroundColor = .white
        if #available(iOS 11, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
//        tableView.separatorColor = UIColor(white: 0.2, alpha: 1)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 64, bottom: 0, right: 0)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        view.addSubview(tableView)
        storage?.async.object(forKey: "journalBySubject", completion: { result in
            switch result {
            case .value(let data):
                if let decoded = try? JSONDecoder().decode(JSONDecoding.JournalBySubjectsApi.self, from: data) {
                    DispatchQueue.main.async {
                        self.showNewRows(source: decoded)
                    }
                    self.presenter?.updateView(cache: decoded)
                } else {
                    self.presenter?.updateView(cache: nil)
                }
            case .error:
                self.presenter?.updateView(cache: nil)
            }
        })
    }
    func getNewRows() -> [Layout] {
        var layouts = [Layout]()
        for item in (dataSource?.lessons)! {
            layouts.append(JournalBySubjectLayout(sem: item.semester, subject: item.name))
        }
        return layouts
    }
    private func reloadTableView(width: CGFloat, synchronous: Bool) {
        reloadableViewLayoutAdapter.reloading(width: width, synchronous: synchronous, layoutProvider: { [weak self] in
            return [Section(header: nil, items: self?.getNewRows() ?? [], footer: nil)]
        })
    }
}
