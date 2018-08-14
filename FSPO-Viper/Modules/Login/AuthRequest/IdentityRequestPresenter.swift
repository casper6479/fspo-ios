//
//  IdentityRequestPresenter.swift
//  FSPO
//
//  Created Николай Борисов on 14/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class IdentityRequestPresenter: IdentityRequestPresenterProtocol {

    weak private var view: IdentityRequestViewProtocol?
    var interactor: IdentityRequestInteractorProtocol?
    private let router: IdentityRequestWireframeProtocol

    init(interface: IdentityRequestViewProtocol, interactor: IdentityRequestInteractorProtocol?, router: IdentityRequestWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

}
