//
//  CacheManager.swift
//  RickAndMorty
//
//  Created by Levon Shaxbazyan on 26.11.23.
//

import UIKit

class CacheManager: CacheManagerProtocol {
    
    func saveImage(_ image: UIImage, forKey key: String) {
        if let data = image.jpegData(compressionQuality: 1.0) {
            saveDataToFile(data: data, filename: key)
        } else {
            print("Error converting image to data")
        }
    }

    func loadImage(forKey key: String) -> UIImage? {
        let filePath = getDocumentsDirectory().appendingPathComponent(key)
        if let data = try? Data(contentsOf: filePath) {
            return UIImage(data: data)
        }
        
        return nil
    }

    func saveObject<T: Codable>(_ object: T, forKey key: String) {
        if let data = encodeToData(object) {
            saveDataToFile(data: data, filename: key)
        } else {
            print("Error encoding object")
        }
    }

    func loadObject<T: Codable>(forKey key: String, type: T.Type) -> T? {
        let filePath = getDocumentsDirectory().appendingPathComponent(key)
        if let data = try? Data(contentsOf: filePath) {
            let decoder = JSONDecoder()
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                print("Error decoding object: \(error)")
            }
        }
        return nil
    }
    
    func encodeToData<T: Codable>(_ value: T) -> Data? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(value)
            return data
        } catch {
            print("Error encoding data: \(error)")
            return nil
        }
    }
    
    func saveDataToFile(data: Data, filename: String) {
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            try data.write(to: filePath)
            print("Saved successfully to \(filePath)")
        } catch {
            print("Error saving file: \(error)")
        }
    }
    
    func loadArray(withFileName fileName: String) -> [String]? {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: url)
            let array = try decoder.decode([String].self, from: data)
            return array
        } catch {
            print("Error loading array: \(error)")
            return nil
        }
    }
    
    func save(array: [String], withFileName fileName: String) {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(array)
            try data.write(to: url)
        } catch {
            print("Error saving array: \(error)")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}

