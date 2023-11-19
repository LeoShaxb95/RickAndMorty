//
//  DefaultScreensFactory.swift
//  RickAndMorty
//
//  Created by Levon Shaxbazyan on 18.11.23.
//

import UIKit

protocol ScreensFactory {
    func makeEpisodes() -> EpisodesVC
}

class DefaultScreensFactory: ScreensFactory {
  
    public static let shared: ScreensFactory  = DefaultScreensFactory()
    
    private init() {}
    
    func makeEpisodes() -> EpisodesVC {
        
        let presenter = EpisodesPresenter()
        return EpisodesVC(presenter: presenter)
        
    }
    
}

