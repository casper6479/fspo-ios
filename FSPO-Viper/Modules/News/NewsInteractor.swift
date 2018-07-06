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
//                NewsViewController().arr = res.news
//                NewsViewController.reloadTable()
                self.presenter?.updateData(data: res.news)
                print(res.count_n)
                /*for i in res.news {
                    self.arr.append(i)
                }
                self.all = res.count_n*/
                DispatchQueue.main.async {
//                    self.tableView.reloadData()
                    UIView.animate(withDuration: 0.3, animations: {
//                        self.tableView.alpha = 1
                    })
                }
            } catch {
                print(error)
            }
        }
    }
}
