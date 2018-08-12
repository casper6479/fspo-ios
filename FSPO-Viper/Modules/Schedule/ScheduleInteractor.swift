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
        let params: Parameters = [
            "app_key": Constants.AppKey
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
        let params: Parameters = [
            "app_key": Constants.AppKey
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
        let groupId = UserDefaults.standard.integer(forKey: "user_group_id")
        let params: Parameters = [
            "app_key": Constants.AppKey,
            "type": "group",
            "id": groupId,
            "week": week
        ]
        Alamofire.request(Constants.ScheduleURL, method: .get, parameters: params).responseJSON { (response) in
            let result = response.data
            do {
                let res = try JSONDecoder().decode(JSONDecoding.StudentScheduleApi.self, from: result!)
                if let safeCache = cache {
                    if safeCache != res {
                        print("cache is deprecated")
                        ScheduleStorage().clearDisk(forKey: "schedule")
                        ScheduleStorage().updateDisk(with: result!, forKey: "schedule", expiry: .never)
                        self.presenter?.studentScheduleFetched(data: res)
                    } else {
                        print("found in cache")
                    }
                } else {
                    print("cache is empty")
                    ScheduleStorage().updateDisk(with: result!, forKey: "schedule", expiry: .never)
                    self.presenter?.studentScheduleFetched(data: res)
                }
            } catch {
                print(error)
            }
        }
    }
}
