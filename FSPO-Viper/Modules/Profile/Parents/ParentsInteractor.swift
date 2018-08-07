//
//  ParentsInteractor.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 27/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import Alamofire

class ParentsInteractor: ParentsInteractorProtocol {
    weak var presenter: ParentsPresenterProtocol?
    func fetchParents() {
        let user_id = UserDefaults.standard.integer(forKey: "user_id")
        let params: Parameters = [
            "user_id": user_id
        ]
        let headers: HTTPHeaders = [
            "token": keychain["token"]!
        ]
        Alamofire.request(Constants.ProfileURL, method: .get, parameters: params, headers: headers).responseJSON { (response) in
            let result = response.data
            do {
                let res = try JSONDecoder().decode(JSONDecoding.ParentsApi.self, from: result!)
                self.presenter?.parentsFetched(firstname: res.relatives[0].firstname, lastname: res.relatives[0].lastname, middlename: res.relatives[0].middlename, email: res.relatives[0].email!, phone: res.relatives[0].phone!, photo: res.relatives[0].photo)
                /*self.first.text = res.relatives[0].lastname
                self.second.text = res.relatives[0].firstname
                self.third.text = res.relatives[0].middlename
                
                if res.relatives[0].email == nil {
                    self.email.text = "Не указано"
                } else {
                    self.email.text = res.relatives[0].email
                }
                
                if res.relatives[0].phone == nil {
                    self.phone.text = "Не указано"
                } else {
                    self.phone.text = res.relatives[0].phone
                }
                var frame = self.emailImage.frame
                frame.origin.x = 100
                var labelframe = self.email.frame
                labelframe.origin.x = -300
                self.emailImage.alpha = 1
                self.phoneImage.alpha = 1
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
                    //                    self.view.hideLoader()
                    self.emailImage.frame = frame
                    self.phoneImage.frame = frame
                    self.email.frame = labelframe
                    self.phone.frame = labelframe
                }) { (true) in
                }
                let resource = ImageResource(downloadURL: URL(string: res.relatives[0].photo)!, cacheKey: res.relatives[0].photo)
                self.fourth.kf.indicatorType = .activity
                self.fourth.kf.setImage(with: resource)*/
            } catch {
                print(error)
            }
        }
    }
}
