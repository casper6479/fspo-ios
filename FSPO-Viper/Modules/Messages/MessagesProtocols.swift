//
//  MessagesProtocols.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

// MARK: Wireframe -
protocol MessagesWireframeProtocol: class {

}
// MARK: Presenter -
protocol MessagesPresenterProtocol: class {

}

// MARK: Interactor -
protocol MessagesInteractorProtocol: class {

  var presenter: MessagesPresenterProtocol? { get set }
}

// MARK: View -
protocol MessagesViewProtocol: class {

  var presenter: MessagesPresenterProtocol? { get set }
}
