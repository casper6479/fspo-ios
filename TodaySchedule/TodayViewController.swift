//
//  TodayViewController.swift
//  TodaySchedule
//
//  Created by Николай Борисов on 10/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import NotificationCenter
import LayoutKit
import Alamofire

class TodayViewController: UIViewController, NCWidgetProviding {
    var reloadableViewLayoutAdapter: ReloadableViewLayoutAdapter!
    var secondReloadableViewLayoutAdapter: ReloadableViewLayoutAdapter!
    var tableView: UITableView!
    var defaults = UserDefaults(suiteName: "group.com.fspo.app")
    var activeTableView: UITableView!
    let toolbar: UIView = {
        let toolbar = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 36))
        toolbar.backgroundColor = UIColor.white.withAlphaComponent(0.28)
        return toolbar
    }()
    @objc func buttonCancel(sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = .identity
        }
    }
    @objc func buttonDown(sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }
    }
    @objc func buttonUpInside(sender: UIButton) {
        selectButton(button: sender)
        if sender == leftButton {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.tableView.frame.origin.x += self.view.bounds.width
                self.secondTableView.frame.origin.x += self.view.bounds.width
            }, completion: { _ in
                self.activeTableView = self.tableView
                self.preferredContentSize = CGSize(width: 0, height: self.tableView.contentSize.height + 36)
            })
            deselectButton(button: rightButton)
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.tableView.frame.origin.x -= self.view.bounds.width
                self.secondTableView.frame.origin.x -= self.view.bounds.width
            }, completion: { _ in
                self.activeTableView = self.secondTableView
                self.preferredContentSize = CGSize(width: 0, height: self.secondTableView.contentSize.height + 36)
            })
            deselectButton(button: leftButton)
        }
        UIView.animate(withDuration: 0.1) {
            sender.transform = .identity
        }
    }
    func selectButton(button: UIButton) {
        UIView.animate(withDuration: 0.1) {
            button.isUserInteractionEnabled = false
            button.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        }
    }
    func deselectButton(button: UIButton) {
        UIView.animate(withDuration: 0.1) {
            button.isUserInteractionEnabled = true
            button.backgroundColor = .clear
        }
    }
    var leftButton: UIButton!
    var rightButton: UIButton!
    var secondTableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        toolbar.frame.size.width = self.view.bounds.width - 16
        leftButton = {
            let button = UIButton(frame: CGRect(x: 8, y: 0, width: (self.toolbar.frame.width - 16 - 8) / 2, height: toolbar.frame.height - 8))
            button.backgroundColor = UIColor.white.withAlphaComponent(0.5)
            button.isHighlighted = true
            button.layer.borderColor = UIColor.white.withAlphaComponent(0.8).cgColor
            button.layer.borderWidth = 2
            button.layer.cornerRadius = button.frame.height / 2
            button.setTitleColor(UIColor.black.withAlphaComponent(0.8), for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            button.setTitle("Сегодня", for: .normal)
            button.addTarget(self, action: #selector(buttonCancel), for: .touchCancel)
            button.addTarget(self, action: #selector(buttonUpInside), for: .touchUpInside)
            button.addTarget(self, action: #selector(buttonDown), for: .touchDown)
            button.isUserInteractionEnabled = false
            return button
        }()
        rightButton = {
            let button = UIButton(frame: CGRect(x: self.leftButton.frame.width + 16, y: 0, width: (toolbar.frame.width - 16 - 8) / 2, height: self.toolbar.frame.height - 8))
            button.layer.borderColor = UIColor.white.withAlphaComponent(0.8).cgColor
            button.isHighlighted = false
            button.layer.borderWidth = 2
            button.layer.cornerRadius = button.frame.height / 2
            button.setTitleColor(UIColor.black.withAlphaComponent(0.8), for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            button.setTitle("Завтра", for: .normal)
            button.addTarget(self, action: #selector(buttonCancel), for: .touchCancel)
            button.addTarget(self, action: #selector(buttonUpInside), for: .touchUpInside)
            button.addTarget(self, action: #selector(buttonDown), for: .touchDown)
            return button
        }()
        toolbar.addSubview(leftButton)
        toolbar.addSubview(rightButton)
        let path = UIBezierPath(roundedRect: toolbar.frame, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        toolbar.layer.mask = maskLayer
        view.addSubview(toolbar)
        ScheduleStorage().setExludedFromBackup()
        if #available(iOS 10, *) {
            extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        }
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.frame.origin.y += 36
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        reloadableViewLayoutAdapter = ScheduleReloadableLayoutAdapter(reloadableView: tableView)
        tableView.dataSource = reloadableViewLayoutAdapter
        tableView.delegate = reloadableViewLayoutAdapter
        secondTableView = UITableView(frame: view.bounds, style: .plain)
        secondTableView.frame.origin.y += 36
        secondTableView.frame.origin.x += view.bounds.width - 16
        secondTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        secondReloadableViewLayoutAdapter = SecondScheduleReloadableLayoutAdapter(reloadableView: secondTableView)
        secondTableView.dataSource = secondReloadableViewLayoutAdapter
        secondTableView.delegate = secondReloadableViewLayoutAdapter
        activeTableView = tableView
        view.addSubview(tableView)
        view.addSubview(secondTableView)
        var id = defaults?.integer(forKey: "user_group_id")
        var type = defaults?.string(forKey: "role")
        if type == "student" || type == "parent" {
            type = "group"
        }
        if type == "teacher" {
            id = defaults?.integer(forKey: "user_id")
        }
        do {
            let data = try ScheduleStorage().storage?.object(forKey: "schedulenow")
            let decoded = try JSONDecoder().decode(JSONDecoding.StudentScheduleApi.self, from: data!)
            self.reloadTableView(width: self.view.bounds.width, synchronous: false, data: decoded, type: type!)
            downloadJSON(type: type!, id: id!, cache: decoded)
        } catch {
            downloadJSON(type: type!, id: id!, cache: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        var day = Calendar.current.component(.weekday, from: Date())
        day -= 2
        if day == -1 {
            let data = JSONDecoding.StudentScheduleApi.Weekdays(periods: [], weekday: "")
            reloadableViewLayoutAdapter.reloading(width: width, synchronous: synchronous, layoutProvider: {
                return [Section(
                    header: nil,
                    items: self.getNewRows(data: data, type: type) ?? [],
                    footer: nil)]
            })} else {
            reloadableViewLayoutAdapter.reloading(width: width, synchronous: synchronous, layoutProvider: {
                return [Section(
                    header: nil,
                    items: self.getNewRows(data: data.weekdays[day], type: type) ?? [],
                    footer: nil)]
            })
        }
        var tommorow = Calendar.current.component(.weekday, from: Date())
        tommorow -= 1
        if tommorow == 6 {
            let data = JSONDecoding.StudentScheduleApi.Weekdays(periods: [], weekday: "")
            secondReloadableViewLayoutAdapter.reloading(width: width, synchronous: synchronous, layoutProvider: {
                return [Section(
                    header: nil,
                    items: self.getNewRows(data: data, type: type) ?? [],
                    footer: nil)]
            })} else {
            secondReloadableViewLayoutAdapter.reloading(width: width, synchronous: synchronous, layoutProvider: {
                return [Section(
                    header: nil,
                    items: self.getNewRows(data: data.weekdays[tommorow], type: type) ?? [],
                    footer: nil)]
            })
        }
    }
    func downloadJSON(type: String, id: Int, cache: JSONDecoding.StudentScheduleApi?) {
        let params: Parameters = [
            "app_key": "c78bf5636f9cf36763b511184c572e8f9341cb07",
            "type": type,
            "id": id,
            "week": "now"
        ]
        Alamofire.request("https://ifspo.ifmo.ru/api/schedule", method: .get, parameters: params).responseJSON { (response) in
            let result = response.data
            do {
                let res = try JSONDecoder().decode(JSONDecoding.StudentScheduleApi.self, from: result!)
                if let safeCache = cache {
                    if safeCache != res {
                        ScheduleStorage().clearDisk(forKey: "schedulenow")
                        ScheduleStorage().updateDisk(with: result!, forKey: "schedulenow")
                        self.reloadTableView(width: self.view.bounds.width, synchronous: false, data: res, type: type)
                    }
                } else {
                    ScheduleStorage().updateDisk(with: result!, forKey: "schedulenow")
                    self.reloadTableView(width: self.view.bounds.width, synchronous: false, data: res, type: type)
                }
            } catch {
                print(error)
            }
        }
    }
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: activeTableView.contentSize.height + 36) : maxSize
    }
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        preferredContentSize = CGSize(width: view.bounds.width, height: activeTableView.contentSize.height + 36)
        completionHandler(NCUpdateResult.newData)
    }
}
class ScheduleReloadableLayoutAdapter: ReloadableViewLayoutAdapter {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return currentArrangement[indexPath.section].items[indexPath.row].frame.height
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
}
class SecondScheduleReloadableLayoutAdapter: ReloadableViewLayoutAdapter {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return currentArrangement[indexPath.section].items[indexPath.row].frame.height
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
}
