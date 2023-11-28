//
//  CacheManagerProtocol.swift
//  RickAndMorty
//
//  Created by Levon Shaxbazyan on 26.11.23.
//

import UIKit

protocol CacheManagerProtocol {
    func saveImage(_ image: UIImage, forKey key: String)
    func loadImage(forKey key: String) -> UIImage?
    func saveObject<T: Codable>(_ object: T, forKey key: String)
    func loadObject<T: Codable>(forKey key: String, type: T.Type) -> T?
    func encodeToData<T: Codable>(_ value: T) -> Data?
    func saveDataToFile(data: Data, filename: String)
    func getDocumentsDirectory() -> URL
    func save(array: [String], withFileName fileName: String)
    func loadArray(withFileName fileName: String) -> [String]?
}
