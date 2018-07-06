//
//  ScheduleProtocols.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

// MARK: Wireframe -
protocol ScheduleWireframeProtocol: class {

}
// MARK: Presenter -
protocol SchedulePresenterProtocol: class {

}

// MARK: Interactor -
protocol ScheduleInteractorProtocol: class {

  var presenter: SchedulePresenterProtocol? { get set }
}

// MARK: View -
protocol ScheduleViewProtocol: class {

  var presenter: SchedulePresenterProtocol? { get set }
}
