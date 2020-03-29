//
//  SceneDelegate.swift
//  ExchangeRatesTracker
//
//  Created by Fabio Martignoni on 27/03/2020.
//  Copyright © 2020 fabiomartignoni. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
        var JSONString: String
        do {
            JSONString = try loadValidCurrenciesJSON()
        }
        catch {
            print(error)
            JSONString = ""
        }
        
        let currenciesDataSource = JSONCurrenciesDataSource(json: JSONString)
        let repository = BaseExchangeRatesRepository(currenciesDataSource: currenciesDataSource)
        let viewModel = BaseExchangeRatesViewModel(repository: repository)
        let contentView = ExchangeRatesView(viewModel: viewModel)

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    private func loadValidCurrenciesJSON() throws -> String {
        
        let JSON_BUNDLE_FILE_NAME = "currencies"
        
        do {
            if let path = Bundle.main.path(forResource: JSON_BUNDLE_FILE_NAME, ofType: "json") {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                return "\(json)"
            }
            else {
                throw InvalidJSONError.init(description: "File not found in bundle.")
            }
        }
        catch {
            throw InvalidJSONError.init(description: "Test JSON data is invalid or empty.")
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

