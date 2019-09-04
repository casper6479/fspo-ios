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
        var user_id = UserDefaults.standard.string(forKey: "user_id")
        if let childId = UserDefaults.standard.string(forKey: "child_user_id") {
            user_id = childId
        }
        guard let token = keychain["token"] else {
            presenter?.logOut()
            return
        }
        let headers: HTTPHeaders = [
            "token": token
        ]
        let parameters: Parameters = [
            "user_id": user_id!
            ]
        let jsonParams = parameters.jsonStringRepresentaiton ?? ""
        let params = [
            "jsondata": jsonParams
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
