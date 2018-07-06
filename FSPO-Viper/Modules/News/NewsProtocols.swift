//
//  NewsProtocols.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

//MARK: Wireframe -
protocol NewsWireframeProtocol: class {

}
//MARK: Presenter -
protocol NewsPresenterProtocol: class {

}

//MARK: Interactor -
protocol NewsInteractorProtocol: class {

  var presenter: NewsPresenterProtocol?  { get set }
}

//MARK: View -
protocol NewsViewProtocol: class {

  var presenter: NewsPresenterProtocol?  { get set }
}