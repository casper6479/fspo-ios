//
//  JournalByDateProtocols.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 27/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

// MARK: Wireframe -
protocol JournalByDateWireframeProtocol: class {

}
// MARK: Presenter -
protocol JournalByDatePresenterProtocol: class {

}

// MARK: Interactor -
protocol JournalByDateInteractorProtocol: class {

  var presenter: JournalByDatePresenterProtocol? { get set }
}

// MARK: View -
protocol JournalByDateViewProtocol: class {

  var presenter: JournalByDatePresenterProtocol? { get set }
}
