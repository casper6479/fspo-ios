//
//  ParentsProtocols.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 27/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation
import UIKit
// MARK: Wireframe -
protocol ParentsWireframeProtocol: class {

}
// MARK: Presenter -
protocol ParentsPresenterProtocol: class {
    func updateView()
    func parentsFetched(firstname: String, lastname: String, middlename: String, email: String, phone: String, photo: UIImage)
}

// MARK: Interactor -
protocol ParentsInteractorProtocol: class {
    func fetchParents()
    var presenter: ParentsPresenterProtocol? { get set }
}

// MARK: View -
protocol ParentsViewProtocol: class {
    func fillView(firstname: String, lastname: String, middlename: String, email: String, phone: String, photo: UIImage)
    var presenter: ParentsPresenterProtocol? { get set }
}
