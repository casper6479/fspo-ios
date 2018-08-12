//
//  SettingsViewController.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 26/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import FPSCounter

class SettingsViewController: UIViewController, SettingsViewProtocol, UITableViewDelegate, UITableViewDataSource {

	var presenter: SettingsPresenterProtocol?
    var tableView = UITableView()
	override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        if indexPath.row == 0 {
            cell.textLabel?.text = "fps"
        }
        if indexPath.row == 1 {
            cell.textLabel?.text = "touchid"
        }
        if indexPath.row == 2 {
            cell.textLabel?.text = "cache"
        }
        if indexPath.row == 3 {
            cell.textLabel?.text = NSLocalizedString("Выход", comment: "")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            FPSCounter.showInStatusBar(UIApplication.shared)
        }
        if indexPath.row == 1 {
            if UserDefaults.standard.bool(forKey: "biometricDisabled") {
                UserDefaults.standard.set(false, forKey: "biometricDisabled")
            } else {
                UserDefaults.standard.set(true, forKey: "biometricDisabled")
            }
        }
        if indexPath.row == 2 {
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
            group.notify(queue: DispatchQueue.main) {
                DispatchQueue.main.async {
                    showMessage(message: "Кэш очищен", y: 8)
                }
            }
        }
        if indexPath.row == 3 {
            keychain["token"] = nil
            UserDefaults.standard.set(0, forKey: "user_id")
            self.present(UINavigationController.init(rootViewController: LoginRouter.createModule()), animated: true)
        }
    }
}
