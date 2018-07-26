//
//  JSONDecoding.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation

class JSONDecoding {
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
    /*struct studentHistoryAPI: Decodable {
        let groups: [groups]
    }
    struct groups: Decodable {
        let group_id: String
        let name: String
    }*/
}
