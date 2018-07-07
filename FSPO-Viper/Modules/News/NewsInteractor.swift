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
    func fetchNews() {
        let params: Parameters = [
            "app_key": Constants.AppKey,
            "count": 100,
            "offset": 0
        ]
        Alamofire.request(Constants.NewsURL, method: .get, parameters: params).responseJSON { (response) in
            let result = response.data
            do {
                let res = try JSONDecoder().decode(JSONDecoding.NewsApi.self, from: result!)
                self.presenter?.updateData(data: res.news)
            } catch {
                print(error)
            }
        }
    }
}
