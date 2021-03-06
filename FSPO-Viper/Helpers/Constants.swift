//
//  Constants.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class Constants {
    public static let KeychainService = "com.fspo.app"
    public static var safeHeight: CGFloat = 0.0
    public static let NewsURL = "https://ifspo.ifmo.ru/api/news"
    public static let AuthURL = "https://ifspo.ifmo.ru/api/authorization"
    public static var AppKey = "b13f556af4ed3da2f8d484a617fee76d78be1166"
    public static let RolesURL = "https://ifspo.ifmo.ru/api/roles"
    public static let StudentHistoryURL = "https://ifspo.ifmo.ru/api/studentHistory"
    public static let JournalURL = "https://ifspo.ifmo.ru/api/eduInfo"
    public static let JournalBySubjectsURL = "https://ifspo.ifmo.ru/api/studentLessons"
    public static let JournalByDateURL = "https://ifspo.ifmo.ru/api/visitsByDate"
    public static let JournalByTeacher = "https://ifspo.ifmo.ru/api/visitsByLesson"
    public static let MoreURL = "https://ifspo.ifmo.ru/api/eduInfoMore"
    public static let ProfileURL = "https://ifspo.ifmo.ru/api/profile"
    public static let MessagesURL = "https://ifspo.ifmo.ru/api/messages"
    public static let DialogURL = "https://ifspo.ifmo.ru/api/messagesHistory"
    public static let TeachersURL = "https://ifspo.ifmo.ru/api/teachers"
    public static let GroupsURL = "https://ifspo.ifmo.ru/api/groups"
    public static let ScheduleURL = "https://ifspo.ifmo.ru/api/schedule"
    public static let ISUScheduleURL = "http://orir.ifmo.ru/mobile/API2.0/index.php"
    public static let ConsultationsURL = "https://ifspo.ifmo.ru/schedule/getallconsultations?type=active"
    public static let SearchURL = "https://ifspo.ifmo.ru/api/search"
}
