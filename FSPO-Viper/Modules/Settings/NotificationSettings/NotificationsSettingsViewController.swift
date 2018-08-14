//
//  NotificationSettingsViewController.swift
//  TommorowSchedule
//
//  Created by Николай Борисов on 13/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import AVFoundation

class NotificationSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView = UITableView()
    var audioPlayer = AVAudioPlayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Настройки уведомлений", comment: "")
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.frame.size.height = Constants.safeHeight
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 7
        }
        if section == 2 {
            return 2
        }
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let titles = [NSLocalizedString("Типы уведомлений", comment: ""), NSLocalizedString("Уведомление о занятии за", comment: ""), NSLocalizedString("Звук уведомления", comment: "")]
        return titles[section]
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var title = ""
        if section == 1 {
            title = NSLocalizedString("до занятия", comment: "")
        }
        return title
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        if indexPath.section == 0 {
            cell.textLabel?.isEnabled = false
            cell.textLabel?.text = NSLocalizedString("О предстоящих занятиях", comment: "")
            cell.accessoryType = .checkmark
            cell.selectionStyle = .none
        }
        if indexPath.section == 1 {
            cell.textLabel?.text = "\(indexPath.row) \(NSLocalizedString("минут", comment: ""))"
            if indexPath.row == 6 {
                cell.textLabel?.text = "10 \(NSLocalizedString("минут", comment: ""))"
            }
        }
        if indexPath.section == 2 {
            cell.textLabel?.text = NSLocalizedString("Стандартный", comment: "")
            if indexPath.row == 0 {
                cell.textLabel?.text = NSLocalizedString("Кастомный", comment: "")
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            var row = UserDefaults.standard.integer(forKey: "notificationsDelay")
            if row == 10 {
                row = 6
            }
            tableView.cellForRow(at: IndexPath(row: row, section: 1))?.accessoryType = .none
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            if indexPath.row == 6 {
                UserDefaults.standard.set(10, forKey: "notificationsDelay")
            } else {
                UserDefaults.standard.set(indexPath.row, forKey: "notificationsDelay")
            }
            updateNotificationContext()
        }
        if indexPath.section == 2 {
            if indexPath.row == 1 {
                AudioServicesPlaySystemSound(1315)
            } else {
                do {
                 audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "notify", ofType: "caf")!))
                 audioPlayer.play()
                 } catch {
                    print(error)
                 }
            }
            tableView.cellForRow(at: IndexPath(row: UserDefaults.standard.integer(forKey: "notificationSound"), section: 2))?.accessoryType = .none
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            UserDefaults.standard.set(indexPath.row, forKey: "notificationSound")
            updateNotificationContext()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == UserDefaults.standard.integer(forKey: "notificationsDelay") {
                cell.accessoryType = .checkmark
            } else if UserDefaults.standard.integer(forKey: "notificationsDelay") == 10 {
                if indexPath.row == 6 {
                    cell.accessoryType = .checkmark
                }
            }
        }
        if indexPath.section == 2 {
            if indexPath.row == UserDefaults.standard.integer(forKey: "notificationSound") {
                cell.accessoryType = .checkmark
            }
        }
    }
}
