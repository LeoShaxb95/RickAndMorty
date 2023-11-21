//
//  DefaultScreensFactory.swift
//  RickAndMorty
//
//  Created by Levon Shaxbazyan on 18.11.23.
//

import UIKit

protocol ScreensFactory {
    func makeHome() -> HomeTabBarController
    func makeEpisodes() -> EpisodesVC
    func makeCharacterDetails() -> CharacterDetailsVC
    func makeFavorites() -> FavoritesVC
}

class DefaultScreensFactory: ScreensFactory {
  
    public static let shared: ScreensFactory  = DefaultScreensFactory()
    private init() {}
    
    func makeHome() -> HomeTabBarController {
        let item1 =  self.makeEpisodes()
        let item2 = self.makeFavorites()
       
        return HomeTabBarController(items: [item1, item2])
    }
    
    func makeEpisodes() -> EpisodesVC {
        var output = EpisodesOutput()
        
        output.onMoveToCharacterDetails = { [weak self] in
            guard let self else { return }
            let vc = self.makeCharacterDetails()
            SceneDelegate.router?.push(module: vc, animated: true)
        }
        
        let presenter = EpisodesPresenter(output: output)
        let vc = EpisodesVC(presenter: presenter)
        vc.tabBarItem.image = UIImage(named: "HomeSelected")
        
        return vc
    }
    
    func makeCharacterDetails() -> CharacterDetailsVC {
        let presenter = CharacterDetailsPresenter()
        return CharacterDetailsVC(presenter: presenter)
    }
    
    func makeFavorites() -> FavoritesVC {
        var output = FavoritesOutput()
        
        output.onMoveToCharacterDetails = { [weak self] in
            guard let self else { return }
            let vc = self.makeCharacterDetails()
            SceneDelegate.router?.push(module: vc, animated: true)
        }
        
        let presenter = FavoritesPresenter(output: output)
        let vc = FavoritesVC(presenter: presenter)
        vc.tabBarItem.image = UIImage(named: "FavoriteSelected")
        
        return vc
    }
    
}

