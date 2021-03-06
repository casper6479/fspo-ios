//
//  JournalByDateInteractor.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 27/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import Alamofire

class JournalByDateInteractor: JournalByDateInteractorProtocol {
    weak var presenter: JournalByDatePresenterProtocol?
    func fetchJournalByDate(date: String) {
        var user_id = UserDefaults.standard.string(forKey: "user_id")
        if let childId = UserDefaults.standard.string(forKey: "child_user_id") {
            user_id = childId
        }
        let headers: HTTPHeaders = [
            "token": keychain["token"]!
        ]
        let parameters: Parameters = [
            "user_id": user_id!,
            "vdate": date
        ]
        let jsonParams = parameters.jsonStringRepresentaiton ?? ""
        let params = [
            "jsondata": jsonParams
        ]
        Alamofire.request(Constants.JournalByDateURL, method: .get, parameters: params, headers: headers).responseJSON { (response) in
            let result = response.data
            do {
                let res = try JSONDecoder().decode(JSONDecoding.JournalByDateAPI.self, from: result!)
                if res.count_ex == 0 {
                    self.presenter?.journalByDateFetched(data: res)
                    self.presenter?.journalByDateShowNoLessons()
                } else {
                    self.presenter?.journalByDateFetched(data: res)
                    self.presenter?.jounalByDateHideNoLessons()
                }
                /*self.arr = res.exercises
                self.excount = res.count_ex
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    stopLoader()
                    UIView.animate(withDuration: 0.3, animations: {
                        self.tableView.alpha = 1
                    }, completion:  nil)
                }*/
            } catch {
                print(error)
            }
        }
    }
}
