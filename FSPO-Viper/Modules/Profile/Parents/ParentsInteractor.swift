//
//  ParentsInteractor.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 27/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import Alamofire

class ParentsInteractor: ParentsInteractorProtocol {
    weak var presenter: ParentsPresenterProtocol?
    func fetchParents() {
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
            do {
                let res = try JSONDecoder().decode(JSONDecoding.ParentsApi.self, from: result!)
                if UserDefaults.standard.string(forKey: "role") == "student" {
                    self.presenter?.parentsFetched(firstname: res.relatives![0].firstname, lastname: res.relatives![0].lastname, middlename: res.relatives![0].middlename, email: res.relatives![0].email!, phone: res.relatives![0].phone!, photo: res.relatives![0].photo)
                }
                if UserDefaults.standard.string(forKey: "role") == "parent" {
                    self.presenter?.parentsFetched(firstname: res.students![0].firstname, lastname: res.students![0].lastname, middlename: res.students![0].middlename, email: res.students![0].email!, phone: res.students![0].phone!, photo: res.students![0].photo)
                }
            } catch {
                print(error)
            }
        }
    }
}
