//
//  LoginInteractor.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 08/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import Alamofire
class LoginInteractor: LoginInteractorProtocol {

    weak var presenter: LoginPresenterProtocol?
    private var token: String?
    private var userId: Int?
    private var childUserId: Int?
    var defaults = UserDefaults(suiteName: "group.com.fspo.app")
    func getGroupId(user_id: Int, token: String, completion: @escaping (Bool) -> Void) {
        let parameters: Parameters = [
            "user_id": user_id
        ]
        let headers: HTTPHeaders = [
            "token": token
        ]
        Alamofire.request(Constants.StudentHistoryURL, method: .get, parameters: parameters, headers: headers).responseJSON { (response) in
            let result = response.data
            do {
                let res = try JSONDecoder().decode(JSONDecoding.StudentHistoryApi.self, from: result!)
                UserDefaults.standard.set(res.groups[res.groups.count-1].group_id, forKey: "user_group_id")
                self.defaults?.set(res.groups[res.groups.count-1].group_id, forKey: "user_group_id")
                completion(true)
            } catch {
                print(error)
                self.presenter?.stopLoading()
                keychain["token"] = nil
                showMessage(message: "\(NSLocalizedString("Ошибка", comment: "")): \(error.localizedDescription)", y: 8)
            }
        }
    }
    func getChildId(user_id: Int, token: String, completion: @escaping (Bool) -> Void) {
        let parameters: Parameters = [
            "user_id": user_id
        ]
        let headers: HTTPHeaders = [
            "token": token
        ]
        Alamofire.request(Constants.ProfileURL, method: .get, parameters: parameters, headers: headers).responseJSON { (response) in
            let result = response.data
            do {
                let res = try JSONDecoder().decode(JSONDecoding.ParentsApi.self, from: result!)
                self.childUserId = Int(res.students![0].user_id!)
//                UserDefaults.standard.set(res.groups[res.groups.count-1].group_id, forKey: "user_group_id")
//                self.defaults?.set(res.groups[res.groups.count-1].group_id, forKey: "user_group_id")
                completion(true)
            } catch {
                print(error)
                self.presenter?.stopLoading()
                keychain["token"] = nil
                showMessage(message: "\(NSLocalizedString("Ошибка", comment: "")): \(error.localizedDescription)", y: 8)
            }
        }
    }
    func getRole(user_id: Int, token: String, completion: @escaping (Bool) -> Void) {
        let parameters: Parameters = [
            "user_id": user_id
        ]
        let headers: HTTPHeaders = [
            "token": token
        ]
        Alamofire.request(Constants.RolesURL, method: .get, parameters: parameters, headers: headers).responseJSON { (response) in
            let result = response.data
            do {
                let res = try JSONDecoder().decode(JSONDecoding.RolesApi.self, from: result!)
                if res.parent {
                    UserDefaults.standard.set("parent", forKey: "role")
                    self.defaults?.set("parent", forKey: "role")
                }
                if res.student {
                    UserDefaults.standard.set("student", forKey: "role")
                    self.defaults?.set("student", forKey: "role")
                }
                if res.teacher {
                    UserDefaults.standard.set("teacher", forKey: "role")
                    self.defaults?.set("teacher", forKey: "role")
                }
                completion(true)
            } catch {
                self.presenter?.stopLoading()
                keychain["token"] = nil
                showMessage(message: "\(NSLocalizedString("Ошибка", comment: "")): \(error.localizedDescription)", y: 8)
            }
        }
    }
    func getToken(completion: @escaping (Bool) -> Void) {
        let params: Parameters = [
            "login": LoginLayout.loginTextField.text!,
            "password": LoginLayout.passwordTextField.text!,
            "app_key": Constants.AppKey
        ]
        Alamofire.request(Constants.AuthURL, method: .post, parameters: params).responseJSON { (response) in
            let result = response.data
            do {
                let res = try JSONDecoder().decode(JSONDecoding.AuthApi.self, from: result!)
                keychain["token"] = res.token
                UserDefaults.standard.set(res.user_id, forKey: "user_id")
                self.userId = res.user_id
                self.token = res.token
                completion(true)
            } catch Swift.DecodingError.keyNotFound {
                self.presenter?.stopLoading()
                do {
                    let res = try JSONDecoder().decode(JSONDecoding.ApiError.self, from: result!)
                    if res.error_code == 6 {
                        showMessage(message: NSLocalizedString("Неправильные данные!", comment: ""), y: 8)
                    } else {
                        showMessage(message: "\(NSLocalizedString("Ошибка", comment: "")): \(res.error_code)", y: 8)
                    }
                } catch {
                    print(error)
                }
            } catch {
                self.presenter?.stopLoading()
                print("другая ошибка")
            }
        }
    }
    func login() {
        let group = DispatchGroup()
        group.enter()
        getToken { _ in
            self.getRole(user_id: self.userId!, token: self.token!) { _ in
                if UserDefaults.standard.string(forKey: "role") == "student" {
                    group.enter()
                    self.getGroupId(user_id: self.userId!, token: self.token!) { _ in
                        group.leave()
                    }
                }
                if UserDefaults.standard.string(forKey: "role") == "parent" {
                    group.enter()
                    self.getChildId(user_id: self.userId!, token: self.token!) { _ in
                        self.getGroupId(user_id: self.childUserId!, token: self.token!) { _ in
                            group.leave()
                        }
                    }
                }
                group.leave()
            }
        }
        UserDefaults.standard.set(5, forKey: "notificationsDelay")
        group.notify(queue: .main) {
            self.presenter?.userLoggedIn()
        }
    }
}
