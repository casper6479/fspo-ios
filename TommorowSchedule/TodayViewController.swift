//
//  TodayViewController.swift
//  TommorowSchedule
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
    var tableView: UITableView!
    var defaults = UserDefaults(suiteName: "group.com.casper6479.fspo")
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10, *) {
            extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        }
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        reloadableViewLayoutAdapter = ScheduleReloadableLayoutAdapter(reloadableView: tableView)
        tableView.dataSource = reloadableViewLayoutAdapter
        tableView.delegate = reloadableViewLayoutAdapter
        view.addSubview(tableView)
        let id = defaults?.integer(forKey: "user_group_id")
        var type = defaults?.string(forKey: "role")
        if type == "student" || type == "parent" {
            type = "group"
        }
        downloadJSON(type: type!, id: id!)
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
        day -= 1
        if day == 6 {
            let data = JSONDecoding.StudentScheduleApi.Weekdays(periods: [], weekday: "")
            reloadableViewLayoutAdapter.reloading(width: width, synchronous: synchronous, layoutProvider: {
                return [Section(
                    header: nil,
                    items: self.getNewRows(data: data, type: type) ?? [],
                    footer: nil)]
            })
        } else {
            reloadableViewLayoutAdapter.reloading(width: width, synchronous: synchronous, layoutProvider: {
                return [Section(
                    header: nil,
                    items: self.getNewRows(data: data.weekdays[day], type: type) ?? [],
                    footer: nil)]
            })
        }
    }
    func downloadJSON(type: String, id: Int) {
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
                self.reloadTableView(width: self.view.bounds.width, synchronous: false, data: res, type: type)
            } catch {
                print(error)
            }
        }
    }
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: tableView.contentSize.height) : maxSize
    }
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        completionHandler(NCUpdateResult.newData)
    }
}
class ScheduleReloadableLayoutAdapter: ReloadableViewLayoutAdapter {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
}
