//
//  DialogProtocols.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 05/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

//MARK: Wireframe -
protocol DialogWireframeProtocol: class {

}
//MARK: Presenter -
protocol DialogPresenterProtocol: class {

}

//MARK: Interactor -
protocol DialogInteractorProtocol: class {

  var presenter: DialogPresenterProtocol?  { get set }
}

//MARK: View -
protocol DialogViewProtocol: class {

  var presenter: DialogPresenterProtocol?  { get set }
}
