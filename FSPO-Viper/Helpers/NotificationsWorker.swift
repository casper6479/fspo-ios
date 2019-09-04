//
//  NotificationsWorker.swift
//  FSPO
//
//  Created by Николай Борисов on 10/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//
import Alamofire
import UserNotifications
// swiftlint:disable:next cyclomatic_complexity
public func updateNotificationContext() {
    let userGroupId = UserDefaults.standard.integer(forKey: "user_group_id")
    let userID = UserDefaults.standard.integer(forKey: "user_id")
    let id = UserDefaults.standard.string(forKey: "role") == "teacher" ? userID : userGroupId
    let type = UserDefaults.standard.string(forKey: "role") == "teacher" ? "teacher" : "group"
    let parameters: Parameters = [
        "app_key": Constants.AppKey,
        "type": type,
        "id": id,
        "week": "now"
    ]
    let jsonParams = parameters.jsonStringRepresentaiton ?? ""
    let params = [
        "jsondata": jsonParams
    ]
    Alamofire.request(Constants.ScheduleURL, method: .get, parameters: params).responseJSON { (response) in
        let result = response.data
        do {
            let res = try JSONDecoder().decode(JSONDecoding.StudentScheduleApi.self, from: result!)
            var wd = 0
            if #available(iOS 10.0, *) {
                let center = UNUserNotificationCenter.current()
                center.removeAllPendingNotificationRequests()
            }
            var id = 0
            for i in res.weekdays {
                for u in i.periods {
                    if #available(iOS 10.0, *) {
                        let center = UNUserNotificationCenter.current()
                        let dateFormatter = DateFormatter()
                        let days = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                        dateFormatter.isLenient = true
                        dateFormatter.dateFormat = "EEE:HH:mm"
                        let content = UNMutableNotificationContent()
                        var group_part = ""
                        if u.schedule[0].group_part == 0 {
                            group_part = ""
                        } else if u.schedule[0].group_part == 1 {
                            group_part = " у 1-й подгруппы"
                        } else if u.schedule[0].group_part == 2 {
                            group_part = " у 2-й подгруппы"
                        }
                        content.title = "Начало пары\(group_part)"
                        var place = ""
                        if u.schedule[0].place == "Спортзал" {
                            place = "в Спортзале"
                        } else if u.schedule[0].place == "Ушинского" {
                            place = "на Ушинского"
                        } else if u.schedule[0].place == "Ломоносова" {
                            place = "на Ломоносова"
                        } else {
                            place = "в \(u.schedule[0].place)"
                        }
                        content.body = "\(u.schedule[0].name) \(place)"
                        //                        if UserDefaults.standard.string(forKey: "user_id") == "1000369" {
                        let sounds: [UNNotificationSound] = [UNNotificationSound(named: convertToUNNotificationSoundName("notify.caf")), .default]
                        content.sound = sounds[UserDefaults.standard.integer(forKey: "notificationSound")]
                        let datestring = "\(days[wd]):\(u.period_start)"
                        let date = dateFormatter.date(from: datestring)
                        if date != nil {
                            let time = Calendar.current.date(byAdding: .minute, value: -UserDefaults.standard.integer(forKey: "notificationsDelay"), to: date!)
                            let triggerDate = Calendar.current.dateComponents([.weekday, .hour, .minute], from: time!)
                            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
                            let request = UNNotificationRequest(identifier: String(id), content: content, trigger: trigger)
                            center.add(request, withCompletionHandler: { (error) in
                                if let error = error {
                                    print(error)
                                }
                            })
                        }
                    } else {
                        /*let notification = UILocalNotification()
                         let dateFormatter = DateFormatter()
                         let days = ["MON","TUE","WED","THU","FRI","SAT","SUN"]
                         dateFormatter.dateFormat = "EEE:HH:mm"
                         let datestring = "\(days[wd]):\(u.period_start)"
                         let date = dateFormatter.date(from: datestring)
                         notification.fireDate = date
                         notification.alertBody = "Body"
                         notification.alertAction = "Azction"
                         notification.soundName = UILocalNotificationDefaultSoundName
                         UIApplication.shared.scheduleLocalNotification(notification)*/
                    }
                    id += 1
                }
                wd += 1
            }
//            showMessage(message: NSLocalizedString("Уведомления обновлены", comment: ""), y: 8)
        } catch {
            print(error)
            if Connectivity.isConnectedToInternet() {
                showMessage(message: "\(NSLocalizedString("Ошибка при обновлении уведомлений", comment: "")): \n\(error.localizedDescription)", y: 8)
            } else {
                showMessage(message: "\(NSLocalizedString("Ошибка при обновлении уведомлений", comment: "")): \n\(NSLocalizedString("Нет соединения с интернетом", comment: ""))", y: 8)
            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertToUNNotificationSoundName(_ input: String) -> UNNotificationSoundName {
	return UNNotificationSoundName(rawValue: input)
}
