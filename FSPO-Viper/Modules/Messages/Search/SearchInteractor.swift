//
//  SearchInteractor.swift
//  FSPO
//
//  Created Николай Борисов on 06/09/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Alamofire

class SearchInteractor: SearchInteractorProtocol {
    static var test = Alamofire.request("")
    weak var presenter: SearchPresenterProtocol?
    func fetchSearch(query: String) {
        let headers: HTTPHeaders = [
            "token": keychain["token"]!
        ]
        let params: Parameters = [
            "query": query
        ]
        SearchInteractor.test.cancel()
        SearchInteractor.test = Alamofire.request(Constants.SearchURL, method: .get, parameters: params, headers: headers).responseJSON { (response) in
            let result = response.data
            do {
                let res = try JSONDecoder().decode(JSONDecoding.SearchAPI.self, from: result!)
                self.presenter?.searchFetched(data: res)
            } catch {
                print(error)
            }
        }
    }
}
