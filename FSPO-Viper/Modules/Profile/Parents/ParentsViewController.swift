//
//  ParentsViewController.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 27/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class ParentsViewController: UIViewController, ParentsViewProtocol {
	var presenter: ParentsPresenterProtocol?

	override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = UIRectEdge()
        presenter?.updateView()
    }
    func fillView(firstname: String, lastname: String, middlename: String, email: String, phone: String, photo: String) {
        let width = view.bounds.width
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            let profileLayout = ParentsLayout(firstname: firstname, lastname: lastname, middlename: middlename, email: email, phone: phone, photo: photo)
            let arrangement = profileLayout.arrangement(width: width)
            DispatchQueue.main.async(execute: {
                arrangement.makeViews(in: self.view)
            })
        }
    }
}
