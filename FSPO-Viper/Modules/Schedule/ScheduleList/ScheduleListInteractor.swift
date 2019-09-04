//
//  ScheduleListInteractor.swift
//  FSPO
//
//  Created Николай Борисов on 09/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import Alamofire

class ScheduleListInteractor: ScheduleListInteractorProtocol {
    var id: Int?
    var type: String?
    var name: String
    init(id: Int, type: String, name: String) {
        self.id = id
        self.type = type
        self.name = name
    }
    weak var presenter: ScheduleListPresenterProtocol?

    func fetchSchedule(week: String, cache: JSONDecoding.StudentScheduleApi?) {
        if RemoteCfg.isISUApi {
            let params: Parameters = [
                "gr": name,
                "login": RemoteCfg.ISULogin,
                "pass": RemoteCfg.ISUPassword,
                "module": RemoteCfg.ISUModule
            ]
            print(params)
            Alamofire.request(Constants.ISUScheduleURL, method: .post, parameters: params).response { (response) in
                
                do {
                    let res = try JSONDecoder().decode([JSONDecoding.ISUResponse].self, from: response.data!)
                    var weekdays = [JSONDecoding.StudentScheduleApi.Weekdays]()
                    let grouped = Dictionary(grouping: res[0].schedule, by: { $0.day_week })
                    let nowWeekType = res[0].week_number % 2 == 0 ? "2" : "1"
                    for weekday in 0...5 {
                        if let lessons = grouped[String(weekday)] {
                            var periods = [JSONDecoding.StudentScheduleApi.Weekdays.Periods]()
                            for lesson in lessons {
                                let prepodName = lesson.person == "" ? "Не указано" : lesson.person
                                let room = lesson.place == "Вяземский пер., д.5-7, лит.А" ? "С" : lesson.room
                                let schedule = JSONDecoding.StudentScheduleApi.Weekdays.Periods.Schedule(name: lesson.title, lastname: prepodName, middlename: "", firstname: "", place: room, even: lesson.week_type == "1" ? "" : nil, odd: lesson.week_type == "2" ? "" : nil, group_part: 0, group_name: "Y2235")
                                let period = JSONDecoding.StudentScheduleApi.Weekdays.Periods(schedule: [schedule], period: 0, period_start: lesson.time1, period_end: lesson.time2)
                                if week == "now" {
                                    if nowWeekType == "1" && lesson.week_type != "2" {
                                        periods.append(period)
                                    } else if nowWeekType == "2" && lesson.week_type != "1" {
                                        periods.append(period)
                                    }
                                } else if week == "next" {
                                    if nowWeekType == "1" && lesson.week_type != "1" {
                                        periods.append(period)
                                    } else if nowWeekType == "2" && lesson.week_type != "2" {
                                        periods.append(period)
                                    }
                                } else {
                                    periods.append(period)
                                }
                            }
                            let wd = JSONDecoding.StudentScheduleApi.Weekdays.init(periods: periods, weekday: String(weekday))
                            weekdays.append(wd)
                        } else {
                            let wd = JSONDecoding.StudentScheduleApi.Weekdays.init(periods: [], weekday: String(weekday))
                            weekdays.append(wd)
                        }
                    }
                    let data = JSONDecoding.StudentScheduleApi(week: res[0].week_number % 2 == 0 ? "odd" : "even", weekdays: weekdays)
                    
//                    self.presenter?.studentScheduleFetched(data: data)
                    if let safeCache = cache {
                        if safeCache != data {
                            clearCache(forKey: "\(self.type!)\(self.name)\(week)")
                            updateCache(with: response.data!, forKey: "\(self.type!)\(self.name)\(week)", expiry: .never)
                            self.presenter?.scheduleFetched(data: data, type: self.type!)
                        }
                    } else {
                        updateCache(with: response.data!, forKey: "\(self.type!)\(self.name)\(week)", expiry: .never)
                        self.presenter?.scheduleFetched(data: data, type: self.type!)
                    }
                } catch {
                    print(error)
                }
            }
        } else {
            let parameters: Parameters = [
                "app_key": Constants.AppKey,
                "type": type!,
                "id": id!,
                "week": week
            ]
            let jsonParams = parameters.jsonStringRepresentaiton ?? ""
            let params = [
                "jsondata": jsonParams
            ]
            Alamofire.request("https://ifspo.ifmo.ru/api/schedule", method: .get, parameters: params).responseJSON { (response) in
                let result = response.data
                do {
                    let res = try JSONDecoder().decode(JSONDecoding.StudentScheduleApi.self, from: result!)
                    if let safeCache = cache {
                        if safeCache != res {
                            clearCache(forKey: "\(self.type!)\(self.id!)\(week)")
                            updateCache(with: result!, forKey: "\(self.type!)\(self.id!)\(week)", expiry: .never)
                            self.presenter?.scheduleFetched(data: res, type: self.type!)
                        }
                    } else {
                        updateCache(with: result!, forKey: "\(self.type!)\(self.id!)\(week)", expiry: .never)
                        self.presenter?.scheduleFetched(data: res, type: self.type!)
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}
