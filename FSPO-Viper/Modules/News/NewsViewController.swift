//
//  NewsViewController.swift
//  FSPO-Viper
//
//  Created Николай Борисов on 06/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit
import LayoutKit
import Cache

class NewsViewController: UIViewController, NewsViewProtocol {

    var dataSource = [JSONDecoding.NewsApi.News]()
    var offset = 0
    var countAll: Int?

    func showNews(source: [JSONDecoding.NewsApi.News]) {
        for item in source {
            dataSource.append(item)
        }
        DispatchQueue.main.async {
            self.reloadTableView(width: self.tableView.frame.width, synchronous: false)
        }
    }
    func showError(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
	var presenter: NewsPresenterProtocol?
    var reloadableViewLayoutAdapter: ReloadableViewLayoutAdapter!
    var tableView: UITableView!
	override func viewDidLoad() {
        super.viewDidLoad()
        /*storage?.async.object(forKey: "news", completion: { result in
            switch result {
            case .value(let data):
                if let decoded = try? JSONDecoder().decode(JSONDecoding.NewsApi.self, from: data) {
                    self.showNews(source: decoded.news)
                    self.presenter?.updateView(offset: 0, cache: decoded.news)
                } else {
                    self.presenter?.updateView(offset: 0, cache: nil)
                }
            case .error:
                self.presenter?.updateView(offset: 0, cache: nil)
            }
        })*/
        storage?.async.object(forKey: "news", completion: { result in
            switch result {
            case .value(let data):
                if let decoded = try? JSONDecoder().decode(JSONDecoding.NewsApi.self, from: data) {
                    self.showNews(source: decoded.news)
                    self.presenter?.updateView(offset: 0, cache: decoded.news)
                } else {
                     self.presenter?.updateView(offset: 0, cache: nil)
                }
            case .error:
                 self.presenter?.updateView(offset: 0, cache: nil)
            }
        })
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        reloadableViewLayoutAdapter = NewsReloadableViewLayoutAdapter(reloadableView: tableView)
        tableView.dataSource = reloadableViewLayoutAdapter
        tableView.delegate = reloadableViewLayoutAdapter
        tableView.separatorColor = .clear
        tableView.backgroundColor = UIColor.backgroundGray
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activity.startAnimating()
        activity.frame = CGRect(origin: .zero, size: CGSize(width: tableView.bounds.width, height: 44))
        tableView.tableFooterView = activity
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
        let newsVC = tableView.controller() as? NewsViewController
        if indexPath.row == newsVC!.dataSource.count - 1 {
            newsVC!.offset += 100
            if newsVC!.countAll == 0 {
                newsVC!.tableView.tableFooterView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 1, height: 1)))
            } else {
                newsVC!.presenter?.updateView(offset: newsVC!.offset, cache: nil)
            }
        }
    }
    /*func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        /*DispatchQueue.global(qos: .userInitiated).async {
            return NewsViewController.publicDS[indexPath.row].text.height(withConstrainedWidth: UIScreen.main.bounds.width, font: (UIFont.ITMOFont?.withSize(17))!) + 74
        }*/
        return NewsViewController.publicDS[indexPath.row].text.height(withConstrainedWidth: UIScreen.main.bounds.width, font: (UIFont.ITMOFont?.withSize(17))!) + 74
    }*/
}
