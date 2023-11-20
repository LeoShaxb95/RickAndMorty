//
//  FavoritesVC.swift
//  RickAndMorty
//
//  Created by Levon Shaxbazyan on 20.11.23.
//

import UIKit
import Combine

final class FavoritesVC: BaseVC {

    // MARK: - Subviews
    
    private var favoritesTitleLabel: UILabel = {
        let v = UILabel()
        v.text = "Favourites episodes"
        v.font = .systemFont(ofSize: 24, weight: .semibold)
        v.textColor = UIColor(hex: "#000000")
        v.textAlignment = .center
        
        return v
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        return UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
    }()
    
    private let presenter: FavoritesPresenterProtocol
    var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init(presenter: FavoritesPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setupSubviews()
        bind()
        collectionViewConfigurations()

    }

    // MARK: - Bind

    public override func bind() {
        
    }

    // MARK: - Setup

    public override func setupSubviews() {
        view.addSubviews([
            favoritesTitleLabel,
            collectionView
        ])
    }

    public override func setupAutolayout() {

        favoritesTitleLabel.pin(edges: [.top], to: view, inset: 0, toSafeArea: true)
        favoritesTitleLabel.pin(edges: [.leading, .trailing], to: view, inset: 30)
        collectionView.pin(edges: [.leading, .trailing], to: view, inset: 30)

        favoritesTitleLabel.set(height: 30)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(
                    equalTo: favoritesTitleLabel.bottomAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(
                    equalTo: view.bottomAnchor, constant: -20),
        ])
    }

    // MARK: - Other funcs
    
    private func collectionViewConfigurations() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(EpisodesCollectionViewCell.self, forCellWithReuseIdentifier: EpisodesCollectionViewCell.identifier)
    }

    // MARK: Callbacks

}

extension FavoritesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EpisodesCollectionViewCell.identifier,
            for: indexPath) as? EpisodesCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.imageView.image = UIImage(named: "profileImage")
        cell.nameLabel.text = "Rick Sanchez"
        cell.episodeFavoriteButton.setImage(UIImage(named: "FavoriteFill"),
                                            for: .normal)
    
        return cell
    }
    
}

extension FavoritesVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter.moveToCharacterDetailsScreen()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height: CGFloat = 360

        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 60
    }
}


