//
//  MemoryGame.swift
//  Memorize
//
//  Created by Ken Wang on 2022/4/11.
//  Model

import Foundation
import SwiftUI

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private(set) var score: Int
    
    let Matched = 2
    let FaceUpOne = -1
    let FaceUpTwo = -2
    
    
    private var lastFaceUpCardIndex: Int? {
        get { cards.indices.filter({ cards[$0].isFaceUp}).oneAndOnly }
        set { cards.indices.forEach({cards[$0].isFaceUp = $0 == newValue })}
    }
    
    mutating func choose(_ card: Card ) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id}),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched
        {
            if let lastIndex = lastFaceUpCardIndex {
                if cards[lastIndex].content == card.content{
                    cards[lastIndex].isMatched = true
                    cards[chosenIndex].isMatched = true
                    newscore(to: score + Matched)
                } else {
                    if cards[chosenIndex].isFaceUped == true {
                        newscore(to: score + FaceUpOne)
                    }
                }
                cards[chosenIndex].isFaceUp = true
                cards[chosenIndex].isFaceUped = true
            } else {
                if cards[chosenIndex].isFaceUped == true {
                    newscore(to: score + FaceUpOne)
                }
                lastFaceUpCardIndex = chosenIndex
                cards[chosenIndex].isFaceUped = true
            }
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    private mutating func newscore(to newScore: Int) {
        score = newScore
    }
    
    init (numberOfPairs: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        score = 0
        for pairIndex in 0..<numberOfPairs {
            // add numberOfPairs * 2cards
            let content: CardContent = createCardContent(pairIndex)
            cards.append(Card(isFaceUped: false, content: content, id : pairIndex * 2 ))
            cards.append(Card(isFaceUped: false, content: content, id : pairIndex * 2 + 1))
        }
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var isFaceUped:Bool = false
        let content: CardContent
        let id: Int
    }
}
extension Array {
    var oneAndOnly: Element? {
        if self.count == 1 {
            return self.first
        } else {
            return nil
        }
    }
}

