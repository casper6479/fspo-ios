//
//  SettingsViewController.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 26/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import UserNotifications
import Kingfisher
import LocalAuthentication
class SettingsViewController: UIViewController, SettingsViewProtocol, UITableViewDelegate, UITableViewDataSource {

	var presenter: SettingsPresenterProtocol?
    var tableView = UITableView()
	override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Настройки", comment: "")
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.frame.size.height = Constants.safeHeight
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowcount = [5, 1, 2, 1, 1, 1, 1]
        return rowcount[section]
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectiontitles = [NSLocalizedString("Начальный экран", comment: ""), NSLocalizedString("Расписание", comment: ""), NSLocalizedString("Уведомления", comment: ""), NSLocalizedString("Аутентификация", comment: ""), NSLocalizedString("Кэш", comment: ""), NSLocalizedString("Связь с разработчиком", comment: ""), ""]
        return sectiontitles[section]
    }
    // swiftlint:disable:next cyclomatic_complexity
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.accessoryType = .none
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.textColor = UIColor.black
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.textLabel!.text = NSLocalizedString("Новости", comment: "")
            } else if indexPath.row == 1 {
                cell.textLabel!.text = NSLocalizedString("Журнал", comment: "")
            } else if indexPath.row == 2 {
                cell.textLabel!.text = NSLocalizedString("Сообщения", comment: "")
            } else if indexPath.row == 3 {
                cell.textLabel!.text = NSLocalizedString("Расписание", comment: "")
            } else if indexPath.row == 4 {
                cell.textLabel!.text = NSLocalizedString("Профиль", comment: "")
            }
            if indexPath.row == UserDefaults.standard.integer(forKey: "firstScreen") {
                cell.accessoryType = .checkmark
            }
        }
        if indexPath.section == 1 {
            cell.textLabel!.text = NSLocalizedString("Прокрутка к сегодняшнему дню", comment: "")
            if !UserDefaults.standard.bool(forKey: "spring") {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        if indexPath.section == 2 {
            if indexPath.row == 1 {
                cell.textLabel!.text = NSLocalizedString("Очистить расписание уведомлений", comment: "")
                if UserDefaults.standard.string(forKey: "role") == "parent" {
                    cell.isUserInteractionEnabled = false
                    cell.textLabel!.isEnabled = false
                }
                cell.textLabel!.textColor = UIColor(red: 25/255, green: 70/255, blue: 186/255, alpha: 1.0)
                cell.textLabel!.textAlignment = .center
            } else {
                cell.textLabel!.text = NSLocalizedString("Настройки уведомлений", comment: "")
                if UserDefaults.standard.string(forKey: "role") == "parent" {
                    cell.isUserInteractionEnabled = false
                    cell.textLabel!.isEnabled = false
                }
                cell.textLabel!.textColor = .black
                cell.accessoryType = .disclosureIndicator
            }
        }
        if indexPath.section == 3 {
            cell.textLabel!.text = NSLocalizedString("Подтверждение личности", comment: "")
            cell.textLabel!.textColor = .black
            if UserDefaults.standard.bool(forKey: "biometricEnabled") {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        if indexPath.section == 4 {
            cell.textLabel!.text = NSLocalizedString("Очистить кэш", comment: "")
            cell.textLabel!.textColor = UIColor(red: 25/255, green: 70/255, blue: 186/255, alpha: 1.0)
            cell.textLabel!.textAlignment = .center
        }
        if indexPath.section == 5 {
            cell.textLabel!.text = NSLocalizedString("Группа VK", comment: "")
            cell.textLabel!.textColor = UIColor(red: 25/255, green: 70/255, blue: 186/255, alpha: 1.0)
            cell.textLabel!.textAlignment = .center
        }
        if indexPath.section == 6 {
            cell.textLabel!.text = NSLocalizedString("Выход", comment: "")
            cell.textLabel!.textColor = UIColor(red: 236/255, green: 11/255, blue: 67/255, alpha: 1.0)
            cell.textLabel!.textAlignment = .center
        }
        return cell
    }
    // swiftlint:disable:next cyclomatic_complexity
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewForPopOver = tableView.cellForRow(at: indexPath)
        let rectForPopOver = tableView.cellForRow(at: indexPath)?.bounds
        if indexPath.section == 0 {
            tableView.cellForRow(at: IndexPath(row: UserDefaults.standard.integer(forKey: "firstScreen"), section: 0))?.accessoryType = .none
            UserDefaults.standard.set(indexPath.row, forKey: "firstScreen")
            tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0))?.accessoryType = .checkmark
        } else if indexPath.section == 1 {
            if UserDefaults.standard.bool(forKey: "spring") {
                tableView.cellForRow(at: IndexPath(row: 0, section: 1))?.accessoryType = .checkmark
                UserDefaults.standard.set(false, forKey: "spring")
            } else {
                tableView.cellForRow(at: IndexPath(row: 0, section: 1))?.accessoryType = .none
                UserDefaults.standard.set(true, forKey: "spring")
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 1 {
                let alert = UIAlertController(title: NSLocalizedString("Очистить расписание?", comment: ""), message: nil, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Очистить", comment: ""), style: .destructive, handler: { _ in
                    if #available(iOS 10, *) {
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    }
                    showMessage(message: NSLocalizedString("Расписание уведомлений очищено", comment: ""), y: 8)
                }))
                alert.addAction(UIAlertAction(title: NSLocalizedString("Отмена", comment: ""), style: .cancel, handler: nil))
                alert.popoverPresentationController?.sourceView = viewForPopOver
                alert.popoverPresentationController?.sourceRect = rectForPopOver!
                self.present(alert, animated: true, completion: nil)
            } else {
                let vc = NotificationSettingsViewController()
                navigationController?.show(vc, sender: self)
            }
        } else if indexPath.section == 3 {
            if UserDefaults.standard.bool(forKey: "biometricEnabled") {
                tableView.cellForRow(at: IndexPath(row: 0, section: 3))?.accessoryType = .none
                UserDefaults.standard.set(false, forKey: "biometricEnabled")
            } else {
                tableView.cellForRow(at: IndexPath(row: 0, section: 3))?.accessoryType = .checkmark
                UserDefaults.standard.set(true, forKey: "biometricEnabled")
            }
        } else if indexPath.section == 4 {
            let alert = UIAlertController(title: "\(NSLocalizedString("Очистить кэш", comment: ""))?", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Очистить", comment: ""), style: .destructive, handler: { _ in
                self.clearCache()
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Отмена", comment: ""), style: .cancel, handler: nil))
            alert.popoverPresentationController?.sourceView = viewForPopOver
            alert.popoverPresentationController?.sourceRect = rectForPopOver!
            self.present(alert, animated: true, completion: nil)
        } else if indexPath.section == 5 {
            let path = "vk://vk.com/fspoapp"
            let url = URL(string: path)!
            if #available(iOS 10, *) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                } else {
                    let safariurl = URL(string: "https://vk.com/fspoapp")!
                    UIApplication.shared.open(safariurl, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                }
            } else {
                let safariurl = URL(string: "https://vk.com/fspoapp")!
                UIApplication.shared.openURL(safariurl)
            }
        } else if indexPath.section == 6 {
            let alert = UIAlertController(title: NSLocalizedString("Точно выйти?", comment: ""), message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Выйти", comment: ""), style: .destructive, handler: { _ in
                self.logOut()
                self.present(NavigationController(rootViewController: LoginRouter.createModule()), animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Отмена", comment: ""), style: .cancel, handler: nil))
            alert.popoverPresentationController?.sourceView = viewForPopOver
            alert.popoverPresentationController?.sourceRect = rectForPopOver!
            self.present(alert, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func logOut() {
        keychain["token"] = nil
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
        UserDefaults.standard.set(0, forKey: "user_id")
        UserDefaults.standard.set(false, forKey: "spring")
        UserDefaults.standard.set(0, forKey: "notificationSound")
        UserDefaults.standard.set(false, forKey: "swipeAnimSeen")
        UserDefaults.standard.removeObject(forKey: "user_group_name")
        UserDefaults.standard.removeObject(forKey: "child_user_id")
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var footer = ""
        if section == 3 {
            let authContex = LAContext()
            var authError: NSError?
            if !authContex.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
                footer = NSLocalizedString("Не поддерживается на Вашем устройстве", comment: "")
            }
        } else if section == 5 {
            footer = NSLocalizedString("Разработчик: Борисов Николай", comment: "")
        } else if section == 6 {
            let bundleShortVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
            footer = "\(NSLocalizedString("Версия", comment: "")) \(bundleShortVersion!)"
        }
        return footer
    }
    func clearCache() {
        let group = DispatchGroup()
        group.enter()
        storage?.async.removeAll(completion: { result in
            switch result {
            case .value:
                group.leave()
            case .error(let error):
                DispatchQueue.main.async {
                    showMessage(message: "\(NSLocalizedString("Ошибка очистки", comment: "")): \(error)", y: 8)
                }
            }
        })
        group.enter()
        do {
            try ScheduleStorage().storage?.removeAll()
            group.leave()
        } catch {
            DispatchQueue.main.async {
                showMessage(message: "\(NSLocalizedString("Ошибка очистки", comment: "")): \(error)", y: 8)
            }
        }
        ImageCache.default.clearDiskCache()
        ImageCache.default.clearMemoryCache()
        group.notify(queue: DispatchQueue.main) {
            DispatchQueue.main.async {
                showMessage(message: NSLocalizedString("Кэш очищен", comment: ""), y: 8)
            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
