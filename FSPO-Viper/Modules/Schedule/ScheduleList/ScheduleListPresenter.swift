//
//  ScheduleListPresenter.swift
//  FSPO
//
//  Created Николай Борисов on 09/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class ScheduleListPresenter: ScheduleListPresenterProtocol {

    weak private var view: ScheduleListViewProtocol?
    var interactor: ScheduleListInteractorProtocol?
    private let router: ScheduleListWireframeProtocol

    init(interface: ScheduleListViewProtocol, interactor: ScheduleListInteractorProtocol?, router: ScheduleListWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    func updateView(cache: JSONDecoding.StudentScheduleApi?) {
        if Connectivity.isConnectedToInternet() {
            interactor?.fetchSchedule(week: "now", cache: cache)
        }
    }
    func scheduleFetched(data: JSONDecoding.StudentScheduleApi, type: String) {
        view?.showNewScheduleRows(source: data, type: type)
    }
    func updateSchedule(week: String, cache: JSONDecoding.StudentScheduleApi?) {
        interactor?.fetchSchedule(week: week, cache: cache)
    }
}
