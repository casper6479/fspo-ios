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
public func updateNothificationContext() {
    var params: Parameters = ["app_key": Constants.AppKey]
    if UserDefaults.standard.string(forKey: "user_group_id") != nil {
        params = [
            "app_key": Constants.AppKey,
            "type": "group",
            "id": UserDefaults.standard.string(forKey: "user_group_id")!,
            "week": "now"
        ]
    }
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
                        center.getNotificationSettings { (settings) in
                            if settings.authorizationStatus != .authorized {
                                print("Nothification is not Allowed")
                            }
                        }
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
                        //                            content.sound = UNNotificationSound.init(named: "burp.mp3")
                        //                        } else {
                        let sounds = [UNNotificationSound.default(), UNNotificationSound.init(named: "notify.caf"), UNNotificationSound.init(named: "vkadmin.mp3"), UNNotificationSound.init(named: "waterdrop.mp3"), UNNotificationSound.init(named: "line_notif_ios.mp3")]
                        content.sound = .default()
                        //                        }
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
            //            UserDefaults.standard.set(try? PropertyListEncoder().encode(res.weekdays), forKey:"MyScheduleCache")
        } catch {
            showMessage(message: NSLocalizedString("Ошибка при обновлении уведомлений", comment: ""), y: 8)
        }
    }
}
