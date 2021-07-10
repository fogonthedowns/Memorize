//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Justin Zollars on 7/8/21.
//

// ViewModel
// Intervediate Model and View
import SwiftUI

func makeCardContent(index: Int) -> String {
    return "🦥"
}


class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    
    // doesn't depend on self being initialized
    // static is global, but scoped to EmojiMemoryGame
    private static let emojis: [String] = ["👻","🏀","🔥","👋", "👜", "🕶", "🥽", "🌂", "🧢","🌮", "🥡", "⚙️", "🛡", "🧲", "🚬", "🥒", "🥬", "🫑", "🪖", "👠", "🩴", "🍁","🪴","🪐","🌲","💫"]
    
    // doesn't depend on self being initialized
    // static is global, but scoped to EmojiMemoryGame
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 8) { pairIndex in EmojiMemoryGame.emojis[pairIndex]}
    }
    
    // only the ViewModel's code itself, can see the model
    // outside of scope, things can read, but not change the model
    // automatically change view with published when the model changes
    @Published private var model:MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
}


