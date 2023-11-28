//
//  CharacterDetailsTableViewCell.swift
//  RickAndMorty
//
//  Created by Levon Shaxbazyan on 20.11.23.
//

import UIKit

public final class CharacterDetailsTableViewCell: UITableViewCell {
    
    // MARK: - Subviews
    
    let titleLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 16, weight: .bold)
        v.textColor = UIColor(hex: "#081F32")
        v.text = "titleLabel"

        return v
    }()
    
    let descriptionLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        v.textColor = UIColor(hex: "#6E798C")
        v.text = "descriptionLabel"

        v.textAlignment = .left
        
        return v
    }()
    
    public func configure(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description

        setupUI()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let inset: CGFloat = 5
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0))
    }
    
    func setupUI() {
        selectionStyle = .none

        contentView.addSubviews([
            titleLabel,
            descriptionLabel
        ])
        
        titleLabel.pin(edges: [.leading], to: contentView, inset: 20)
        descriptionLabel.pin(edges: [.leading], to: contentView, inset: 20)
        
        titleLabel.set(width: 200, height: 20)
        descriptionLabel.set(width: 200, height: 20)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor),
            descriptionLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor, constant: 5)
        ])
    }
}
