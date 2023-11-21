//
//  HomeTabBarController.swift
//  RickAndMorty
//
//  Created by Levon Shaxbazyan on 21.11.23.
//

import UIKit

open class HomeTabBarController: UITabBarController {
    private let items: [UIViewController]
    
    public init(items: [UIViewController]) {
        let imageInset = UIEdgeInsets(top: 3, left: 0, bottom: -3, right: 0)
        
        for vc in items {
            vc.tabBarItem.imageInsets = imageInset
        }
        
        self.items = items
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewControllers = items
    }
    
    private func setupTabBar() {
        let tabBar = HomeTabBar()
        self.setValue(tabBar, forKey: "tabBar")
        self.tabBar.tintColor = UIColor(hex: "#2D0E6C")
        self.tabBar.barTintColor = .white
        self.tabBar.itemPositioning = .centered
    }
}
