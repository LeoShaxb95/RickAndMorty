//
//  EpisodesCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Levon Shaxbazyan on 18.11.23.
//

import UIKit

protocol EpisodesCollectionViewCellDelegate: AnyObject {
    func didTapFavoriteButton(in cell: EpisodesCollectionViewCell)
}

class EpisodesCollectionViewCell: UICollectionViewCell {
    
    enum FavoriteButtonState {
        case checked
        case unchecked
    }
    
    static let identifier = "EpisodesCollectionViewCell"
    private var favoriteButtonState: FavoriteButtonState = .unchecked
    weak var delegate: EpisodesCollectionViewCellDelegate?
    
    // MARK: - Subviews
    
    lazy var mainView: UIView = {
        let v = UIView()
        v.isUserInteractionEnabled = true
        
        return v
    }()
    
    let imageView: UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 14
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFill
        
        return v
    }()
    
    lazy var nameStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.alignment = .fill
        v.distribution = .fill
        
        return v
    }()
    
    lazy var paddingView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        
        return v
    }()

    let nameLabel: UILabel = {
        let v = UILabel()
        v.backgroundColor = .white
        v.textColor = UIColor(hex: "#1A1A1A")
        v.font = .systemFont(ofSize: 20, weight: .semibold)

        return v
    }()
    
    lazy var episodeCardView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#F9F9F9")
        v.layer.cornerRadius = 16
        v.isUserInteractionEnabled = true
        
        return v
    }()
    
    let episodePlayButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(named: "Play"), for: .normal)
        v.tag = 0

        return v
    }()
    
    let episodeNameLabel: UILabel = {
        let v = UILabel()
        v.text = "Pilot | S01E01"

        return v
    }()
    
    let episodeFavoriteButton: UIButton = {
        let v = UIButton()
        v.tag = 1
        v.setImage(UIImage(named: "FavoriteEmpty"), for: .normal)
        v.isUserInteractionEnabled = true
        v.isEnabled = true
        v.addTarget(self, action: #selector(didTapFavoriteButton),
                    for: .touchUpInside)

        return v
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        configureSubviews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupShadow()
    }

    // MARK: - Helpers
    
    private func setupSubviews() {
        contentView.addSubview(mainView)
        contentView.addSubview(episodeFavoriteButton)
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = UIColor(hex: "#FAFAFA")
        
        mainView.addSubviews([
            imageView,
            nameStackView,
            episodeCardView,
        ])
        
        nameStackView.addArrangedSubviews([
            paddingView,
            nameLabel
        ])
        
        episodeCardView.addSubviews([
            episodePlayButton,
            episodeNameLabel
        ])
        
        
    }

    private func configureSubviews() {
        
        mainView.pin(to: contentView)
        imageView.pin(edges: [.top, .leading, .trailing], to: contentView)
        nameStackView.pin(edges: [.leading, .trailing], to: contentView)
        episodeCardView.pin(edges: [.leading, .trailing], to: contentView)
        
        episodePlayButton.translatesAutoresizingMaskIntoConstraints = false
        episodeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        episodeFavoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameStackView.topAnchor.constraint(
                equalTo: imageView.bottomAnchor, constant: 10),
            episodeCardView.topAnchor.constraint(
                equalTo: nameLabel.bottomAnchor, constant: 10),
            episodePlayButton.leadingAnchor.constraint(
                equalTo: episodeCardView.leadingAnchor, constant: 20),
            episodePlayButton.centerYAnchor.constraint(
                equalTo: episodeCardView.centerYAnchor),
            
            episodeNameLabel.leadingAnchor.constraint(
                equalTo: episodePlayButton.trailingAnchor, constant: 10),
            episodeNameLabel.centerYAnchor.constraint(
                equalTo: episodeCardView.centerYAnchor),
            
            episodeFavoriteButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -20),
            episodeFavoriteButton.centerYAnchor.constraint(
                equalTo: episodePlayButton.centerYAnchor)
        ])
        
        paddingView.set(width: 30)
        nameLabel.set(height: 50)
        episodeCardView.set(height: 50)
        episodePlayButton.set(width: 34, height: 34)
        episodeNameLabel.set(width: 150, height: 34)
        episodeFavoriteButton.set(width: 40, height: 40)
        
        episodeCardView.layer.cornerRadius = 16

    }
    
    // MARK: - Other func
    
    private func setupShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 0, height: 4)

        let shadowPath = UIBezierPath()
        shadowPath.move(to: CGPoint(
            x: 0, y: self.bounds.height))
        shadowPath.addLine(to: CGPoint(
            x: self.bounds.width, y: self.bounds.height))
        shadowPath.addLine(to: CGPoint(
            x: self.bounds.width, y: self.bounds.height - 4))
        shadowPath.addLine(to: CGPoint(
            x: 0, y: self.bounds.height - 4))
        shadowPath.close()

        self.layer.shadowPath = shadowPath.cgPath
    }
    
    // MARK: - CallBacks
    
    @objc func didTapFavoriteButton(sender: UIButton) {
        delegate?.didTapFavoriteButton(in: self)
        var imageName = ""
        
        switch favoriteButtonState {
        case .checked:
            imageName = "FavoriteEmpty"
            favoriteButtonState = .unchecked
        case .unchecked:
            imageName = "FavoriteFill"
            favoriteButtonState = .checked
        }
        
        var image = UIImage(named: imageName)
        episodeFavoriteButton.setImage(image, for: .normal)
    }


    
}


