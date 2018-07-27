//
//  JournalBySubjectViewController.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 27/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
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
        presenter?.updateView()
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        reloadableViewLayoutAdapter = JournalBySubjectReloadableLayoutAdapter(reloadableView: tableView)
        tableView.dataSource = reloadableViewLayoutAdapter
        tableView.delegate = reloadableViewLayoutAdapter
        tableView.backgroundColor = .white
        view.addSubview(tableView)
    }
    func getNewsRows() -> [Layout] {
        var layouts = [Layout]()
        for item in (dataSource?.lessons)! {
            layouts.append(NewsPostLayout(body: item.name, time: item.semester))
        }
        return layouts
    }
    private func reloadTableView(width: CGFloat, synchronous: Bool) {
        reloadableViewLayoutAdapter.reloading(width: width, synchronous: synchronous, layoutProvider: { [weak self] in
            return [Section(header: nil, items: self?.getNewsRows() ?? [], footer: nil)]
        })
    }
}
