//
//  ScheduleListInteractor.swift
//  FSPO
//
//  Created Николай Борисов on 09/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import Alamofire

class ScheduleListInteractor: ScheduleListInteractorProtocol {
    var id: Int?
    var type: String?
    init(id: Int, type: String) {
        self.id = id
        self.type = type
    }
    weak var presenter: ScheduleListPresenterProtocol?

    func fetchSchedule(week: String, cache: JSONDecoding.StudentScheduleApi?) {
        let params: Parameters = [
            "app_key": Constants.AppKey,
            "type": type!,
            "id": id!,
            "week": week
        ]
        Alamofire.request("https://ifspo.ifmo.ru/api/schedule", method: .get, parameters: params).responseJSON { (response) in
            let result = response.data
            do {
                let res = try JSONDecoder().decode(JSONDecoding.StudentScheduleApi.self, from: result!)
                if let safeCache = cache {
                    if safeCache != res {
                        clearCache(forKey: "\(self.type!)\(self.id!)")
                        updateCache(with: result!, forKey: "\(self.type!)\(self.id!)", expiry: .never)
                        self.presenter?.scheduleFetched(data: res, type: self.type!)
                    }
                } else {
                    updateCache(with: result!, forKey: "\(self.type!)\(self.id!)", expiry: .never)
                    self.presenter?.scheduleFetched(data: res, type: self.type!)
                }
            } catch {
                print(error)
            }
        }
    }
}
