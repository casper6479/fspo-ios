//
//  NewsViewController.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 21/06/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

class LiveNewsViewController: UIViewController {
    
    var presenter: ViewToPresenterProtocol?
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        presenter?.updateView();
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
}

extension LiveNewsViewController: PresenterToViewProtocol {
    
    func showNews(news: LiveNewsModel) {
        authorLabel.text = news.author;
        titleLabel.text = news.title;
        descriptionLabel.text = news.description;
    }
    
    func showError() {
        let alert = UIAlertController(title: "Alert", message: "Problem Fetching News", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
