//
//  UserDefaults.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 30/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import Foundation

extension UserDefaults {
    func objects<T>(type: T.Type, forKey: String) throws -> [T] where T: Decodable {
        if let objects = self.value(forKey: forKey) as? Data {
            return try JSONDecoder().decode(Array.self, from: objects) as [T]
        }
        else {
            return [T]()
        }
    }
    
    func set<T>(type: T.Type, values: [T], forKey: String) throws where T: Codable {
        let encoded = try JSONEncoder().encode(values)
        self.set(encoded, forKey: forKey)
    }
}
