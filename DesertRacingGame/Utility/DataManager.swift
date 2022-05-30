//
//  DataManager.swift
//  DesertRacingGame
//
//  Created by Michael Shustov on 16.02.2022.
//

import Foundation


class DataManager {
    
    private static let resultsURL: URL = {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                      .userDomainMask,
                                                      true).first!
        return URL(fileURLWithPath: path)
    }()
    
    private init() {}
    
    static func saveData(user: User) {
        let urlToSave = resultsURL.appendingPathComponent("\(user.name).json")
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let resultsData = try encoder.encode(user)
            FileManager.default.createFile(atPath: urlToSave.path, contents: resultsData, attributes: nil)
        }
        catch {
            print(error)
        }
    }
    
    static func fetchData(user: User) -> [Double]? {
        let url = resultsURL.appendingPathComponent("\(user.name).json")
        
        do {
            let data = try Data(contentsOf: url)
            let result = try JSONDecoder().decode(User.self, from: data)
            return result.results
        }
        catch {
            print(error)
        }
        return nil
    }
}
