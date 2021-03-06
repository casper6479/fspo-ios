//
//  JournalByTeacherViewController.swift
//  FSPO
//
//  Created Николай Борисов on 07/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import LayoutKit

class JournalByTeacherViewController: UIViewController, JournalByTeacherViewProtocol {
    func updateTableView(source: JSONDecoding.JournalByTeacherAPI) {
        reloadTableView(width: view.bounds.width, synchronous: false, data: source)
    }
	var presenter: JournalByTeacherPresenterProtocol?
    private var tableView: UITableView!
    private var reloadableViewLayoutAdapter: ReloadableViewLayoutAdapter!
	override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        reloadableViewLayoutAdapter = JournalByDateReloadableLayoutAdapter(reloadableView: tableView)
        tableView.dataSource = reloadableViewLayoutAdapter
        tableView.delegate = reloadableViewLayoutAdapter
        tableView.backgroundColor = .white
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 229))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        tableView.allowsSelection = false
        view.addSubview(tableView)
        presenter?.updateView()
    }
    func setupHeader(data: JSONDecoding.JournalByTeacherAPI.TeacherInfo) {
        let width = view.bounds.width
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            let journalByTeacher = JournalByTeacherHeaderLayout(firstname: data.firstname, lastname: data.lastname, middlename: data.middlename, email: "\(data.email ?? "Не указано")", phone: NSLocalizedString("Скрыто", comment: ""), photo: data.photo)
            let arrangement = journalByTeacher.arrangement(width: width)
            DispatchQueue.main.async(execute: {
                arrangement.makeViews(in: self.tableView.tableHeaderView)
            })
        }
    }
    func getNewRows(data: JSONDecoding.JournalByTeacherAPI.Days) -> [Layout] {
        var layouts = [Layout]()
        for item in data.exercises {
            let source = JSONDecoding.JournalByDateAPI.Exercises.init(ex_period: item.ex_period, ex_topic: item.ex_topic, ex_type: item.ex_type, lesson_name: "", student_presence: item.student_presence, student_mark: item.student_mark, lesson_id: "", student_performance: item.student_performance, student_dropout: item.student_dropout, student_delay: item.student_delay)
            layouts.append(JournalLessonCellLayout(data: source))
        }
        return layouts
    }
    func getHeader(date: String) -> Layout {
        let layouts = HeaderLayout(text: date, inset: 40)
        return layouts
    }
    private func reloadTableView(width: CGFloat, synchronous: Bool, data: JSONDecoding.JournalByTeacherAPI) {
        var dataSource = [Section<[Layout]>]()
        for item in data.days {
            dataSource.append(Section(
                header: getHeader(date: DateToString().formatDateJournal(item.ddate)),
                items: self.getNewRows(data: item),
                footer: nil))
        }
        reloadableViewLayoutAdapter.reload(width: width, synchronous: synchronous, layoutProvider: { () in
            return dataSource
        })
    }

}
