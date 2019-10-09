//
//  ArticlesListViewController.swift
//  GoTArticlesExample
//
//  Created by Kamil Buczel on 17/09/2019.
//  Copyright © 2019 Kamajabu. All rights reserved.
//

import EasyPeasy
import RxCocoa
import RxSwift
import UIKit

protocol ArticlesListViewControllerDelegate: class {
    func didSelectArticle(_ selectedArticle: ArticleViewModel)
}

class ArticlesListViewController: UIViewController {
    private let viewModel: ArticlesListViewModel
    private let disposeBag = DisposeBag()
    private weak var delegate: ArticlesListViewControllerDelegate?

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none

        tableView.delegate = self
        tableView.dataSource = self

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.register(ArticlesListCell.self,
                           forCellReuseIdentifier: ArticlesListCell.reuseIdentifier)

        return tableView
    }()

    private lazy var favouriteSwitch: UISwitch = {
        let favouriteSwitch = UISwitch()
        favouriteSwitch.onTintColor = .red
        return favouriteSwitch
    }()

    private var filterLabel: UILabel = {
        let label = UILabel()
        label.text = "only favourites"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    init(viewModel: ArticlesListViewModel, delegate: ArticlesListViewControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate

        super.init(nibName: nil, bundle: nil)

        viewModelOutput()
        viewModelInput()
    }

    private func viewModelInput() {
        favouriteSwitch.rx.isOn
            .asObservable()
            .bind(to: viewModel.isFiltrationOn)
            .disposed(by: disposeBag)
    }

    private func viewModelOutput() {
        viewModel
            .articlesListSingle
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] _ in
                self?.tableView.reloadData()
            }, onError: { [weak self] error in
                let alert = UIAlertController(title: "Fetching data failed",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))

                self?.present(alert, animated: true, completion: nil)
            }).disposed(by: disposeBag)

        viewModel.isFiltrationOn.subscribe(onNext: { [weak self] _ in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        view.backgroundColor = .white

        view.addSubview(favouriteSwitch)
        favouriteSwitch.easy.layout(
            Top(6).to(view.safeAreaLayoutGuide, .top),
            Left(6).to(view.safeAreaLayoutGuide, .left),
            Height(30), Width(50)
        )

        view.addSubview(filterLabel)
        filterLabel.easy.layout(Left(8).to(favouriteSwitch),
                                CenterY().to(favouriteSwitch))

        view.addSubview(tableView)
        tableView.easy.layout(
            Top(10).to(favouriteSwitch), Left(), Right(), Bottom()
        )
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ArticlesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.articlesCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticlesListCell.reuseIdentifier,
                                                       for: indexPath as IndexPath) as? ArticlesListCell else {
            return UITableViewCell()
        }

        guard let viewModel = viewModel.articleViewModel(for: indexPath.row) else {
            return UITableViewCell()
        }

        cell.setup(with: viewModel, delegate: self)

        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel.articleViewModel(for: indexPath.row) else {
            return
        }

        delegate?.didSelectArticle(viewModel)
    }
}

extension ArticlesListViewController: CellDelegate {
    func stateDidChange() {
        tableView.reloadData()
    }

    func contentDidChange() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
