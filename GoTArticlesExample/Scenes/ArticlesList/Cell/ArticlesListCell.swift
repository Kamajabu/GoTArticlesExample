//
//  ArticlesListCell.swift
//  GoTArticlesExample
//
//  Created by Kamil Buczel on 17/09/2019.
//  Copyright © 2019 Kamajabu. All rights reserved.
//

import EasyPeasy
import Foundation
import RxGesture
import RxSwift
import UIKit

protocol CellDelegate: class {
    func contentDidChange()
    func stateDidChange()
}

class ArticlesListCell: UITableViewCell {
    private let margin: CGFloat = 10

    private weak var cellDelegate: CellDelegate?
    private var viewModel: ArticleViewModel?
    private var disposeBag = DisposeBag()

    private lazy var thumbnailImage: UIImageView = {
        let thumbnail = UIImageView()
        thumbnail.image = UIImage(named: SharedImages.placeholder)

        // I'm fully aware this results in gallery of chins images in horizontal orientation ;)
        // Didn't want to spend too much time on this, as it seems not to be crucial part.
        thumbnail.contentMode = .scaleAspectFit
        return thumbnail
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        return titleLabel
    }()

    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 20)
        descriptionLabel.textAlignment = .left
        descriptionLabel.contentMode = .topLeft
        descriptionLabel.numberOfLines = 2
        return descriptionLabel
    }()

    private lazy var favouriteIcon: UIImageView = {
        let heartIcon = UIImageView()
        heartIcon.image = UIImage(named: SharedImages.heartIcon)?.withRenderingMode(.alwaysTemplate)
        heartIcon.tintColor = SharedColors.disabledFavourite
        return heartIcon
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        translatesAutoresizingMaskIntoConstraints = false
        configure()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()

        // I assume that there is no need to remember state of description being extended
        descriptionLabel.numberOfLines = 2
        thumbnailImage.image = UIImage(named: SharedImages.placeholder)

        favouriteIcon.tintColor = SharedColors.disabledFavourite
    }

    func setup(with viewModel: ArticleViewModel, delegate: CellDelegate) {
        self.viewModel = viewModel
        cellDelegate = delegate

        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.details

        sendActions(to: viewModel)
        updateState(from: viewModel)
    }

    private func configure() {
        contentView.layer.borderWidth = 1

        selectionStyle = .none

        contentView.addSubview(thumbnailImage)
        thumbnailImage.easy.layout(Top(margin),
                                   Left(margin),
                                   Bottom(<=margin),
                                   Size(100))

        contentView.addSubview(favouriteIcon)
        favouriteIcon.easy.layout(Top(margin),
                                  Right(margin),
                                  Size(30))

        contentView.addSubview(titleLabel)
        titleLabel.easy.layout(
            Left(margin).to(thumbnailImage),
            Right(margin).to(favouriteIcon),
            Top(margin).to(contentView),
            Height().like(favouriteIcon)
        )

        contentView.addSubview(descriptionLabel)
        descriptionLabel.easy.layout(Top().to(titleLabel),
                                     Left(margin).to(thumbnailImage),
                                     Bottom(<=margin),
                                     Right(margin))
    }

    private func sendActions(to viewModel: ArticleViewModel) {
        descriptionLabel.rx.longPressGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                viewModel.updateDetailsVisibility()
                self?.cellDelegate?.contentDidChange()
            }).disposed(by: disposeBag)

        favouriteIcon.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                viewModel.updateFavourite()
                self?.cellDelegate?.stateDidChange()
            }).disposed(by: disposeBag)
    }

    private func updateState(from viewModel: ArticleViewModel) {
        viewModel.articleThumbnailSingle
            .map { imageData in
                UIImage(data: imageData)
            }.asDriver(onErrorJustReturn: UIImage(named: SharedImages.unexpectedErrorImage))
            .drive(thumbnailImage.rx.image)
            .disposed(by: disposeBag)

        // Consider adding own rx extension to number of lines
        viewModel.detailsExtendedDriver
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isExtended in
                let numberOfLines = isExtended ? 0 : 2
                self?.descriptionLabel.numberOfLines = numberOfLines
            }).disposed(by: disposeBag)

        viewModel.isFavouriteDriver
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isFavourite in
                guard let self = self else {
                    return
                }

                self.favouriteIcon.tintColor = isFavourite ?
                    SharedColors.enabledFavourite : SharedColors.disabledFavourite
            }).disposed(by: disposeBag)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
