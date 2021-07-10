//
//  MemoryGame.swift
//  Memorize
//
//  Created by Justin Zollars on 7/8/21.
//

// Model
import Foundation

// Generics
struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards:Array<Card>
    
    // computed property
    // lecture 5
    private var faceUpCard: Int? {
        get { cards.indices.filter({ cards[$0].isFaceUp}).oneAndOnly }
        set { cards.indices.forEach {cards[$0].isFaceUp = ($0==newValue)} }
    }
    
    mutating func choose(_ card: Card) {
        // $0.id in lue of x in x.id
        if let chosenIndex =  cards.firstIndex(where: {x in x.id == card.id }),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched {
            if let cur = faceUpCard {
                if cards[chosenIndex].content == cards[cur].content {
                    cards[chosenIndex].isMatched = true
                    cards[cur].isMatched = true
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                faceUpCard = chosenIndex
            }
        }
    }
    
//    func index(of card: Card) -> Int {
//        for index in 0..<cards.count {
//            if cards[index].id == card.id {
//                return index
//            }
//        }
//        return 0 // not found
//    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        // could be cards = []
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content: CardContent = createCardContent(pairIndex)
            cards.append(Card(id: pairIndex*2, content: content))
            cards.append(Card(id: pairIndex*2+1, content: content))
        }
    }
    
    struct Card: Identifiable {
        let id: Int
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        let content: CardContent
    }
}

// lecture 5
extension Array {
    // don't care is the elment
    var oneAndOnly: Element? {
        if self.count == 1 {
            return self.first
        } else {
            return nil
        }
    }
}
