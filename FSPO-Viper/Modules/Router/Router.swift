//
//  Router.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 21/06/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation
import UIKit

class LiveNewsRouter: PresenterToRouterProtocol{
    
    class func createModule() ->UIViewController{
        let view = mainstoryboard.instantiateViewController(withIdentifier: "LiveNewsViewController") as? LiveNewsViewController;
        //if let view = navController.childViewControllers.first as? LiveNewsViewController {
        let presenter: ViewToPresenterProtocol & InterectorToPresenterProtocol = LiveNewsPresenter();
        let interactor: PresentorToInterectorProtocol = LiveNewsInterector();
        let router: PresenterToRouterProtocol = LiveNewsRouter();
        
        view?.presenter = presenter;
        presenter.view = view;
        presenter.router = router;
        presenter.interector = interactor;
        interactor.presenter = presenter;
        
        return view!;
        
        //}
        
        //return UIViewController()
    }
    
    static var mainstoryboard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
}
