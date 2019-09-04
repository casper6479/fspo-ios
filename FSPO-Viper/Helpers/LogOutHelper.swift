//
//  LogOutHelper.swift
//  FSPO
//
//  Created by Николай Борисов on 14/09/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import UserNotifications
import Kingfisher

class LogOutHelper {
    func logOut(vc: UIViewController) {
        clearProperties()
        clearCache()
        vc.present(UINavigationController.init(rootViewController: LoginRouter.createModule()), animated: true)
    }
    func clearProperties() {
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
