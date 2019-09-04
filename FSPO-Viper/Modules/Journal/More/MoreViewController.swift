//
//  MoreViewController.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 27/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import LayoutKit

final class MoreViewController: UIViewController, MoreViewProtocol {
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
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        reloadableViewLayoutAdapter = MoreReloadableLayoutAdapter(reloadableView: tableView)
        tableView.dataSource = reloadableViewLayoutAdapter
        tableView.delegate = reloadableViewLayoutAdapter
        if #available(iOS 11, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
//        tableView.separatorColor = UIColor(white: 0.2, alpha: 1)
        tableView.backgroundColor = .white
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: 72, bottom: 0, right: 0)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        tableView.accessibilityIdentifier = "tableView"
        view.addSubview(tableView)
        storage?.async.object(forKey: "more", completion: { result in
            switch result {
            case .value(let data):
                if let decoded = try? JSONDecoder().decode(JSONDecoding.MoreApi.self, from: data) {
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
    func getNowRows(first: Bool) -> [Layout] {
        var layouts = [Layout]()
        var semester = (dataSource?.lessons_before.lessons)!
        if first {
            semester = (dataSource?.lessons_now.lessons)!
        }
        for item in semester {
            layouts.append(MoreLayout(subject: item.name, presense: "\(item.student_ex_was)", nonPresense: "\(item.student_ex_not)", allPresense: "\(item.ex_all)", attestation: "\(item.student_validmark ?? -1)", result: "\(item.student_mark ?? -1)"))
//            layouts.append(MoreLayout(subject: "Физико-Математическая", presense: "322222", nonPresense: "22279", allPresense: "112", attestation: "1", result: "0"))
        }
        if semester.count == 0 {
            layouts.append(SizeLayout(height: 0))
        }
        return layouts
    }
    func getHeader(lesson: String) -> Layout {
        let layouts = HeaderLayout(text: lesson, inset: 15)
        return layouts
    }
    private func reloadTableView(width: CGFloat, synchronous: Bool) {
        reloadableViewLayoutAdapter.reloading(width: width, synchronous: synchronous, layoutProvider: { [weak self] in
            return [Section(header: self?.getHeader(lesson: "\(self?.dataSource?.lessons_now.semester ?? 0) \(NSLocalizedString("семестр", comment: ""))"), items: self?.getNowRows(first: true) ?? [], footer: nil), Section(header: self?.getHeader(lesson: "\(self?.dataSource?.lessons_before.semester ?? 0) \(NSLocalizedString("семестр", comment: ""))"), items: self?.getNowRows(first: false) ?? [], footer: nil)]
        })
    }
}
