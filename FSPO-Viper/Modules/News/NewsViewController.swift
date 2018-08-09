//
//  NewsViewController.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import LayoutKit

class NewsViewController: UIViewController, NewsViewProtocol {
    var dataSource = [JSONDecoding.NewsApi.News]()
    static var publicDS = [JSONDecoding.NewsApi.News]()
    func showNews(source: [JSONDecoding.NewsApi.News]) {
        dataSource = source
        NewsViewController.publicDS = source
        self.reloadTableView(width: tableView.frame.width, synchronous: false)
    }
    func showError(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
	var presenter: NewsPresenterProtocol?
    var reloadableViewLayoutAdapter: ReloadableViewLayoutAdapter!
    var tableView: UITableView!
	override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.updateView()
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        reloadableViewLayoutAdapter = NewsReloadableViewLayoutAdapter(reloadableView: tableView)
        tableView.dataSource = reloadableViewLayoutAdapter
        tableView.delegate = reloadableViewLayoutAdapter
        tableView.separatorColor = .clear
        tableView.backgroundColor = UIColor.backgroundGray
        view.addSubview(tableView)
    }
    func getNewsRows() -> [Layout] {
        var layouts = [Layout]()
        for item in dataSource {
            layouts.append(NewsPostLayout(body: item.text, time: DateToString().formatDateNews(item.ndatetime)))
        }
        return layouts
    }
    func reloadTableView(width: CGFloat, synchronous: Bool) {
        reloadableViewLayoutAdapter.reloading(width: width, synchronous: synchronous, layoutProvider: { [weak self] in
            return [Section(
                header: nil,
                items: self?.getNewsRows() ?? [],
                footer: nil)]
        })
    }
}
extension NewsReloadableViewLayoutAdapter {
    /*func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        /*DispatchQueue.global(qos: .userInitiated).async {
            return NewsViewController.publicDS[indexPath.row].text.height(withConstrainedWidth: UIScreen.main.bounds.width, font: (UIFont.ITMOFont?.withSize(17))!) + 74
        }*/
        return NewsViewController.publicDS[indexPath.row].text.height(withConstrainedWidth: UIScreen.main.bounds.width, font: (UIFont.ITMOFont?.withSize(17))!) + 74
    }*/
}
