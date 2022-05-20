//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Ken Wang on 2022/3/21.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
