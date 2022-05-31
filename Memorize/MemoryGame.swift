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
        {
            didSet{
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched: Bool = false
        {
            didSet{
                stopUsingBonusTime()
            }
        }
        var isFaceUped:Bool = false
        let content: CardContent
        let id: Int
        
        // MARK: - Bonus Time
        
        // this could give matching bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up
        
        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
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

