//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Ken Wang on 2022/4/11.
//  ViewModel

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    private(set) var theme: Theme
    @Published private var model: MemoryGame<String>
    
    typealias Card = MemoryGame<String>.Card
    
    static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        let emojis: Array<String> = theme.items.shuffled()
        var selectEmoji = theme.numberOfPairs ?? Int.random(in: 6...theme.items.count)
        if selectEmoji > theme.items.count {
            selectEmoji = theme.items.count
        }
        return MemoryGame<String>(numberOfPairs: selectEmoji)
        { pairIndex in return emojis[pairIndex] }
    }
    
    init(startingTheme: Theme? = nil){
        let selectedTheme = startingTheme ?? themes.randomElement()!
        self.theme = selectedTheme
        model = EmojiMemoryGame.createMemoryGame(theme: selectedTheme)
    }
    
    
    //MARK: -model
    
    var cards:Array<Card> {
        return model.cards
    }
    
    var getTheme:String {
        return theme.name
    }
    
    var getScore:Int {
        return model.score
    }
    
    //MARK: -view actions
    
    func choose (_ card:Card){
        model.choose(card)
    }
    
    func restart() {
        let newTheme = themes.randomElement()!
        self.theme = newTheme
        model = EmojiMemoryGame.createMemoryGame(theme: newTheme)
    }
    
    func shuffle(){
        model.shuffle()
    }
}
