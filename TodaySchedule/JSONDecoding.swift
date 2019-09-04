//
//  JSONDecoding.swift
//  TodaySchedule
//
//  Created by Николай Борисов on 10/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

public class JSONDecoding {
    public struct StudentScheduleApi: Decodable, Equatable {
        let week: String?
        let weekdays: [Weekdays]
        public struct Weekdays: Decodable, Equatable {
            let periods: [Periods]
            let weekday: String
            public struct Periods: Decodable, Equatable {
                let schedule: [Schedule]
                let period: Int
                let period_start: String
                let period_end: String
                public struct Schedule: Decodable, Equatable {
                    let name: String
                    let lastname: String
                    let middlename: String
                    let firstname: String
                    let place: String
                    let even: String?
                    let odd: String?
                    let group_part: Int
                    let group_name: String
                }
            }
        }
    }
    public struct ISUResponse: Codable {
        let week_number: Int
        let schedule: [ISUSchedule]
    }
    public struct ISUSchedule: Codable {
        let time1: String
        let time2: String
        let day_week: String
        let week_type: String
        let room: String
        let place: String
        let title: String
        let status: String
        let status_color: String
        let note: String
        let pid: Int
        let person: String
        let bld_id: String
    }
}
