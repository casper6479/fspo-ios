//
//  DialogInteractor.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 05/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import Alamofire

class DialogInteractor: DialogInteractorProtocol {
    var dialog_user_id: Int?
    
    init(dialog_user_id: Int) {
        self.dialog_user_id = dialog_user_id
    }
    
    func fetchDialogs() {
        let headers: HTTPHeaders = [
            "token": keychain["token"]!
        ]
        let params: Parameters = [
            "user_id": dialog_user_id!
        ]
        Alamofire.request("https://ifspo.ifmo.ru/api/messagesHistory", method: .get, parameters: params, headers: headers).responseJSON { (response) in
            let result = response.data
            do {
                let res = try JSONDecoder().decode(JSONDecoding.DialogsApi.self, from: result!)
                self.presenter?.dialogsFetched(data: res)
            } catch {
                print(error)
            }
        }
    }
    weak var presenter: DialogPresenterProtocol?
}
