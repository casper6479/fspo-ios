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
    func showNews(source: [JSONDecoding.NewsApi.News]) {
        arr = source
        self.layoutFeed(width: tableView.frame.width, synchronous: false)
    }
	var presenter: NewsPresenterProtocol?
    private var reloadableViewLayoutAdapter: ReloadableViewLayoutAdapter!
    private var tableView: UITableView!
	override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.updateView()
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        reloadableViewLayoutAdapter = NewsReloadableViewLayoutAdapter(reloadableView: tableView)
        tableView.dataSource = reloadableViewLayoutAdapter
        tableView.delegate = reloadableViewLayoutAdapter
        tableView.separatorColor = .clear
        tableView.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        view.addSubview(tableView)
    }
    private var cachedFeedItems: [Layout]?
    var arr = [JSONDecoding.NewsApi.News]()
    func getFeedItems() -> [Layout] {
        var layouts = [Layout]()
        for item in arr {
            layouts.append(NewsPostLayout(body: item.text, time: DateToString().formatDate(item.ndatetime)))
        }
        return layouts
    }
    private func layoutFeed(width: CGFloat, synchronous: Bool) {
        reloadableViewLayoutAdapter.reloading(width: width, synchronous: synchronous, layoutProvider: { [weak self] in
            return [Section(header: nil, items: self?.getFeedItems() ?? [], footer: nil)]
        })
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        layoutFeed(width: size.width, synchronous: true)
    }
}
