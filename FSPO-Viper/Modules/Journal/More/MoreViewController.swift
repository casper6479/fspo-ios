//
//  MoreViewController.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 27/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import LayoutKit

class MoreViewController: UIViewController, MoreViewProtocol {
    var dataSource: JSONDecoding.MoreApi?
	var presenter: MorePresenterProtocol?
    private var reloadableViewLayoutAdapter: ReloadableViewLayoutAdapter!
    private var tableView: UITableView!
    func showNewRows(source: JSONDecoding.MoreApi) {
        dataSource = source
        self.reloadTableView(width: tableView.frame.width, synchronous: false)
    }
	override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Подробнее", comment: "")
        presenter?.updateView()
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        reloadableViewLayoutAdapter = MoreReloadableLayoutAdapter(reloadableView: tableView)
        tableView.dataSource = reloadableViewLayoutAdapter
        tableView.delegate = reloadableViewLayoutAdapter
        tableView.backgroundColor = .white
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: 72, bottom: 0, right: 0)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        view.addSubview(tableView)
    }
    func getNowRows(first: Bool) -> [Layout] {
        var layouts = [Layout]()
        var semester = (dataSource?.lessons_before.lessons)!
        if !first {
            semester = (dataSource?.lessons_now.lessons)!
        }
        for item in semester {
            layouts.append(MoreLayout(subject: item.name, presense: "\(item.student_ex_was)", nonPresense: "\(item.student_ex_not)", allPresense: "\(item.ex_all)", attestation: "\(item.student_validmark ?? -1)", result: "\(item.student_mark ?? -1)"))
        }
        return layouts
    }
    private func reloadTableView(width: CGFloat, synchronous: Bool) {
        reloadableViewLayoutAdapter.reloading(width: width, synchronous: synchronous, layoutProvider: { [weak self] in
            return [Section(header: nil, items: self?.getNowRows(first: true) ?? [], footer: nil), Section(header: nil, items: self?.getNowRows(first: true) ?? [], footer: nil)]
        })
    }
}
