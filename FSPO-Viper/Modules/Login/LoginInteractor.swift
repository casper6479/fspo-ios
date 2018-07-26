//
//  LoginInteractor.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 08/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import Alamofire
class LoginInteractor: LoginInteractorProtocol {

    weak var presenter: LoginPresenterProtocol?
    func login() {
        let params: Parameters = [
            "login": LoginLayout.loginTextField.text!,
            "password": LoginLayout.passwordTextField.text!,
            "app_key": Constants.AppKey
        ]
        Alamofire.request(Constants.AuthURL, method: .post, parameters: params).responseJSON { (response) in
            let result = response.data
            do {
                let res = try JSONDecoder().decode(JSONDecoding.AuthApi.self, from: result!)
                self.presenter?.userLoggedIn()
                keychain["token"] = res.token
                UserDefaults.standard.set(res.user_id, forKey: "user_id")
                //                UserDefaults.standard.set(res.token, forKey: "token")
                //                UserDefaults.standard.set(true, forKey: "isLogged")
                //                UserDefaults.standard.set(5, forKey: "fireDate")
                //                UserDefaults.standard.set(true, forKey: "allow_notifications")
                //                UserDefaults.standard.set(false, forKey: "enable_auth")
                //                UserDefaults.standard.set(1, forKey: "Notification_sound")
                //                touchid = true
                //                let parameters: Parameters = [
                //                    "user_id": res.user_id
                //                ]
                //                let headers: HTTPHeaders = [
                //                    "token": res.token
                //                ]
                //                Alamofire.request(Constants.StudentHistoryURL, method: .get, parameters: parameters, headers: headers).responseJSON { (response) in
                //                    let result = response.data
                //                    do{
                //                        let res = try JSONDecoder().decode(studentHistoryAPI.self, from: result!)
                //                        UserDefaults.standard.set(res.groups[res.groups.count-1].group_id, forKey: "user_group_id")
                //                        self.defaults?.set(res.groups[res.groups.count-1].group_id, forKey: "user_group_id")
                //                    }
                //                    catch {
                //                        print(error)
                //                    }
                //                }
                //                let modalTabBar = self.storyboard?.instantiateViewController(withIdentifier: "TabBar")
                //                let modalTeacherTabBar = self.storyboard?.instantiateViewController(withIdentifier: "TeacherTabBar")
                //                Alamofire.request(Constants.RolesURL, method: .get, parameters: parameters, headers: headers).responseJSON { (response) in
                //                    let result = response.data
                //                    do{
                //                        let res = try JSONDecoder().decode(RolesAPI.self, from: result!)
                //                        if res.parent {
                //                            UserDefaults.standard.set("parent", forKey: "role")
                //                            self.didFinishYourLoading(controller: modalTabBar!)
                //                        }
                //                        if res.student {
                //                            UserDefaults.standard.set("student", forKey: "role")
                //                            self.didFinishYourLoading(controller: modalTabBar!)
                //                        }
                //                        if res.teacher {
                //                            UserDefaults.standard.set("teacher", forKey: "role")
                //                            self.didFinishYourLoading(controller: modalTeacherTabBar!)
                //                        }
                //
                //                    }
                //                    catch {
                //                        print(error)
                //                    }
                //                }
                //
            } catch Swift.DecodingError.keyNotFound {
                do {
                    let res = try JSONDecoder().decode(JSONDecoding.ApiError.self, from: result!)
                    if res.error_code == 6 {
//                        self.showToast(message: "Неправильные данные!")
                        //                        self.enter.returnToOriginalState()
                    } else {
//                        self.showToast(message: "Ошибка: \(res.error_code)")
                        //                        self.enter.returnToOriginalState()
                    }
                } catch {
                }
            } catch {
                print("xz")
            }
        }
    }
}
