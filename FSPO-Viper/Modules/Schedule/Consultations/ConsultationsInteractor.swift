//
//  ConsultationsInteractor.swift
//  FSPO
//
//  Created Николай Борисов on 03/09/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import Alamofire
import Kanna

class ConsultationsInteractor: ConsultationsInteractorProtocol {

    weak var presenter: ConsultationsPresenterProtocol?

    func fetchConsultations() {
        var dataSource = [[String: Any]]()
        Alamofire.request(Constants.ConsultationsURL)
            .responseString { response in
                let html = response.result.value
                if let doc = try? HTML(html: html!, encoding: .utf8) {
                    var item: [String: Any] = [
                        "teacher": String(),
                        "update": String(),
                        "lessons": [String](),
                        "date": String(),
                        "message": String()
                    ]
                    if doc.css(".weekday-p").count == 0 {

                    } else {
                        for i in 0...doc.css(".weekday-p").count - 1 {
                            let document = doc.css(".weekday-p")
                            if let teacher = document[i].css("b").first?.text {
                                item["teacher"] = teacher
                            } else {
                                item["teacher"] = ""
                            }
                            if let update = document[i].css(".update_place").first?.text {
                                item["update"] = update
                            } else {
                                item["update"] = ""
                            }
                            var arr = [String]()
                            for lessonDiv in doc.css(".period")[i].css("div") {
                                if let lesson = lessonDiv.text {
                                    arr.append(lesson.trimmingCharacters(in: .whitespacesAndNewlines))
                                } else {
                                    arr.append("")
                                }
                            }
                            if arr.count != 0 {
                                item["lessons"] = arr
                            } else {
                                item["lessons"] = ""
                            }
                            if let date = doc.css(".lesson_td")[i].text {
                                item["date"] = date.trimmingCharacters(in: .whitespacesAndNewlines)
                            } else {
                                item["date"] = ""
                            }
                            if let message = doc.css(".weekday-div")[i].css("p").first?.text {
                                item["message"] = message.trimmingCharacters(in: .whitespacesAndNewlines)
                            } else {
                                item["message"] = ""
                            }
                            dataSource.append(item)
                        }
                        self.presenter?.consultationsFetched(data: dataSource)
                    }
                }
        }
    }
}
