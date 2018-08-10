//
//  NewsInteractor.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import Alamofire

class NewsInteractor: NewsInteractorProtocol {
    weak var presenter: NewsPresenterProtocol?
    func fetchNews(offset: Int) {
        let params: Parameters = [
            "app_key": Constants.AppKey,
            "count": 100,
            "offset": offset
        ]
        Alamofire.request(Constants.NewsURL, method: .get, parameters: params).responseJSON { (response) in
            let result = response.data
            do {
                let res = try JSONDecoder().decode(JSONDecoding.NewsApi.self, from: result!)
                self.presenter?.updateData(data: res)
            } catch {
                let alert = UIAlertController(title: NSLocalizedString("Ошибка при получении данных", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Повторить", comment: ""), style: UIAlertActionStyle.default, handler: {_ in
                    _ = self.fetchNews(offset: offset)
                }))
                alert.addAction(UIAlertAction(title: "ОК", style: UIAlertActionStyle.default, handler: nil))
                self.presenter?.updateFailed(alertController: alert)
                print(error)
            }
        }
    }
}
