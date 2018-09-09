//
//  SearchViewController.swift
//  FSPO
//
//  Created Николай Борисов on 06/09/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import LayoutKit
import Lottie

class SearchViewController: UIViewController, SearchViewProtocol, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        presenter?.updateView(query: searchController.searchBar.text!)
    }
    var publicDS: JSONDecoding.SearchAPI?
    func showNewRows(source: JSONDecoding.SearchAPI) {
        publicDS = source
        if source.students.count != 0 || source.teachers.count != 0 {
            hideEmptyView(completion: {
                DispatchQueue.main.async {
                    self.reloadTableView(width: self.tableView.frame.width, synchronous: false, data: source)
                }
            })
        } else {
            showEmptyView()
            DispatchQueue.main.async {
                self.reloadTableView(width: self.tableView.frame.width, synchronous: false, data: source)
            }
        }
    }
	var presenter: SearchPresenterProtocol?
    private var reloadableViewLayoutAdapter: ReloadableViewLayoutAdapter!
    private var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    let emptyView = LOTAnimationView(name: "empty")
	override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Поиск", comment: "")
        view.backgroundColor = .backgroundGray
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        reloadableViewLayoutAdapter = SearchReloadableLayoutAdapter(reloadableView: tableView)
        tableView.dataSource = reloadableViewLayoutAdapter
        tableView.delegate = reloadableViewLayoutAdapter
        tableView.separatorColor = .clear
        tableView.backgroundColor = .backgroundGray
        view.addSubview(tableView)
        emptyView.frame = tableView.bounds
        emptyView.frame.origin.y -= 90
        emptyView.loopAnimation = true
        let emptyText = UILabel(frame: CGRect(x: 8, y: emptyView.frame.height / 4, width: view.bounds.width - 16, height: 20))
        emptyText.frame.origin.y += 20
        emptyText.text = NSLocalizedString("Не найдено", comment: "")
        emptyText.font = UIFont.ITMOFontBold?.withSize(15)
        emptyText.textColor = UIColor(red: 171/255, green: 171/255, blue: 194/255, alpha: 1)
        emptyText.textAlignment = .center
        emptyView.play()
        emptyView.isUserInteractionEnabled = false
        emptyView.contentMode = .scaleAspectFit
        tableView.addSubview(emptyView)
        emptyView.addSubview(emptyText)
        searchController.searchResultsUpdater = self
        searchController.searchBar.barTintColor = .ITMOBlue
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barStyle = .blackTranslucent
        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        }
        definesPresentationContext = true
        self.extendedLayoutIncludesOpaqueBars = true
        presenter?.updateView(query: "")
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
    }
    func showEmptyView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.emptyView.alpha = 1
        })
    }
    func hideEmptyView(completion: @escaping() -> Void) {
        UIView.animate(withDuration: 0.2, animations: {
            self.emptyView.alpha = 0
        }, completion: { _ in
            completion()
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11, *) {
            if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
                textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                if let leftView = textfield.leftView as? UIImageView {
                    leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                    leftView.tintColor = UIColor.white
                }
            }
        }
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    func getHeader(lesson: String) -> Layout {
        let layouts = HeaderLayout(text: lesson, inset: 15)
        return layouts
    }
    func getNewRows(data: JSONDecoding.SearchAPI) -> [Section<[Layout]>] {
        var students = [Layout]()
        var teachers = [Layout]()
        var sections = [Section<[Layout]>]()
        if data.teachers.count != 0 {
            for item in data.teachers {
                teachers.append(SearchLayout(firstname: item.firstname, lastname: item.lastname, middlename: item.middlename, photo: item.photo))
            }
            sections.append(Section(header: getHeader(lesson: NSLocalizedString("Преподаватели", comment: "")), items: teachers, footer: nil))
        }
        if data.students.count != 0 {
            for item in data.students {
                students.append(SearchLayout(firstname: item.firstname, lastname: item.lastname, middlename: item.middlename, photo: item.photo))
            }
            sections.append(Section(header: getHeader(lesson: NSLocalizedString("Студенты", comment: "")), items: students, footer: nil))
        }
        return sections
    }
    private func reloadTableView(width: CGFloat, synchronous: Bool, data: JSONDecoding.SearchAPI) {
        reloadableViewLayoutAdapter.reloading(width: width, synchronous: synchronous, layoutProvider: { [weak self] in
            return self!.getNewRows(data: data)
            })
    }
}
