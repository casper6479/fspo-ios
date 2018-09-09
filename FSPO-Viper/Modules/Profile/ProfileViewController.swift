//
//  ProfileViewController.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, ProfileViewProtocol {
	var presenter: ProfilePresenterProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = UIRectEdge()
        let settingButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        settingButton.setImage(UIImage(named: "settings"), for: .normal)
        settingButton.addTarget(self, action: #selector(setNeedsShowSettings), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingButton)
        storage?.async.object(forKey: "profile", completion: { result in
            switch result {
            case .value(let data):
                if let decoded = try? JSONDecoder().decode(JSONDecoding.ProfileApi.self, from: data) {
                    DispatchQueue.main.async {
                        self.fillView(data: decoded)
                    }
                    self.presenter?.updateView(cache: decoded)
                } else {
                    self.presenter?.updateView(cache: nil)
                }
            case .error:
                self.presenter?.updateView(cache: nil)
            }
        })
    }
    func fillView(data: JSONDecoding.ProfileApi) {
        let width = view.bounds.width
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            let profileLayout = ProfileLayout(data: data)
            let arrangement = profileLayout.arrangement(width: width)
            DispatchQueue.main.async(execute: {
                arrangement.makeViews(in: self.view)
            })
        }
    }
    func show(vc: UIViewController) {
        navigationController?.show(vc, sender: self)
    }
    @objc func setNeedsShowSettings() {
        presenter?.showSettings()
    }
    @objc func setNeedsShowParents() {
        presenter?.showParents()
    }
}
