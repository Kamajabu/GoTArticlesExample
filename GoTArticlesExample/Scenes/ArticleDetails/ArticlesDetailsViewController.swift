//
//  ArticlesDetailsViewController.swift
//  GoTArticlesExample
//
//  Created by Kamil Buczel on 19/09/2019.
//  Copyright © 2019 Kamajabu. All rights reserved.
//

import EasyPeasy
import Foundation
import RxGesture
import RxSwift
import UIKit

class ArticlesDetailsViewController: UIViewController {
    private let viewModel: ArticleViewModel
    private let disposeBag = DisposeBag()

    private lazy var thumbnailImage: UIImageView = {
        let thumbnail = UIImageView()
        thumbnail.image = UIImage(named: SharedImages.placeholder)
        thumbnail.contentMode = .scaleAspectFill
        thumbnail.clipsToBounds = true
        return thumbnail
    }()

    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 20)
        descriptionLabel.textAlignment = .left
        descriptionLabel.contentMode = .topLeft
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = viewModel.details
        return descriptionLabel
    }()

    private lazy var favouriteIcon: UIImageView = {
        let heartIcon = UIImageView()
        heartIcon.image = UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate)
        heartIcon.tintColor = viewModel.isFavourite ?
            SharedColors.enabledFavourite : SharedColors.disabledFavourite
        return heartIcon
    }()

    private lazy var openArticleButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.setTitle("Open Article", for: .normal)
        return button
    }()

    init(viewModel: ArticleViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        viewModel.articleThumbnailSingle
            .map { imageData in
                UIImage(data: imageData)
            }
            .asDriver(onErrorJustReturn: UIImage(named: SharedImages.unexpectedErrorImage))
            .drive(thumbnailImage.rx.image)
            .disposed(by: disposeBag)

        openArticleButton.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                guard let url = viewModel.articleAddress else {
                    return
                }
                UIApplication.shared.open(url)
            }).disposed(by: disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        view.backgroundColor = .white

        title = viewModel.title

        view.addSubview(thumbnailImage)
        thumbnailImage.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Left(),
            Right(),
            Height(200)
        )

        thumbnailImage.addSubview(favouriteIcon)
        favouriteIcon.easy.layout(
            Top(10),
            Right(10),
            Size(40)
        )

        view.addSubview(descriptionLabel)
        descriptionLabel.easy.layout(
            Top(10).to(thumbnailImage),
            Left(10),
            Right(10)
        )

        view.addSubview(openArticleButton)
        openArticleButton.easy.layout(
            Top(10).to(descriptionLabel),
            Bottom(<=10),
            Width(120),
            Height(50),
            CenterX()
        )
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
