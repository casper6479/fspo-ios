//
//  Protocols.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 21/06/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation
import UIKit

protocol PresenterToViewProtocol: class{
    func showNews(news: LiveNewsModel);
    func showError();
}

protocol InterectorToPresenterProtocol: class{
    func liveNewsFetched(news: LiveNewsModel);
    func liveNewsFetchedFailed();
}

protocol PresentorToInterectorProtocol: class{
    var presenter: InterectorToPresenterProtocol? {get set} ;
    func fetchLiveNews();
}

protocol ViewToPresenterProtocol: class{
    var view: PresenterToViewProtocol? {get set};
    var interector: PresentorToInterectorProtocol? {get set};
    var router: PresenterToRouterProtocol? {get set}
    func updateView();
}

protocol PresenterToRouterProtocol: class{
    static func createModule() -> UIViewController;
}
