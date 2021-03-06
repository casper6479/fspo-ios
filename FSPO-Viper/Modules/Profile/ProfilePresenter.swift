//
//  ProfilePresenter.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class ProfilePresenter: ProfilePresenterProtocol {
    weak private var view: ProfileViewProtocol?
    var interactor: ProfileInteractorProtocol?
    private let router: ProfileWireframeProtocol

    init(interface: ProfileViewProtocol, interactor: ProfileInteractorProtocol?, router: ProfileWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    func updateView(cache: JSONDecoding.ProfileApi?) {
        if Connectivity.isConnectedToInternet() {
            interactor?.fetchProfile(cache: cache)
        }
    }
    func profileFetched(data: JSONDecoding.ProfileApi) {
        view?.fillView(data: data)
    }
    func showParents() {
        view?.show(vc: ParentsRouter.createModule())
    }
    func showSettings() {
        view?.show(vc: SettingsRouter.createModule())
    }

}
