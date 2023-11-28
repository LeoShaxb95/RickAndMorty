//
//  CharactersModel.swift
//  RickAndMorty
//
//  Created by Levon Shaxbazyan on 22.11.23.
//

import Foundation

// MARK: - Character
struct Characters: Codable {
    let id: Int
    let name, status, species, type: String
    let gender: String
    let origin, location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

// MARK: - Location
struct Location: Codable {
    let name: String
    let url: String
}
