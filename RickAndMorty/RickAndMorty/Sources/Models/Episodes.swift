//
//  EpisodesModel.swift
//  RickAndMorty
//
//  Created by Levon Shaxbazyan on 22.11.23.
//

import Foundation

// MARK: - Episodes
struct Episodes: Codable {
    let info: Info
    let results: [Results]
}

// MARK: - Info
struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String
    let prev: String
}

// MARK: - Results
struct Results: Codable, Hashable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case airDate = "air_date"
        case episode, characters, url, created
    }
}
