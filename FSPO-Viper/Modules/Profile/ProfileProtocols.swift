//
//  ProfileProtocols.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation
import UIKit
// MARK: Wireframe -
protocol ProfileWireframeProtocol: class {

}
// MARK: Presenter -
protocol ProfilePresenterProtocol: class {
    func showSettings()
    func showParents()
    func updateView(cache: JSONDecoding.ProfileApi?)
    func profileFetched(data: JSONDecoding.ProfileApi)
}

// MARK: Interactor -
protocol ProfileInteractorProtocol: class {
    func fetchProfile(cache: JSONDecoding.ProfileApi?)
    var presenter: ProfilePresenterProtocol? { get set }
}

// MARK: View -
protocol ProfileViewProtocol: class {
    func show(vc: UIViewController)
    func fillView(data: JSONDecoding.ProfileApi)
    var presenter: ProfilePresenterProtocol? { get set }
}
