//
//  SceneDelegate.swift
//  RickAndMorty
//
//  Created by Levon Shaxbazyan on 18.11.23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    static var router: Routable?
    static var screenWidth: CGFloat?
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        SceneDelegate.screenWidth = windowScene.screen.bounds.width
        
        let nv = UINavigationController()
        window?.rootViewController = nv
        SceneDelegate.router = DefaultRouter(rootController: nv)
        
        window.flatMap(willConnectToSession)
    }   

}

// MARK: - Private methods
private extension SceneDelegate {
    func willConnectToSession(window: UIWindow) {
        window.makeKeyAndVisible()
        let vc = DefaultScreensFactory.shared.makeLaunchScreen()
        SceneDelegate.router?.setRoot(module: vc)
    }
}
