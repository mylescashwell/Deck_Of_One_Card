//
//  CardController.swift
//  DeckOfOneCard
//
//  Created by Myles Cashwell on 5/4/21.
//

import UIKit

class CardController {
    
    //MARK: - Properties
    static let baseURL = URL(string: "https://deckofcardsapi.com/api/")
    static let cardPathComponent = "deck/new/draw"
    
    
    //MARK: - Functions
    static func fetchCard(completion: @escaping (Result<Card, CardError>) -> Void) {
        guard let baseURL = self.baseURL else { return completion(.failure(.invalidURL)) }
        let cardURL = baseURL.appendingPathComponent(cardPathComponent)
        print(cardURL)
        
        URLSession.shared.dataTask(with: cardURL) { (data, response, error) in
            if let error = error {
                print("Error in \(#function)\(#line) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                print("CARD STATUS CODE: \(response.statusCode)")
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                let card = topLevelObject.cards[0]
                completion(.success(card))
            } catch {
                completion(.failure(.unableToDecode))
                print("Error in \(#function)\(#line) : \(error.localizedDescription) \n---\n \(error)")
            }
        }.resume()
    }
    
    static func fetchImage(for card: Card, completion: @escaping (Result<UIImage, CardError>) -> Void) {
        guard let url = card.image else { return completion(.failure(.invalidURL)) }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error in \(#function)\(#line) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                print("CARD IMAGE STATUS CODE: \(response.statusCode)")
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            guard let image = UIImage(data: data) else { return completion(.failure(.unableToDecode)) }
            completion(.success(image))
        }.resume()
    }
}
