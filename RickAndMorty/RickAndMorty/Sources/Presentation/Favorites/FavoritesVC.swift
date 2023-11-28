//
//  FavoritesVC.swift
//  RickAndMorty
//
//  Created by Levon Shaxbazyan on 20.11.23.
//

import UIKit
import Combine

final class FavoritesVC: BaseVC {
    
    // MARK: - Properties

    private let cacheManager: CacheManagerProtocol
    private var customData: [Custom]? = []

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

    init(presenter: FavoritesPresenterProtocol, cacheManager: CacheManagerProtocol) {
        self.presenter = presenter
        self.cacheManager = cacheManager
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchCustomData()
        
    }

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
    
    private func fetchCustomData() {
        self.customData = []
        guard let favorites = cacheManager.loadArray(withFileName: "favorites")
            else { return }
        
        if let cachedEpisodes = cacheManager.loadObject(
            forKey: "customData", type: [Custom].self) as? [Custom] {
            for results in cachedEpisodes {
                if favorites.contains(results.episodeNumber) {
                    guard let data = customData else { return }
                    var contains = false
                    for element in data {
                        if element.episodeNumber == results.episodeNumber {
                            contains = true
                        }
                    }
                    if !contains {
                        self.customData?.append(results)
                    }
                }
                print("results is \(results)")
                print("custom is \(customData)")
            }
            
        }
        collectionView.reloadData()
    }

    // MARK: Callbacks

}

extension FavoritesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.customData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EpisodesCollectionViewCell.identifier,
            for: indexPath) as? EpisodesCollectionViewCell
        else { return UICollectionViewCell() }
        
        var characterImage = cacheManager.loadImage(forKey: self.customData?[indexPath.row].characterName ?? "")
        
        if let data = self.customData {
            cell.configure(
                episodeName: data[indexPath.row].episodeName,
                episodeNumber: data[indexPath.row].episodeNumber,
                characterImage: characterImage,
                characterName: data[indexPath.row].characterName
            )
            cell.episodeFavoriteButton.setImage(UIImage(named: "FavoriteFill"),
                                                for: .normal)
        }
        

    
        return cell
    }
    
}

extension FavoritesVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = self.customData
            else { return }
        
        self.presenter.moveToCharacterDetailsScreen(model[indexPath.row])
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


