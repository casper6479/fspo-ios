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
        self.title = "Настройки"
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
        let sectiontitles = ["Начальный экран", "Расписание", "Уведомления", "Аутентификация", "Кэш", "Связь с разработчиком", ""]
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
                cell.textLabel!.text = "Новости"
            } else if indexPath.row == 1 {
                cell.textLabel!.text = "Журнал"
            } else if indexPath.row == 2 {
                cell.textLabel!.text = "Сообщения"
            } else if indexPath.row == 3 {
                cell.textLabel!.text = "Расписание"
            } else if indexPath.row == 4 {
                cell.textLabel!.text = "Профиль"
            }
            if indexPath.row == UserDefaults.standard.integer(forKey: "firstScreen") {
                cell.accessoryType = .checkmark
            }
        }
        if indexPath.section == 1 {
            cell.textLabel!.text = "Прокрутка к сегодняшнему дню"
            if !UserDefaults.standard.bool(forKey: "spring") {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        if indexPath.section == 2 {
            if indexPath.row == 1 {
                cell.textLabel!.text = "Очистить расписание уведомлений"
                cell.textLabel!.textColor = UIColor(red: 25/255, green: 70/255, blue: 186/255, alpha: 1.0)
                cell.textLabel!.textAlignment = .center
            } else {
                cell.textLabel!.text = "Настройки уведомлений"
                cell.textLabel!.textColor = .black
                cell.accessoryType = .disclosureIndicator
            }
        }
        if indexPath.section == 3 {
            cell.textLabel!.text = "Подтверждение личности"
            cell.textLabel!.textColor = .black
            if UserDefaults.standard.bool(forKey: "biometricEnabled") {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        if indexPath.section == 4 {
            cell.textLabel!.text = "Очистить кэш"
            cell.textLabel!.textColor = UIColor(red: 25/255, green: 70/255, blue: 186/255, alpha: 1.0)
            cell.textLabel!.textAlignment = .center
        }
        if indexPath.section == 5 {
            cell.textLabel!.text = "Группа VK"
            cell.textLabel!.textColor = UIColor(red: 25/255, green: 70/255, blue: 186/255, alpha: 1.0)
            cell.textLabel!.textAlignment = .center
        }
        if indexPath.section == 6 {
            cell.textLabel!.text = "Выход"
            cell.textLabel!.textColor = UIColor(red: 236/255, green: 11/255, blue: 67/255, alpha: 1.0)
            cell.textLabel!.textAlignment = .center
        }
        return cell
    }
    // swiftlint:disable:next cyclomatic_complexity
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "")
        let viewForPopOver = tableView.cellForRow(at: indexPath)
        let rectForPopOver = cell?.bounds
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
                let alert = UIAlertController(title: "Очистить расписание?", message: nil, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Очистить", comment: ""), style: .destructive, handler: { _ in
                    if #available(iOS 10, *) {
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    }
                    showMessage(message: "Расписание уведомлений очищено", y: 8)
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
            let alert = UIAlertController(title: "Очистить кэш?", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Очистить", comment: "Выйти"), style: .destructive, handler: { _ in
                let group = DispatchGroup()
                group.enter()
                storage?.async.removeAll(completion: { result in
                    switch result {
                    case .value:
                        group.leave()
                    case .error(let error):
                        DispatchQueue.main.async {
                            showMessage(message: "Ошибка очистки: \(error)", y: 8)
                        }
                    }
                })
                group.enter()
                do {
                    try ScheduleStorage().storage?.removeAll()
                    group.leave()
                } catch {
                    DispatchQueue.main.async {
                        showMessage(message: "Ошибка очистки: \(error)", y: 8)
                    }
                }
                ImageCache.default.clearDiskCache()
                ImageCache.default.clearMemoryCache()
                group.notify(queue: DispatchQueue.main) {
                    DispatchQueue.main.async {
                        showMessage(message: "Кэш очищен", y: 8)
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Отмена", comment: "Отмена"), style: .cancel, handler: nil))
            alert.popoverPresentationController?.sourceView = viewForPopOver
            alert.popoverPresentationController?.sourceRect = rectForPopOver!
            self.present(alert, animated: true, completion: nil)
        } else if indexPath.section == 5 {
            let path = "vk://vk.com/fspoapp"
            let url = URL(string: path)!
            if #available(iOS 10, *) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    let safariurl = URL(string: "https://vk.com/fspoapp")!
                    UIApplication.shared.open(safariurl, options: [:], completionHandler: nil)
                }
            } else {
                let safariurl = URL(string: "https://vk.com/fspoapp")!
                UIApplication.shared.openURL(safariurl)
            }
        } else if indexPath.section == 6 {
            let alert = UIAlertController(title: "Точно выйти?", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Выйти", comment: "Выйти"), style: .destructive, handler: { _ in
                keychain["token"] = nil
                UserDefaults.standard.set(0, forKey: "user_id")
                UserDefaults.standard.set(false, forKey: "spring")
                UserDefaults.standard.set(0, forKey: "notificationSound")
                self.present(UINavigationController.init(rootViewController: LoginRouter.createModule()), animated: true)
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Отмена", comment: "Отмена"), style: .cancel, handler: nil))
            alert.popoverPresentationController?.sourceView = viewForPopOver
            alert.popoverPresentationController?.sourceRect = rectForPopOver!
            self.present(alert, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var footer = ""
        if section == 3 {
            let authContex = LAContext()
            var authError: NSError?
            if !authContex.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
                footer = "Не поддерживается на Вашем устройстве"
            }
        } else if section == 5 {
            footer = "Разработчик: Борисов Николай"
        } else if section == 6 {
            let bundleShortVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
            footer = "Версия \(bundleShortVersion!)"
        }
        return footer
    }
}
