//
//  MoreProtocols.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 27/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

// MARK: Wireframe -
protocol MoreWireframeProtocol: class {

}
// MARK: Presenter -
protocol MorePresenterProtocol: class {

}

// MARK: Interactor -
protocol MoreInteractorProtocol: class {

  var presenter: MorePresenterProtocol? { get set }
}

// MARK: View -
protocol MoreViewProtocol: class {

  var presenter: MorePresenterProtocol? { get set }
}
