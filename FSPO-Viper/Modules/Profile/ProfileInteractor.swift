//
//  ProfileInteractor.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import Alamofire

class ProfileInteractor: ProfileInteractorProtocol {
    func fetchProfile(cache: JSONDecoding.ProfileApi?) {
        let user_id = UserDefaults.standard.integer(forKey: "user_id")
        let parameters: Parameters = [
            "user_id": user_id
        ]
        let headers: HTTPHeaders = [
            "token": keychain["token"]!
        ]
        let jsonParams = parameters.jsonStringRepresentaiton ?? ""
        let params = [
            "jsondata": jsonParams
        ]
        Alamofire.request(Constants.ProfileURL, method: .get, parameters: params, headers: headers).responseJSON { (response) in
            let result = response.data
//            print(try? JSONSerialization.jsonObject(with: result!, options: .mutableContainers))
            do {
                let res = try JSONDecoder().decode(JSONDecoding.ProfileApi.self, from: result!)
                if let safeCache = cache {
                    if safeCache != res {
                        print("cache is deprecated")
                        clearCache(forKey: "profile")
                        updateCache(with: result!, forKey: "profile", expiry: .never)
                        self.presenter?.profileFetched(data: res)
                    } else {
                        print("found in cache")
                    }
                } else {
                    print("cache is empty")
                    updateCache(with: result!, forKey: "profile", expiry: .never)
                    self.presenter?.profileFetched(data: res)
                }
            } catch {
                print(error)
            }
        }
    }
    weak var presenter: ProfilePresenterProtocol?
}
