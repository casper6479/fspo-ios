//
//  SchedulePresenter.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
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
    func updateView() {
        interactor?.fetchScheduleByGroups()
        interactor?.fetchTeachers()
        interactor?.fetchStudentSchedule()
    }
    func teachersFetched(data: JSONDecoding.GetTeachersApi) {
        view?.showNewTeacherRows(source: data)
    }
    func scheduleByGroupsFetched(data: JSONDecoding.GetGroupsApi) {
        view?.showNewScheduleByGroupsRows(source: data)
    }
    func studentScheduleFetched(data: JSONDecoding.StudentScheduleAPI) {
        view?.showNewStudentScheduleRows(source: data)
    }
}
