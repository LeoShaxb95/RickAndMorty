//
//  DefaultScreensFactory.swift
//  RickAndMorty
//
//  Created by Levon Shaxbazyan on 18.11.23.
//

import UIKit

protocol ScreensFactory {
    func makeEpisodes() -> EpisodesVC
    func makeCharacterDetails() -> CharacterDetailsVC
}

class DefaultScreensFactory: ScreensFactory {
  
    public static let shared: ScreensFactory  = DefaultScreensFactory()
    private init() {}
    
    func makeEpisodes() -> EpisodesVC {
        var output = EpisodesOutput()
        
        output.onMoveToCharacterDetails = { [weak self] in
            guard let self else { return }
            let vc = self.makeCharacterDetails()
            SceneDelegate.router?.push(module: vc, animated: true)
        }
        
        let presenter = EpisodesPresenter(output: output)
        return EpisodesVC(presenter: presenter)
    }
    
    func makeCharacterDetails() -> CharacterDetailsVC {
        let presenter = CharacterDetailsPresenter()
        return CharacterDetailsVC(presenter: presenter)
    }
    
}

