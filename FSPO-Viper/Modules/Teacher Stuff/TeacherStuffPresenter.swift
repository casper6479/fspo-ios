//
//  TeacherStuffPresenter.swift
//  FSPO
//
//  Created Николай Борисов on 06/09/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class TeacherStuffPresenter: TeacherStuffPresenterProtocol {

    weak private var view: TeacherStuffViewProtocol?
    var interactor: TeacherStuffInteractorProtocol?
    private let router: TeacherStuffWireframeProtocol

    init(interface: TeacherStuffViewProtocol, interactor: TeacherStuffInteractorProtocol?, router: TeacherStuffWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

}
