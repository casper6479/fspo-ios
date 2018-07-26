//
//  File.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 07/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation
import UIKit

class DateToString {
    func formatDate(_ dateString: String) -> String {
        let calendar = Calendar.current
        var finalString = ""
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatterGet.locale = Locale(identifier: "en_US")
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        let date: Date? = dateFormatterGet.date(from: dateString)
        if calendar.isDateInToday(date!) {
            dateFormatter.dateFormat = "HH:mm"
            finalString = NSLocalizedString("Сегодня в ", comment: "")+"\(dateFormatter.string(from: date!))"
        } else if calendar.isDateInYesterday(date!) {
            dateFormatter.dateFormat = "HH:mm"
            finalString = NSLocalizedString("Вчера в ", comment: "")+"\(dateFormatter.string(from: date!))"
        } else {
            if Calendar.current.component(.year, from: date!) == Calendar.current.component(.year, from: Date()) {
                dateFormatter.dateFormat = "d MMMM HH:mm"
            } else {
                dateFormatter.dateFormat = "dd.MM.yy HH:mm"
            }
            finalString = dateFormatter.string(from: date!)
        }
        return finalString
    }
}
