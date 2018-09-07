//
//  JournalViewController.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import Cache

class JournalViewController: UIViewController, JournalViewProtocol, UITextFieldDelegate {

	var presenter: JournalPresenterProtocol?

	override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        edgesForExtendedLayout = UIRectEdge()
        let clearData = JSONDecoding.JournalApi(avg_score: -1, debts: -1, visits: -1)
        storage?.async.object(forKey: "journal", completion: { result in
            switch result {
            case .value(let data):
                if let decoded = try? JSONDecoder().decode(JSONDecoding.JournalApi.self, from: data) {
                    DispatchQueue.main.async {
                        self.fillView(data: decoded)
                    }
                    self.presenter?.updateView(cache: decoded)
                } else {
                    DispatchQueue.main.async {
                        self.fillView(data: clearData)
                    }
                    self.presenter?.updateView(cache: nil)
                }
            case .error:
                DispatchQueue.main.async {
                    self.fillView(data: clearData)
                }
                self.presenter?.updateView(cache: nil)
            }
        })
    }
    func fillView(data: JSONDecoding.JournalApi) {
        let width = view.bounds.width
        DispatchQueue.global(qos: .userInteractive).async {
            var journalLayout = JournalLayout(
                dolgs: "\(data.debts)",
                percent: "\(data.visits) %",
                score: "\(data.avg_score)"
            )
            if data.debts == -1 && data.visits == -1 && data.avg_score == -1 {
                journalLayout = JournalLayout(
                    dolgs: "",
                    percent: "",
                    score: ""
                )
            }
            let arrangement = journalLayout.arrangement(width: width)
            DispatchQueue.main.async(execute: {
                arrangement.makeViews(in: self.view)
            })
        }
    }
    func show(vc: UIViewController) {
        self.navigationController?.show(vc, sender: self)
    }
    @objc func setNeedsShowByDate() {
        presenter?.showByDate()
    }
    @objc func setNeedsShowBySubject() {
        presenter?.showBySubject()
    }
    @objc func setNeedsShowMore() {
        presenter?.showMore()
    }
}
