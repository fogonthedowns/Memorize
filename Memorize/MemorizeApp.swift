//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Justin Zollars on 7/6/21.
//

import SwiftUI

@main
struct MemorizeApp: App {
    // pointer to mutable class
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game:game)
        }
    }
}
