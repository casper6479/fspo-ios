//
//  ScheduleViewController.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import LayoutKit

class ScheduleViewController: UIViewController, ScheduleViewProtocol {
    func showNewStudentScheduleRows(source: JSONDecoding.StudentScheduleApi) {
        var first = "Чётная"
        var second = "Нечётная"
        if source.week == "odd" {
            first = second
            second = "Чётная"
        }
        if StudentScheduleLayout.tableView?.tableHeaderView == nil {
            StudentScheduleLayout.tableView?.tableHeaderView = buildHeaderForStudentSchedule(first: first, second: second)
        }
        reloadStudentSchedule(data: source)
    }
    func showNewTeacherRows(source: JSONDecoding.GetTeachersApi) {
        reloadTeachers(data: source)
    }
    func showNewScheduleByGroupsRows(source: JSONDecoding.GetGroupsApi) {
        reloadScheduleByGroups(data: source)
    }
    func buildHeaderForStudentSchedule(first: String, second: String) -> UIView {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 36))
        header.backgroundColor = UIColor.ITMOBlue
        let items = [first, second, "Все"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.ITMOFont!],
                                                for: .normal)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.frame = CGRect(origin: CGPoint(x: 4, y: 4), size: CGSize(width: UIScreen.main.bounds.width - 8, height: 28))
        segmentedControl.tintColor = .white
        segmentedControl.addTarget(self, action: #selector(self.segmentChanged), for: .valueChanged)
        header.addSubview(segmentedControl)
        return header
    }
    private var scrollView: UIScrollView!
	var presenter: SchedulePresenterProtocol?
    private var studentScheduleLayoutAdapter: ReloadableViewLayoutAdapter?
    private var scheduleByGroupsLayoutAdapter: ReloadableViewLayoutAdapter?
    private var teachersListLayoutAdapter: ReloadableViewLayoutAdapter?
	override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.isPagingEnabled = true
        view.addSubview(scrollView)
        self.layoutFeed(width: self.view.bounds.width)
        presenter?.updateView()
    }
    @objc func segmentChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            presenter?.updateStudentSchedule(week: "now")
        } else if sender.selectedSegmentIndex == 1 {
            presenter?.updateStudentSchedule(week: "next")
        } else {
            presenter?.updateStudentSchedule(week: "all")
        }
    }
    func getTeachersRows(data: JSONDecoding.GetTeachersApi) -> [Layout]? {
        var layouts = [Layout]()
        for item in data.teachers {
            layouts.append(TeachersListCellLayout(firstname: item.firstname, lastname: item.lastname, middlename: item.middlename, photo: item.photo))
        }
        return layouts
    }
    private func reloadTableView(width: CGFloat, synchronous: Bool, layoutAdapter: ReloadableViewLayoutAdapter, ds: [Section<[Layout]>]) {
        layoutAdapter.reloading(width: width, synchronous: synchronous, layoutProvider: {
            return ds
        })
    }
    func getStudentRows(data: JSONDecoding.StudentScheduleApi.Weekdays) -> [Layout]? {
        var layouts = [Layout]()
        for item in data.periods {
            layouts.append(StudentScheduleCellLayout(schedule: item))
        }
        return layouts
    }
    func getGroupsRows(data: JSONDecoding.GetGroupsApi.Course) -> [Layout]? {
        var layouts = [Layout]()
        for item in data.groups {
            layouts.append(ScheduleByGroupsCellLayout(group: item.name))
        }
        return layouts
    }
    func setupLayoutAdapters() {
        self.studentScheduleLayoutAdapter = StudentScheduleReloadableLayoutAdapter(reloadableView: StudentScheduleLayout.tableView ?? UITableView())
        StudentScheduleLayout.tableView?.dataSource = self.studentScheduleLayoutAdapter
        StudentScheduleLayout.tableView?.delegate = self.studentScheduleLayoutAdapter
        self.scheduleByGroupsLayoutAdapter = ScheduleByGroupsReloadableLayoutAdapter(reloadableView: ScheduleByGroupsLayout.tableView ?? UITableView())
        ScheduleByGroupsLayout.tableView?.dataSource = self.scheduleByGroupsLayoutAdapter
        ScheduleByGroupsLayout.tableView?.delegate = self.scheduleByGroupsLayoutAdapter
        self.teachersListLayoutAdapter = TeacherListReloadableLayoutAdapter(reloadableView: TeachersListLayout.tableView ?? UITableView())
        TeachersListLayout.tableView?.dataSource = self.teachersListLayoutAdapter
        TeachersListLayout.tableView?.delegate = self.teachersListLayoutAdapter
    }
    func reloadStudentSchedule(data: JSONDecoding.StudentScheduleApi) {
        self.reloadTableView(width: self.view.bounds.width, synchronous: false, layoutAdapter: self.studentScheduleLayoutAdapter ?? ReloadableViewLayoutAdapter(reloadableView: UITableView()), ds: [Section(
            header: nil,
            items: getStudentRows(data: data.weekdays[0]) ?? [],
            footer: nil), Section(
                header: nil,
                items: getStudentRows(data: data.weekdays[1]) ?? [],
                footer: nil), Section(
                    header: nil,
                    items: getStudentRows(data: data.weekdays[2]) ?? [],
                    footer: nil), Section(
                        header: nil,
                        items: getStudentRows(data: data.weekdays[3]) ?? [],
                        footer: nil), Section(
                            header: nil,
                            items: getStudentRows(data: data.weekdays[4]) ?? [],
                            footer: nil), Section(
                                header: nil,
                                items: getStudentRows(data: data.weekdays[5]) ?? [],
                                footer: nil)])
    }
    func reloadTeachers(data: JSONDecoding.GetTeachersApi) {
        self.reloadTableView(width: self.view.bounds.width, synchronous: false, layoutAdapter: self.teachersListLayoutAdapter ?? ReloadableViewLayoutAdapter(reloadableView: UITableView()), ds: [Section(
            header: nil,
            items: getTeachersRows(data: data) ?? [],
            footer: nil)])
    }
    func reloadScheduleByGroups(data: JSONDecoding.GetGroupsApi) {
        self.reloadTableView(width: self.view.bounds.width, synchronous: false, layoutAdapter:
            self.scheduleByGroupsLayoutAdapter ?? ReloadableViewLayoutAdapter(reloadableView: UITableView()), ds: [Section(
                header: nil,
                items: getGroupsRows(data: data.courses[0]) ?? [],
                footer: nil), Section(
                    header: nil,
                    items: getGroupsRows(data: data.courses[1]) ?? [],
                    footer: nil), Section(
                        header: nil,
                        items: getGroupsRows(data: data.courses[2]) ?? [],
                        footer: nil), Section(
                            header: nil,
                            items: getGroupsRows(data: data.courses[3]) ?? [],
                            footer: nil)])
    }
    private func layoutFeed(width: CGFloat) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
            let scheduleLayout = ScheduleLayout()
            let arrangement = scheduleLayout.arrangement(width: width * 3)
            DispatchQueue.main.async(execute: {
                self.scrollView.contentSize = arrangement.frame.size
                arrangement.makeViews(in: self.scrollView)
                self.setupLayoutAdapters()
            })
        }
    }

}
