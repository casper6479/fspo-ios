//
//  JournalInteractor.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import Alamofire

class JournalInteractor: JournalInteractorProtocol {
    weak var presenter: JournalPresenterProtocol?
    func fetchJournal(cache: JSONDecoding.JournalApi?) {
        let user_id = UserDefaults.standard.string(forKey: "user_id")
        let headers: HTTPHeaders = [
            "token": keychain["token"]!
        ]
        let params: Parameters = [
            "user_id": user_id!
            ]
        Alamofire.request(Constants.JournalURL, method: .get, parameters: params, headers: headers).responseJSON { (response) in
            let result = response.data
            do {
                let res = try JSONDecoder().decode(JSONDecoding.JournalApi.self, from: result!)
                if let safeCache = cache {
                    if safeCache != res {
                        clearCache(forKey: "journal")
                        updateCache(with: result!, forKey: "journal", expiry: .never)
                        self.presenter?.journalFetched(data: res)
                    }
                } else {
                    updateCache(with: result!, forKey: "journal", expiry: .never)
                    self.presenter?.journalFetched(data: res)
                }
            } catch {
                print(error)
            }
        }
    }
}
