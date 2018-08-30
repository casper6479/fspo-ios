//
//  DialogInteractor.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 05/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import Alamofire

class DialogInteractor: DialogInteractorProtocol {
    var dialog_user_id: Int?
    init(dialog_user_id: Int) {
        self.dialog_user_id = dialog_user_id
    }
    func fetchDialogs(cache: JSONDecoding.DialogsApi?) {
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
                if let safeCache = cache {
                    if safeCache != res {
                        clearCache(forKey: "dialogs\(self.dialog_user_id!)")
                        updateCache(with: result!, forKey: "dialogs\(self.dialog_user_id!)", expiry: .never)
                        self.presenter?.dialogsFetched(data: res)
                    }
                } else {
                    updateCache(with: result!, forKey: "dialogs\(self.dialog_user_id!)", expiry: .never)
                    self.presenter?.dialogsFetched(data: res)
                }
            } catch {
                let alert = UIAlertController(title: NSLocalizedString("Ошибка при получении данных", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Сообщить об ошибке", comment: ""), style: .default, handler: {_ in
                    self.sendMessage(text: "Ошибка в сообщениях у \(UserDefaults.standard.integer(forKey: "user_id")) \n error:\(error)", id: "1000364")
                }))
                alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                self.presenter?.updateFailed(alertController: alert)
            }
        }
    }
    func sendMessage(text: String, id: String?) {
        let headers: HTTPHeaders = [
            "token": keychain["token"]!
        ]
        let params: Parameters = [
            "user_id": id != nil ? id! : dialog_user_id!,
            "text": text
        ]
        Alamofire.request("https://ifspo.ifmo.ru/api/sendMessage", method: .post, parameters: params, headers: headers)
                .responseJSON { _ in
                    self.presenter?.updateView(cache: nil)
        }
    }
    weak var presenter: DialogPresenterProtocol?
}
