//
//  JSONDecoding.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation

public class JSONDecoding {
    struct NewsApi: Decodable {
        let news: [News]
        let count_n: Int
        struct News: Decodable {
            let text: String
            let ndatetime: String
        }
    }
    struct AuthApi: Decodable {
        let token: String
        let user_id: Int
    }
    struct ApiError: Decodable {
        let result: String
        let error_code: Int
    }
    struct JournalApi: Decodable {
        let avg_score: Double
        let debts: Int
        let visits: Int
    }
    struct JournalBySubjectsApi: Decodable {
        let lessons: [Lessons]
        struct Lessons: Decodable {
            let lesson_id: String
            let name: String
            let semester: String
        }
    }
    struct MoreApi: Decodable {
        let lessons_now: LessonsNow
        let lessons_before: LessonsBefore
        struct LessonsBefore: Decodable {
            let semester: Int
            let lessons: [Lessons]
        }
        struct LessonsNow: Decodable {
            let semester: Int
            let lessons: [Lessons]
        }
        struct Lessons: Decodable {
            let name: String
            let lesson_id: String
            let ex_all: Int
            let student_ex_was: Int
            let student_ex_not: Int
            let student_validmark: Int?
            let student_mark: Int?
        }
    }
    public struct ParentsApi: Decodable {
        let relatives: [ProfileApi]
    }
    public struct ProfileApi: Decodable {
        let firstname: String
        let middlename: String
        let lastname: String
        let photo: String
        let email: String?
        let phone: String?
        let birthday: String?
        let nationality: String?
        let school: Int?
        let segrys: Bool?
    }
    struct MessagesApi: Decodable {
        let dialogs: [DialogBody]
        struct DialogBody: Decodable {
            let dialog_lastname: String
            let dialog_firstname: String
            let dialog_photo: String
            let msg_text: String
            let dialog_user_id: Int
            let msg_datetime: String
            let msg_user_id: Int
        }
    }
    struct DialogsApi: Decodable {
        let messages: [Messages]
        struct Messages: Decodable {
            let text: String
            let user_id: String
            let mdatetime: String
            let read: Bool
        }
    }
    struct GetTeachersApi: Decodable {
        let teachers: [Teacher]
        struct Teacher: Decodable {
            let firstname: String
            let lastname: String
            let middlename: String
            let photo: String
            let user_id: String
        }
    }
    struct GetGroupsApi: Decodable {
        let courses: [Course]
        struct Course: Decodable {
            let course: Int
            let groups: [Group]
            struct Group: Decodable {
                let group_id: String
                let name: String
            }
        }
    }
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
    struct StudentHistoryApi: Decodable {
        let groups: [Groups]
    }
    struct Groups: Decodable {
        let group_id: String
        let name: String
    }
    public struct JournalByDateAPI: Decodable {
        let count_ex: Int
        let exercises: [Exercises]
        public struct Exercises: Decodable {
            let ex_period: String
            let ex_topic: String
            let ex_type: String
            let lesson_name: String
            let student_presence: Bool
            let student_mark: Int?
            let lesson_id: String
            let student_performance: String?
            let student_dropout: Bool
            let student_delay: String?
        }
    }
}
