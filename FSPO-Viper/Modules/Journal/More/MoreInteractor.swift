//
//  MoreInteractor.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 27/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import Alamofire

final class MoreInteractor: MoreInteractorProtocol {

    weak var presenter: MorePresenterProtocol?
    func fetchMore(cache: JSONDecoding.MoreApi?) {
        var user_id = UserDefaults.standard.string(forKey: "user_id")
        if let childId = UserDefaults.standard.string(forKey: "child_user_id") {
            user_id = childId
        }
        let headers: HTTPHeaders = [
            "token": keychain["token"]!
        ]
        let params: Parameters = [
            "user_id": user_id!
        ]
        Alamofire.request(Constants.MoreURL, method: .get, parameters: params, headers: headers).responseJSON { (response) in
            let result = response.data
            do {
                let res = try JSONDecoder().decode(JSONDecoding.MoreApi.self, from: result!)
                if let safeCache = cache {
                    if safeCache != res {
                        clearCache(forKey: "more")
                        updateCache(with: result!, forKey: "more", expiry: .never)
                        self.presenter?.moreFetched(data: res)
                    }
                } else {
                    updateCache(with: result!, forKey: "more", expiry: .never)
                   self.presenter?.moreFetched(data: res)
                }
            } catch {
                print(error)
            }
        }
    }
}
