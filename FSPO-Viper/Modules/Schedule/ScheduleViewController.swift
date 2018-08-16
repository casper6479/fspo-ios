//
//  ScheduleViewController.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import LayoutKit

class ScheduleViewController: UIViewController, ScheduleViewProtocol, UIScrollViewDelegate {
    static var publicGroupsDS: JSONDecoding.GetGroupsApi?
    static var publicTeachersDS: JSONDecoding.GetTeachersApi?
    var withMy: Bool!
    func showNewStudentScheduleRows(source: JSONDecoding.StudentScheduleApi) {
        var first = NSLocalizedString("Чётная", comment: "")
        var second = NSLocalizedString("Нечётная", comment: "")
        if source.week == "odd" {
            first = second
            second = NSLocalizedString("Чётная", comment: "")
        }
        DispatchQueue.main.async {
            if StudentScheduleLayout.tableView?.tableHeaderView == nil {
                StudentScheduleLayout.tableView?.tableHeaderView = self.buildHeaderForStudentSchedule(first: first, second: second)
            }
            self.reloadStudentSchedule(data: source)
        }
    }
    func showNewTeacherRows(source: JSONDecoding.GetTeachersApi) {
        ScheduleViewController.publicTeachersDS = source
        DispatchQueue.main.async {
            self.reloadTeachers(data: source)
        }
    }
    func showNewScheduleByGroupsRows(source: JSONDecoding.GetGroupsApi) {
        ScheduleViewController.publicGroupsDS = source
        DispatchQueue.main.async {
            self.reloadScheduleByGroups(data: source)
        }
    }
    func buildHeaderForStudentSchedule(first: String, second: String) -> UIView {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 36))
        header.backgroundColor = UIColor.ITMOBlue
        let items = [first, second, NSLocalizedString("Все", comment: "")]
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
    private var pageControl: UIPageControl!
	override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        view.addSubview(scrollView)
        pageControl = UIPageControl(frame: CGRect(origin: CGPoint(x: view.bounds.width / 2 - 100, y: Constants.safeHeight - 36), size: CGSize(width: 200, height: 20)))
        pageControl.currentPageIndicatorTintColor = UIColor.ITMOBlue
        pageControl.pageIndicatorTintColor = UIColor.ITMOBlue.withAlphaComponent(0.26)
        pageControl.numberOfPages = withMy ? 3 : 2
        pageControl.isUserInteractionEnabled = false
        let pageBack = UIView(frame: pageControl.frame)
        pageBack.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 0.75)
        pageBack.frame.size.width = 50
        pageBack.frame.origin.x = view.bounds.width / 2 - 25
        pageBack.layer.cornerRadius = 5
        view.addSubview(pageBack)
        view.addSubview(pageControl)
        self.layoutView(width: self.view.bounds.width)
        do {
            let data = try ScheduleStorage().storage?.object(forKey: "schedulenow")
            let decoded = try JSONDecoder().decode(JSONDecoding.StudentScheduleApi.self, from: data!)
            self.showNewStudentScheduleRows(source: decoded)
            self.presenter?.updateSchedule(cache: decoded)
        } catch {
            self.presenter?.updateSchedule(cache: nil)
        }
        storage?.async.object(forKey: "groups", completion: { result in
            switch result {
            case .value(let data):
                if let decoded = try? JSONDecoder().decode(JSONDecoding.GetGroupsApi.self, from: data) {
                    self.showNewScheduleByGroupsRows(source: decoded)
                    self.presenter?.updateGroups(cache: decoded)
                } else {
                    self.presenter?.updateGroups(cache: nil)
                }
            case .error:
                self.presenter?.updateGroups(cache: nil)
            }
        })
        storage?.async.object(forKey: "teachers", completion: { result in
            switch result {
            case .value(let data):
                if let decoded = try? JSONDecoder().decode(JSONDecoding.GetTeachersApi.self, from: data) {
                    self.showNewTeacherRows(source: decoded)
                    self.presenter?.updateTeachers(cache: decoded)
                } else {
                    self.presenter?.updateTeachers(cache: nil)
                }
            case .error:
                self.presenter?.updateTeachers(cache: nil)
            }
        })
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = view.bounds.width
        pageControl.currentPage = 0
        if scrollView.contentOffset.x > width / 2 + width {
            pageControl.currentPage = 2
        } else if scrollView.contentOffset.x > width / 2 {
            pageControl.currentPage = 1
        }
    }
    @objc func segmentChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
             updateSchedule(week: "now")
        } else if sender.selectedSegmentIndex == 1 {
             updateSchedule(week: "next")
        } else {
            updateSchedule(week: "all")
        }
    }
    func updateSchedule(week: String) {
        do {
            let data = try ScheduleStorage().storage?.object(forKey: "schedule\(week)")
            let decoded = try JSONDecoder().decode(JSONDecoding.StudentScheduleApi.self, from: data!)
            self.showNewStudentScheduleRows(source: decoded)
            presenter?.updateStudentSchedule(week: week, cache: decoded)
        } catch {
            presenter?.updateStudentSchedule(week: week, cache: nil)
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
        }, completion: {
            if layoutAdapter == self.studentScheduleLayoutAdapter {
                if !UserDefaults.standard.bool(forKey: "spring") {
                    var day = Calendar.current.component(.weekday, from: Date())
                    var indexPath = IndexPath(row: 0, section: 0)
                    day -= 2
                    if day == -1 {
                        indexPath = IndexPath(row: 0, section: 0)
                    } else {
                        indexPath = IndexPath(row: 0, section: day)
                    }
                    StudentScheduleLayout.tableView?.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        })
    }
    func getStudentRows(data: JSONDecoding.StudentScheduleApi.Weekdays, isToday: Bool) -> [Layout]? {
        var layouts = [Layout]()
        let type = UserDefaults.standard.string(forKey: "role") == "teacher" ? "teacher" : "group"
        for item in data.periods {
            layouts.append(StudentScheduleCellLayout(schedule: item, type: type, isToday: isToday))
        }
        if data.periods.count == 0 {
            layouts.append(NoScheduleCellLayout())
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
        var day = Calendar.current.component(.weekday, from: Date())
        day -= 2
        var layouts = [Section<[Layout]>]()
        for i in 0...5 {
            layouts.append(Section(
                header: nil,
                items: self.getStudentRows(data: data.weekdays[i], isToday: i == day ? true : false) ?? [],
                footer: nil))
        }
        self.reloadTableView(width: self.view.bounds.width, synchronous: false, layoutAdapter: self.studentScheduleLayoutAdapter ?? ReloadableViewLayoutAdapter(reloadableView: UITableView()), ds: layouts)
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
    private func layoutView(width: CGFloat) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
            let scheduleLayout = ScheduleLayout(withMySchedule: self.withMy)
            let arrangementWidth = self.withMy ? width * 3 : width * 2
            let arrangement = scheduleLayout.arrangement(width: arrangementWidth)
            DispatchQueue.main.async(execute: {
                self.scrollView.contentSize = arrangement.frame.size
                arrangement.makeViews(in: self.scrollView)
                self.setupLayoutAdapters()
            })
        }
    }

}
