//
//  Bundle.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 29/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import Foundation

extension Bundle {
    
    func loadJSON<DTO>(type: DTO.Type, fileName: String) throws -> DTO where DTO: Decodable {
        do {
            if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return try JSONDecoder().decode(DTO.self, from: data)
            }
            else {
                throw InvalidJSONError.init(description: "File '\(fileName)' not found in bundle.")
            }
        }
        catch {
            throw InvalidJSONError.init(description: "Error reading/decoding JSON file '\(fileName)' from bundle: \(error)")
        }
    }
    
    //MARK: - error
    
    private struct InvalidJSONError: LocalizedError {
        var errorDescription: String? { return _description }
        private var _description: String
        init(description: String) {
            self._description = description
        }
    }
}
