//
//  APIManager.swift
//  RickAndMorty
//
//  Created by Levon Shaxbazyan on 22.11.23.
//

import UIKit

protocol ApiManagerProtocol {
    func getEpisode(completion: @escaping ([Results]) -> Void)
    func getCharacter(url: String, completion: @escaping (Characters) -> Void)
}

class APIManager: ApiManagerProtocol {
    
    let urlStringForEpisode = "https://rickandmortyapi.com/api/episode/1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20"
    
    func getEpisode(completion: @escaping ([Results]) -> Void) {
        let url = URL(string: urlStringForEpisode)!
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            if let results = try? JSONDecoder().decode([Results].self, from: data) {
                print("APIManager  \(results)")
                completion(results)
            } else {
                print("fail")
            }
        }
        task.resume()

    }
    
    func getCharacter(url: String, completion: @escaping (Characters) -> Void) {
        let url = URL(string: url)!
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            if let characters = try? JSONDecoder().decode(Characters.self, from: data) {
                print("APIManager\(characters)")
                completion(characters)
            } else {
                print("fail")
            }
        }
        task.resume()
    }

}
