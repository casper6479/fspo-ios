//
//  SchedulePresenter.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class SchedulePresenter: SchedulePresenterProtocol {
    weak private var view: ScheduleViewProtocol?
    var interactor: ScheduleInteractorProtocol?
    private let router: ScheduleWireframeProtocol

    init(interface: ScheduleViewProtocol, interactor: ScheduleInteractorProtocol?, router: ScheduleWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    func updateSchedule(cache: JSONDecoding.StudentScheduleApi?) {
        if Connectivity.isConnectedToInternet() {
            interactor?.fetchStudentSchedule(week: "now", cache: cache)
        }
    }
    func updateGroups(cache: JSONDecoding.GetGroupsApi?) {
        if Connectivity.isConnectedToInternet() {
            interactor?.fetchScheduleByGroups(cache: cache)
        }
    }
    func updateTeachers(cache: JSONDecoding.GetTeachersApi?) {
        if Connectivity.isConnectedToInternet() {
            interactor?.fetchTeachers(cache: cache)
        }
    }
    func teachersFetched(data: JSONDecoding.GetTeachersApi) {
        view?.showNewTeacherRows(source: data)
    }
    func scheduleByGroupsFetched(data: JSONDecoding.GetGroupsApi) {
        view?.showNewScheduleByGroupsRows(source: data)
    }
    func studentScheduleFetched(data: JSONDecoding.StudentScheduleApi) {
        view?.showNewStudentScheduleRows(source: data)
    }
    func updateStudentSchedule(week: String, cache: JSONDecoding.StudentScheduleApi?) {
        if Connectivity.isConnectedToInternet() {
            interactor?.fetchStudentSchedule(week: week, cache: cache)
        }
    }
}
