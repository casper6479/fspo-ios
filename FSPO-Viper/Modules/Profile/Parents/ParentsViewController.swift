//
//  ParentsViewController.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 27/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class ParentsViewController: UIViewController, ParentsViewProtocol {

	var presenter: ParentsPresenterProtocol?

	override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = UIRectEdge()
        let width = view.bounds.width
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            let profileLayout = ParentsLayout(firstname: "Батя", lastname: "Борисов", middlename: "Батькевич", email: "test@vk.com", phone: "8-800-555-35-35", photo: UIImage(named: "logo")!)
            let arrangement = profileLayout.arrangement(width: width)
            DispatchQueue.main.async(execute: {
                arrangement.makeViews(in: self.view)
            })
        }
    }

}
