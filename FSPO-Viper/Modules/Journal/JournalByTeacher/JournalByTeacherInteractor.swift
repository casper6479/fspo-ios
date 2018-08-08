//
//  JournalByTeacherInteractor.swift
//  FSPO
//
//  Created Николай Борисов on 07/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import Alamofire

class JournalByTeacherInteractor: JournalByTeacherInteractorProtocol {

    weak var presenter: JournalByTeacherPresenterProtocol?
    var lessonId: Int?
    init(lessonId: Int) {
        self.lessonId = lessonId
    }
    func fetchLessons() {
        let user_id = UserDefaults.standard.integer(forKey: "user_id")
        let headers: HTTPHeaders = [
            "token": keychain["token"]!
        ]
        let params: Parameters = [
            "user_id": user_id,
            "lesson_id": lessonId!
        ]
        Alamofire.request(Constants.JournalByTeacher, method: .get, parameters: params, headers: headers).responseJSON { (response) in
            let result = response.data
            do {
                let res = try JSONDecoder().decode(JSONDecoding.JournalByTeacherAPI.self, from: result!)
                self.presenter?.journalByTeacherFetched(data: res)
                /*self.arr = res.days
                self.teacherModel = res.teacher_info
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    stopLoader()
                    UIView.animate(withDuration: 0.3, animations: {
                        self.tableView.alpha = 1
                    }, completion:  nil)
                }*/
            } catch {
                print(error)
            }
        }
    }
}
