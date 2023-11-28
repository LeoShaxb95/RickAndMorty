//
//  DefaultScreensFactory.swift
//  RickAndMorty
//
//  Created by Levon Shaxbazyan on 18.11.23.
//

import UIKit

protocol ScreensFactory {
    func makeLaunchScreen() -> LaunchScreenVC
    func makeHome() -> HomeTabBarController
    func makeEpisodes() -> EpisodesVC
    func makeCharacterDetails(model: Custom) -> CharacterDetailsVC
    func makeFavorites() -> FavoritesVC
}

class DefaultScreensFactory: ScreensFactory {
  
    public static let shared: ScreensFactory  = DefaultScreensFactory()
    private init() {}
    
    func makeLaunchScreen() -> LaunchScreenVC {
        
        var output = LaunchScreenOutput()
        
        output.onMoveToHome = { [weak self] in
            guard let self else { return }
            let vc = self.makeHome()
            SceneDelegate.router?.push(module: vc, animated: true)
        }
        
        let presenter = LaunchScreenPresenter(output: output)
        let vc = LaunchScreenVC(presenter: presenter)
        
        return vc
    }
    
    func makeHome() -> HomeTabBarController {
        let item1 =  self.makeEpisodes()
        let item2 = self.makeFavorites()
       
        return HomeTabBarController(items: [item1, item2])
    }
    
    func makeEpisodes() -> EpisodesVC {
        var output = EpisodesOutput()
        
        output.onMoveToCharacterDetails = { [weak self] model in
            guard let self else { return }
            let vc = self.makeCharacterDetails(model: model)
            SceneDelegate.router?.push(module: vc, animated: true)
        }
        
        let presenter = EpisodesPresenter(output: output)
        let apiManager = APIManager() as ApiManagerProtocol
        let cacheManager = CacheManager() as CacheManagerProtocol
        
        let vc = EpisodesVC(presenter: presenter,
                            apiManager: apiManager,
                            cacheManager: cacheManager)
        
        vc.tabBarItem.image = UIImage(named: "HomeSelected")
        
        return vc
    }
    
    func makeCharacterDetails(model: Custom) -> CharacterDetailsVC {
        let presenter = CharacterDetailsPresenter()
        return CharacterDetailsVC(presenter: presenter, model: model)
    }
    
    func makeFavorites() -> FavoritesVC {
        var output = FavoritesOutput()
        
        output.onMoveToCharacterDetails = { [weak self] model in
            guard let self else { return }
            let vc = self.makeCharacterDetails(model: model)
            SceneDelegate.router?.push(module: vc, animated: true)
        }
        
        let presenter = FavoritesPresenter(output: output)
        let cacheManager = CacheManager() as CacheManagerProtocol
        let vc = FavoritesVC(presenter: presenter, cacheManager: cacheManager)
        vc.tabBarItem.image = UIImage(named: "FavoriteSelected")
        
        return vc
    }
    
}

