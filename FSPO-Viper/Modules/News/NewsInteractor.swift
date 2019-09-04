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
    func fetchNews(offset: Int, cache: [JSONDecoding.NewsApi.News]?) {
        let parameters: Parameters = [
            "app_key": Constants.AppKey,
            "count": 100,
            "offset": offset
        ]
        let jsonParams = parameters.jsonStringRepresentaiton ?? ""
        let params = [
            "jsondata": jsonParams
        ]
        Alamofire.request(Constants.NewsURL, method: .get, parameters: params).responseJSON { (response) in
            let result = response.data
            do {
                let res = try JSONDecoder().decode(JSONDecoding.NewsApi.self, from: result!)
                if let safeCache = cache {
                    if safeCache != res.news {
                        clearCache(forKey: "news")
                        if offset == 0 {
                            updateCache(with: result!, forKey: "news", expiry: .never)
                        }
                        self.presenter?.updateData(data: res)
                    }
                } else {
                    if offset == 0 {
                        updateCache(with: result!, forKey: "news", expiry: .never)
                    }
                    self.presenter?.updateData(data: res)
                }
            } catch {
                let alert = UIAlertController(title: NSLocalizedString("Ошибка при получении данных", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Повторить", comment: ""), style: UIAlertAction.Style.default, handler: {_ in
                    _ = self.fetchNews(offset: offset, cache: cache)
                }))
                alert.addAction(UIAlertAction(title: "ОК", style: UIAlertAction.Style.default, handler: nil))
                self.presenter?.updateFailed(alertController: alert)
                print(error)
            }
        }
    }
}
