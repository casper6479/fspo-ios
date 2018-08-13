//
//  JournalBySubjectInteractor.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 27/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import Alamofire

class JournalBySubjectInteractor: JournalBySubjectInteractorProtocol {

    weak var presenter: JournalBySubjectPresenterProtocol?
    func fetchSubjects(cache: JSONDecoding.JournalBySubjectsApi?) {
        let user_id = UserDefaults.standard.integer(forKey: "user_id")
        let headers: HTTPHeaders = [
            "token": keychain["token"]!
        ]
        let params: Parameters = [
            "user_id": user_id
        ]
        Alamofire.request(Constants.JournalBySubjectsURL, method: .get, parameters: params, headers: headers).responseJSON { (response) in
            let result = response.data
            do {
                let res = try JSONDecoder().decode(JSONDecoding.JournalBySubjectsApi.self, from: result!)
                if let safeCache = cache {
                    if safeCache != res {
                        clearCache(forKey: "journalBySubject")
                        updateCache(with: result!, forKey: "journalBySubject", expiry: .never)
                        self.presenter?.journalBySubjectFetched(data: res)
                    }
                } else {
                    updateCache(with: result!, forKey: "journalBySubject", expiry: .never)
                    self.presenter?.journalBySubjectFetched(data: res)
                }
            } catch {
                print(error)
            }
        }
    }
}
