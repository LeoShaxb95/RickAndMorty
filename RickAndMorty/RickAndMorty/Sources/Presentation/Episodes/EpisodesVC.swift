//
//  EpisodesVC.swift
//  RickAndMorty
//
//  Created by Levon Shaxbazyan on 18.11.23.
//

import UIKit
import Combine

class EpisodesVC: BaseVC {
    
    // MARK: - Properties
    
    private let presenter: EpisodesPresenterProtocol
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Subviews
    
    private var titleImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleToFill
        v.image = UIImage(named: "RickAndMorty")
        
        return v
    }()
    
    let searchTextField: UITextField = {
        let leftView = UIView(frame: CGRect(
            x: 0, y: 0, width: 50, height: 30))
        let iconImageView = UIImageView(frame: CGRect(
            x: 20, y: 5, width: 24, height: 24))
        iconImageView.image = UIImage(named: "SearchIcon")
        leftView.addSubview(iconImageView)
        
        let v = UITextField()
        v.placeholder = "Name or episode (ex.S01E01)..."
        v.font = .systemFont(ofSize: 16, weight: .regular)
        v.autocorrectionType = .no
        v.layer.borderColor = UIColor(hex: "#808080").cgColor
        v.layer.borderWidth = 1
        v.layer.cornerRadius = 8
        
        v.leftView = leftView
        v.leftViewMode = .always
        
        return v
    }()
    
    private var filtersButton: UIButton = {
        let v = UIButton()
        v.setTitle("ADVANCED FILTERS", for: .normal)
        v.setTitleColor(UIColor(hex: "#2196F3"), for: .normal)
        v.backgroundColor = UIColor(hex: "#E3F2FD")
        v.titleLabel?.font = .systemFont(ofSize: 14)
        v.layer.cornerRadius = 8
        
        return v
    }()
    
    private var filterIconButton: UIButton = {
        let v = UIButton()
        v.tintColor = UIColor(hex: "#E3F2FD")
        v.setImage(UIImage(named: "Filter"), for: .normal)
        
        return v
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        
        return UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
    }()

    
    // MARK: - Init
    
    init(presenter: EpisodesPresenter) {
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
            titleImageView,
            searchTextField,
            filtersButton,
            filterIconButton,
            collectionView
        ])
    }
    
    public override func setupAutolayout() {
        
        titleImageView.pin(edges: [.top], to: view, inset: -20, toSafeArea: true)
        titleImageView.pin(edges: [.leading, .trailing], to: view, inset: 30)
        searchTextField.pin(edges: [.leading, .trailing], to: view, inset: 30)
        filtersButton.pin(edges: [.leading, .trailing], to: view, inset: 30)
        collectionView.pin(edges: [.leading, .trailing], to: view, inset: 30)

        titleImageView.set(height: 104)
        searchTextField.set(height: 56)
        filtersButton.set(height: 56)
        filterIconButton.set(width: 20, height: 20)
       // collectionView.set(height: 720)

        NSLayoutConstraint.activate([
            titleImageView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            searchTextField.topAnchor.constraint(
                equalTo: titleImageView.bottomAnchor, constant: 50),
            filtersButton.topAnchor.constraint(
                equalTo: searchTextField.bottomAnchor, constant: 20),
            filterIconButton.centerYAnchor.constraint(
                    equalTo: filtersButton.centerYAnchor),
            filterIconButton.leadingAnchor.constraint(
                    equalTo: filtersButton.leadingAnchor, constant: 20),
            collectionView.topAnchor.constraint(
                    equalTo: filtersButton.bottomAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(
                    equalTo: view.bottomAnchor, constant: -20),
    
        ])
        
        collectionView.layer.cornerRadius = 4
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

extension EpisodesVC: UICollectionViewDataSource {
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
    
        return cell
    }
    
}

extension EpisodesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height: CGFloat = 360

        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 60
    }
}
