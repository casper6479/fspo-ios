//
//  TeacherStuffProtocols.swift
//  FSPO
//
//  Created Николай Борисов on 06/09/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation

// MARK: Wireframe -
protocol TeacherStuffWireframeProtocol: class {

}
// MARK: Presenter -
protocol TeacherStuffPresenterProtocol: class {

}

// MARK: Interactor -
protocol TeacherStuffInteractorProtocol: class {

  var presenter: TeacherStuffPresenterProtocol? { get set }
}

// MARK: View -
protocol TeacherStuffViewProtocol: class {

  var presenter: TeacherStuffPresenterProtocol? { get set }
}
