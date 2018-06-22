//
//  File.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 21/06/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation

struct JSONAnswer: Decodable {
    let news: [News]
    let count_n: Int
}
struct News: Decodable {
    let text: String
    let ndatetime: String
}
