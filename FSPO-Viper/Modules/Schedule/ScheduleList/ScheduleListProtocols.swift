//
//  ScheduleListProtocols.swift
//  FSPO
//
//  Created Николай Борисов on 09/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

// MARK: Wireframe -
protocol ScheduleListWireframeProtocol: class {

}
// MARK: Presenter -
protocol ScheduleListPresenterProtocol: class {
    func updateView(cache: JSONDecoding.StudentScheduleApi?)
    func scheduleFetched(data: JSONDecoding.StudentScheduleApi, type: String)
    func updateSchedule(week: String, cache: JSONDecoding.StudentScheduleApi?)
}

// MARK: Interactor -
protocol ScheduleListInteractorProtocol: class {
    func fetchSchedule(week: String, cache: JSONDecoding.StudentScheduleApi?)
  var presenter: ScheduleListPresenterProtocol? { get set }
}

// MARK: View -
protocol ScheduleListViewProtocol: class {
    func showNewScheduleRows(source: JSONDecoding.StudentScheduleApi, type: String)
  var presenter: ScheduleListPresenterProtocol? { get set }
}
