//
//  Card.swift
//  DeckOfOneCard
//
//  Created by Myles Cashwell on 5/4/21.
//

import Foundation

struct TopLevelObject: Decodable {
    let cards: [Card]
}

struct Card: Decodable {
    let value: String
    let suit: String
    let image: URL?
}
