//
//  Custom.swift
//  RickAndMorty
//
//  Created by Levon Shaxbazyan on 26.11.23.
//

import UIKit

// MARK: - Custom
struct Custom: Codable {
    
    let characterImage: String
    let characterName: String
    let episodeName: String
    let episodeNumber: String
    let isFavorite: Bool
    let gender: String
    let status: String
    let specie: String
    let origin: Location
    let type: String
    let location: Location
}
