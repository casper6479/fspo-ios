//
//  IdentityRequestProtocols.swift
//  FSPO
//
//  Created Николай Борисов on 14/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation

// MARK: Wireframe -
protocol IdentityRequestWireframeProtocol: class {

}
// MARK: Presenter -
protocol IdentityRequestPresenterProtocol: class {

}

// MARK: Interactor -
protocol IdentityRequestInteractorProtocol: class {

  var presenter: IdentityRequestPresenterProtocol? { get set }
}

// MARK: View -
protocol IdentityRequestViewProtocol: class {

  var presenter: IdentityRequestPresenterProtocol? { get set }
}
