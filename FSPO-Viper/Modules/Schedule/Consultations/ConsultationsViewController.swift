//
//  ConsultationsViewController.swift
//  FSPO
//
//  Created Николай Борисов on 03/09/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import LayoutKit

class ConsultationsViewController: UIViewController, ConsultationsViewProtocol {

	var presenter: ConsultationsPresenterProtocol?
    private var reloadableViewLayoutAdapter: ReloadableViewLayoutAdapter!
    private var tableView: UITableView!
    func showNewRows(data: [[String: Any]]) {
        self.reloadTableView(width: tableView.frame.width, synchronous: false, data: data)
    }
	override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = NSLocalizedString("Консультации", comment: "")
        presenter?.updateView()
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.separatorColor = .clear
        tableView.backgroundColor = .backgroundGray
        tableView.allowsSelection = false
        reloadableViewLayoutAdapter = ConsultationsReloadableLayoutAdapter(reloadableView: tableView)
        tableView.dataSource = reloadableViewLayoutAdapter
        tableView.delegate = reloadableViewLayoutAdapter
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 10))
        footer.backgroundColor = .backgroundGray
        tableView.tableFooterView = footer
        view.addSubview(tableView)
    }
    func getNewsRows(data: [[String: Any]]) -> [Layout] {
        var layouts = [Layout]()
        for item in data {
            layouts.append(ConsultationsLayout(data: item))
        }
        return layouts
    }
    private func reloadTableView(width: CGFloat, synchronous: Bool, data: [[String: Any]]) {
        reloadableViewLayoutAdapter.reload(width: width, synchronous: synchronous, layoutProvider: { [weak self] in
            return [Section(header: nil, items: self?.getNewsRows(data: data) ?? [], footer: nil)]
        })
    }
}
