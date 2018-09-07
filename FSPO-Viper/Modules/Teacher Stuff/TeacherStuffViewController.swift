//
//  TeacherStuffViewController.swift
//  FSPO
//
//  Created Николай Борисов on 06/09/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class TeacherStuffViewController: UIViewController, TeacherStuffViewProtocol {

	var presenter: TeacherStuffPresenterProtocol?

	override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = UIRectEdge()
        let width = view.bounds.width
        DispatchQueue.global(qos: .userInteractive).async {
            let teacherStuffLayout = TeacherStuffLayout()
            let arrangement = teacherStuffLayout.arrangement(width: width)
            DispatchQueue.main.async(execute: {
                arrangement.makeViews(in: self.view)
            })
        }
        let arragment = TeacherStuffLayout().arrangement()
        arragment.makeViews(in: view)
    }
    @objc func studentsListUpInside() {
        print("list")
    }
}
