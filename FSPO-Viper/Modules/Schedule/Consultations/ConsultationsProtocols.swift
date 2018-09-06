//
//  ConsultationsProtocols.swift
//  FSPO
//
//  Created Николай Борисов on 03/09/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation

// MARK: Wireframe -
protocol ConsultationsWireframeProtocol: class {

}
// MARK: Presenter -
protocol ConsultationsPresenterProtocol: class {
    func updateView()
    func consultationsFetched(data: [[String: Any]])
}

// MARK: Interactor -
protocol ConsultationsInteractorProtocol: class {

    var presenter: ConsultationsPresenterProtocol? { get set }
    func fetchConsultations()
}

// MARK: View -
protocol ConsultationsViewProtocol: class {
    func showNewRows(data: [[String: Any]])
    var presenter: ConsultationsPresenterProtocol? { get set }
}
