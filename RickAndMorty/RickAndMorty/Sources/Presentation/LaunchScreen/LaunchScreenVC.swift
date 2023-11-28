//
//  LaunchScreenVC.swift
//  RickAndMorty
//
//  Created by Levon Shaxbazyan on 28.11.23.
//

import UIKit

final class LaunchScreenVC: BaseVC {

    // MARK: - Subviews
    
    private var titleImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleToFill
        v.image = UIImage(named: "RickAndMorty")
        
        return v
    }()
    
    private var rotateImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleToFill
        v.image = UIImage(named: "Loading")
        
        return v
    }()

    private let presenter: LaunchScreenPresenterProtocol

    // MARK: - Init

    init(presenter: LaunchScreenPresenterProtocol) {
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
        
        startRotatingCircle()

        setupSubviews()
        bind()

    }

    // MARK: - Bind

    public override func bind() {

    }

    // MARK: - Setup

    public override func setupSubviews() {
        view.addSubviews([
            titleImageView,
            rotateImageView
        ])

    }

    public override func setupAutolayout() {

        titleImageView.pin(edges: [.top], to: view, inset: 50, toSafeArea: true)
        titleImageView.pin(edges: [.leading, .trailing], to: view, inset: 20)

        titleImageView.set(width: 350, height: 110)
        rotateImageView.set(width: 200, height: 200)

        NSLayoutConstraint.activate([
            rotateImageView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            rotateImageView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor),
        ])
    }

    // MARK: - Other funcs
    
    private func startRotatingCircle() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = 2 * Double.pi
        rotation.duration = 1
        rotation.repeatCount = .infinity
        rotateImageView.layer.add(rotation, forKey: "rotate")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.transitionToMainInterface()
        }
    }
    
    private func transitionToMainInterface() {
        self.presenter.moveToHomeScreen()
    }
    
    

    // MARK: Callbacks


}

