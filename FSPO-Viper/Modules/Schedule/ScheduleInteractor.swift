//
//  ScheduleInteractor.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import Alamofire

class ScheduleInteractor: ScheduleInteractorProtocol {
    weak var presenter: SchedulePresenterProtocol?
    func fetchTeachers(cache: JSONDecoding.GetTeachersApi?) {
        let parameters: Parameters = [
            "app_key": Constants.AppKey
            ]
        let jsonParams = parameters.jsonStringRepresentaiton ?? ""
        let params = [
            "jsondata": jsonParams
        ]
        Alamofire.request(Constants.TeachersURL, method: .get, parameters: params).responseJSON { (response) in
            let result = response.data
            do {
                let res = try JSONDecoder().decode(JSONDecoding.GetTeachersApi.self, from: result!)
                if let safeCache = cache {
                    if safeCache != res {
                        clearCache(forKey: "teachers")
                        updateCache(with: result!, forKey: "teachers", expiry: .never)
                        self.presenter?.teachersFetched(data: res)
                    }
                } else {
                    updateCache(with: result!, forKey: "teachers", expiry: .never)
                    self.presenter?.teachersFetched(data: res)
                }
            } catch {
                print(error)
            }
        }
    }
    func fetchScheduleByGroups(cache: JSONDecoding.GetGroupsApi?) {
        let parameters: Parameters = [
            "app_key": Constants.AppKey
            ]
        let jsonParams = parameters.jsonStringRepresentaiton ?? ""
        let params = [
            "jsondata": jsonParams
        ]
        Alamofire.request(Constants.GroupsURL, method: .get, parameters: params).responseJSON { (response) in
            let result = response.data
            do {
                let res = try JSONDecoder().decode(JSONDecoding.GetGroupsApi.self, from: result!)
                if let safeCache = cache {
                    if safeCache != res {
                        clearCache(forKey: "groups")
                        updateCache(with: result!, forKey: "groups", expiry: .never)
                        self.presenter?.scheduleByGroupsFetched(data: res)
                    }
                } else {
                    updateCache(with: result!, forKey: "groups", expiry: .never)
                    self.presenter?.scheduleByGroupsFetched(data: res)
                }
            } catch {
                print(error)
            }
        }
    }
    func fetchStudentSchedule(week: String, cache: JSONDecoding.StudentScheduleApi?) {
        let userGroupName = UserDefaults.standard.string(forKey: "user_group_name")
        //TODO: Если нет имени группы то что делать
        print("isu api", RemoteCfg.isISUApi)
        if RemoteCfg.isISUApi {
            let params: Parameters = [
                "gr": userGroupName ?? "",
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
                    ScheduleStorage().clearDisk(forKey: "schedule\(week)")
                    ScheduleStorage().updateDisk(with: response.data!, forKey: "schedule\(week)")
                    self.presenter?.studentScheduleFetched(data: data)
                } catch {
                    print(error)
                }
            }
        } else {
            let userGroupId = UserDefaults.standard.integer(forKey: "user_group_id")
            let userID = UserDefaults.standard.integer(forKey: "user_id")
            let id = UserDefaults.standard.string(forKey: "role") == "teacher" ? userID : userGroupId
            let type = UserDefaults.standard.string(forKey: "role") == "teacher" ? "teacher" : "group"
            let parameters: Parameters = [
                "app_key": Constants.AppKey,
                "type": type,
                "id": id,
                "week": week
            ]
            let jsonParams = parameters.jsonStringRepresentaiton ?? ""
            let params = [
                "jsondata": jsonParams
            ]
            Alamofire.request(Constants.ScheduleURL, method: .get, parameters: params).responseJSON { (response) in
                let result = response.data
                do {
                    let res = try JSONDecoder().decode(JSONDecoding.StudentScheduleApi.self, from: result!)
                    if let safeCache = cache {
                        if safeCache != res {
                            print("cache is deprecated")
                            ScheduleStorage().clearDisk(forKey: "schedule\(week)")
                            ScheduleStorage().updateDisk(with: result!, forKey: "schedule\(week)")
                            self.presenter?.studentScheduleFetched(data: res)
                        } else {
                            print("found in cache")
                        }
                    } else {
                        print("cache is empty")
                        ScheduleStorage().updateDisk(with: result!, forKey: "schedule\(week)")
                        self.presenter?.studentScheduleFetched(data: res)
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}
