//
//  JSONDecoding.swift
//  TodaySchedule
//
//  Created by Николай Борисов on 10/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

public class JSONDecoding {
    public struct StudentScheduleApi: Decodable {
        let week: String?
        let weekdays: [Weekdays]
        public struct Weekdays: Decodable {
            let periods: [Periods]
            let weekday: String
            public struct Periods: Decodable {
                let schedule: [Schedule]
                let period: Int
                let period_start: String
                let period_end: String
                public struct Schedule: Decodable {
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
}
