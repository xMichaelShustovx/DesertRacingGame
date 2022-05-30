//
//  User.swift
//  DesertRacingGame
//
//  Created by Michael Shustov on 16.02.2022.
//


class User: Codable {
    
    let name: String
    var results: [Double]? {
        didSet {
            DataManager.saveData(user: self)
            self.results?.sort()
            self.results?.reverse()
            if self.results != nil, self.results!.count > 10 {
                self.results!.removeSubrange(10..<self.results!.count)
            }
        }
    }
    
    init(name: String) {
        self.name = name
    }
}
