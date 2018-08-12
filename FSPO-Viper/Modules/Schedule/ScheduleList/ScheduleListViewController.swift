//
//  ScheduleListViewController.swift
//  FSPO
//
//  Created Николай Борисов on 09/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import LayoutKit

class ScheduleListViewController: UIViewController, ScheduleListViewProtocol {
    private var tableView: UITableView!
    private var reloadableViewLayoutAdapter: ReloadableViewLayoutAdapter!
    var scheduleType: String?
    var id: Int!
    func showNewScheduleRows(source: JSONDecoding.StudentScheduleApi, type: String) {
        var first = NSLocalizedString("Чётная", comment: "")
        var second = NSLocalizedString("Нечётная", comment: "")
        if source.week == "odd" {
            first = second
            second = NSLocalizedString("Чётная", comment: "")
        }
        DispatchQueue.main.async {
            if self.tableView.tableHeaderView == nil {
                self.tableView.tableHeaderView = self.buildHeaderForStudentSchedule(first: first, second: second)
            }
            self.reloadTableView(width: self.view.bounds.width, synchronous: false, data: source, type: type)
        }
    }

	var presenter: ScheduleListPresenterProtocol?

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
    @objc func segmentChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            presenter?.updateSchedule(week: "now")
        } else if sender.selectedSegmentIndex == 1 {
            presenter?.updateSchedule(week: "next")
        } else {
            presenter?.updateSchedule(week: "all")
        }
    }
	override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        reloadableViewLayoutAdapter = ScheduleReloadableLayoutAdapter(reloadableView: tableView)
        tableView.dataSource = reloadableViewLayoutAdapter
        tableView.delegate = reloadableViewLayoutAdapter
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        view.addSubview(tableView)
        storage?.async.object(forKey: "\(scheduleType!)\(id!)", completion: { result in
            switch result {
            case .value(let data):
                if let decoded = try? JSONDecoder().decode(JSONDecoding.StudentScheduleApi.self, from: data) {
                    self.showNewScheduleRows(source: decoded, type: self.scheduleType!)
                    self.presenter?.updateView(cache: decoded)
                } else {
                    self.presenter?.updateView(cache: nil)
                }
            case .error:
                self.presenter?.updateView(cache: nil)
            }
        })
    }
    func getNewRows(data: JSONDecoding.StudentScheduleApi.Weekdays, type: String) -> [Layout]? {
        var layouts = [Layout]()
        for item in data.periods {
            layouts.append(StudentScheduleCellLayout(schedule: item, type: type))
        }
        if data.periods.count == 0 {
            layouts.append(NoScheduleCellLayout())
        }
        return layouts
    }
    private func reloadTableView(width: CGFloat, synchronous: Bool, data: JSONDecoding.StudentScheduleApi, type: String) {
        reloadableViewLayoutAdapter.reloading(width: width, synchronous: synchronous, layoutProvider: {
            return [Section(
                header: nil,
                items: self.getNewRows(data: data.weekdays[0], type: type) ?? [],
                footer: nil), Section(
                    header: nil,
                    items: self.getNewRows(data: data.weekdays[1], type: type) ?? [],
                    footer: nil), Section(
                        header: nil,
                        items: self.getNewRows(data: data.weekdays[2], type: type) ?? [],
                        footer: nil), Section(
                            header: nil,
                            items: self.getNewRows(data: data.weekdays[3], type: type) ?? [],
                            footer: nil), Section(
                                header: nil,
                                items: self.getNewRows(data: data.weekdays[4], type: type) ?? [],
                                footer: nil), Section(
                                    header: nil,
                                    items: self.getNewRows(data: data.weekdays[5], type: type) ?? [],
                                    footer: nil)]
        }, completion: {
            var day = Calendar.current.component(.weekday, from: Date())
            var indexPath = IndexPath(row: 0, section: 0)
            day -= 2
            if day == -1 {
                indexPath = IndexPath(row: 0, section: 0)
            } else {
                indexPath = IndexPath(row: 0, section: day)
            }
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        })
    }
}
class ScheduleReloadableLayoutAdapter: ReloadableViewLayoutAdapter {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let weekdays = [NSLocalizedString("Понедельник", comment: ""),
                        NSLocalizedString("Вторник", comment: ""),
                        NSLocalizedString("Среда", comment: ""),
                        NSLocalizedString("Четверг", comment: ""),
                        NSLocalizedString("Пятница", comment: ""),
                        NSLocalizedString("Суббота", comment: "")]
        return weekdays[section]
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.backgroundView?.backgroundColor = UIColor.ITMOBlue
        header?.textLabel?.font = UIFont.ITMOFontBold?.withSize(17)
        header?.textLabel?.backgroundColor = UIColor.ITMOBlue
        var day = Calendar.current.component(.weekday, from: Date())
        day -= 2
        if section == day {
            header?.backgroundView?.backgroundColor = UIColor(red: 65/255, green: 182/255, blue: 69/255, alpha: 1.0)
            header?.textLabel?.backgroundColor = UIColor(red: 65/255, green: 182/255, blue: 69/255, alpha: 1.0)
        }
        header?.textLabel?.textColor = .white
    }
}
