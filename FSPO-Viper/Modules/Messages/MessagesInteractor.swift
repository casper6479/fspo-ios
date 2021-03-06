//
//  MessagesInteractor.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import Alamofire

class MessagesInteractor: MessagesInteractorProtocol {
    weak var presenter: MessagesPresenterProtocol?
    func fetchMessages(cache: JSONDecoding.MessagesApi?) {
        let headers: HTTPHeaders = [
            "token": keychain["token"]!
        ]
        Alamofire.request(Constants.MessagesURL, method: .get, headers: headers).responseJSON { (response) in
            let result = response.data
            do {
                let res = try JSONDecoder().decode(JSONDecoding.MessagesApi.self, from: result!)
                if let safeCache = cache {
                    if safeCache != res {
                        clearCache(forKey: "messages")
                        updateCache(with: result!, forKey: "messages", expiry: .never)
                        self.presenter?.messagesFetched(data: res)
                    }
                } else {
                    updateCache(with: result!, forKey: "messages", expiry: .never)
                    self.presenter?.messagesFetched(data: res)
                }
            } catch {
                print(error)
            }
        }
    }
}
