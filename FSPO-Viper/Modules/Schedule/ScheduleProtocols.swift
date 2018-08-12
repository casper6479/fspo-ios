//
//  ScheduleProtocols.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

// MARK: Wireframe -
protocol ScheduleWireframeProtocol: class {

}
// MARK: Presenter -
protocol SchedulePresenterProtocol: class {
    func updateSchedule(cache: JSONDecoding.StudentScheduleApi?)
    func updateGroups(cache: JSONDecoding.GetGroupsApi?)
    func updateTeachers(cache: JSONDecoding.GetTeachersApi?)
    func teachersFetched(data: JSONDecoding.GetTeachersApi)
    func scheduleByGroupsFetched(data: JSONDecoding.GetGroupsApi)
    func studentScheduleFetched(data: JSONDecoding.StudentScheduleApi)
    func updateStudentSchedule(week: String)
}

// MARK: Interactor -
protocol ScheduleInteractorProtocol: class {
    func fetchTeachers(cache: JSONDecoding.GetTeachersApi?)
    func fetchScheduleByGroups(cache: JSONDecoding.GetGroupsApi?)
    func fetchStudentSchedule(week: String, cache: JSONDecoding.StudentScheduleApi?)
  var presenter: SchedulePresenterProtocol? { get set }
}

// MARK: View -
protocol ScheduleViewProtocol: class {
    func showNewTeacherRows(source: JSONDecoding.GetTeachersApi)
    func showNewScheduleByGroupsRows(source: JSONDecoding.GetGroupsApi)
    func showNewStudentScheduleRows(source: JSONDecoding.StudentScheduleApi)
  var presenter: SchedulePresenterProtocol? { get set }
}
