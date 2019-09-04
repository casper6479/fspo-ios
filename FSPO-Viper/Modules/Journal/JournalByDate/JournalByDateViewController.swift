//
//  JournalByDateViewController.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 27/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import LayoutKit
var journalByDateController = JournalByDateViewController()
class JournalByDateViewController: UIViewController, JournalByDateViewProtocol {
    static var publicDS: JSONDecoding.JournalByDateAPI?
    func updateTableView(source: JSONDecoding.JournalByDateAPI) {
        JournalByDateViewController.publicDS = source
        reloadTableView(width: view.bounds.width, synchronous: false, data: source)
    }
    var presenter: JournalByDatePresenterProtocol?
    private var tableView: UITableView!
    private var reloadableViewLayoutAdapter: ReloadableViewLayoutAdapter!
    private var scheduleView: UIView!
    private let dateFormatter = DateFormatter()
    var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ITMOBlue
        title = NSLocalizedString("По дате", comment: "")
        let width = view.bounds.width
        var safearea: CGFloat = 0
        if #available(iOS 11, *) {
//            safearea = (navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height
            navigationItem.largeTitleDisplayMode = .never
            safearea = 0
        }
        datePicker = {
            let datePicker = UIDatePicker(frame: CGRect(x: 0, y: safearea, width: width, height: 100))
            datePicker.setValue(UIColor.white, forKey: "textColor")
            datePicker.timeZone = .current
            datePicker.datePickerMode = .date
            datePicker.backgroundColor = UIColor.ITMOBlue
            datePicker.addTarget(self, action: #selector(dateDidChanged), for: .valueChanged)
            return datePicker
        }()
        view.addSubview(datePicker)
        datePicker.backgroundColor = UIColor.ITMOBlue
        scheduleView = UIView(frame: CGRect(x: 0, y: safearea+100, width: view.bounds.width, height: Constants.safeHeight-100))
        scheduleView.backgroundColor = .white
        view.addSubview(scheduleView)
        tableView = UITableView(frame: scheduleView.bounds, style: .plain)
//        scheduleView.autoresizingMask
//        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        reloadableViewLayoutAdapter = JournalByDateReloadableLayoutAdapter(reloadableView: tableView)
        tableView.dataSource = reloadableViewLayoutAdapter
        tableView.delegate = reloadableViewLayoutAdapter
        tableView.backgroundColor = .white
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        tableView.tableFooterView = footer
        scheduleView.addSubview(tableView)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        showNoLessons()
        presenter?.updateView(date: dateFormatter.string(from: Date()))
    }
    func getNewRows(data: JSONDecoding.JournalByDateAPI.Exercises) -> [Layout] {
        var layouts = [Layout]()
        layouts.append(JournalLessonCellLayout(data: data))
        return layouts
    }
    func showNoLessons() {
        let width = view.bounds.width
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            let noLessonsLayout = NoLessonsLayout()
            let arrangement = noLessonsLayout.arrangement(width: width)
            DispatchQueue.main.async(execute: {
                arrangement.makeViews(in: self.scheduleView)
            })
        }
    }
    func hideNoLessons() {
        NoLessonsLayout.noLessonView.removeFromSuperview()
    }
    @objc func dateDidChanged() {
        hideNoLessons()
        presenter?.updateView(date: dateFormatter.string(from: datePicker.date))
    }
    func getHeader(lesson: String) -> Layout {
        let layouts = HeaderLayout(text: lesson, inset: 40)
        return layouts
    }
    private func reloadTableView(width: CGFloat, synchronous: Bool, data: JSONDecoding.JournalByDateAPI) {
        var dataSource = [Section<[Layout]>]()
        for item in data.exercises {
            dataSource.append(Section(
                header: getHeader(lesson: item.lesson_name),
                items: self.getNewRows(data: item),
                footer: nil))
        }
        reloadableViewLayoutAdapter.reload(width: width, synchronous: synchronous, layoutProvider: { () in
            return dataSource
        })
    }
}
