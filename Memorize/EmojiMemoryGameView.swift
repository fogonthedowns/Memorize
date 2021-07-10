//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Justin Zollars on 7/6/21.
//

import SwiftUI

// View 
struct EmojiMemoryGameView: View {
    // game is the ViewModel
    @ObservedObject var game: EmojiMemoryGame
    
    //var emojis:Array<String> = ["👻","🏀","🔥","👋"]
   // @State var emojiCount:Int = 20
    
    // some View means "something that behaves like a View"
    // varaible name: Type
    // after View is a function {}, that is nameless and
    // has no arguments
    // the return is implied,
    // return Text()
    var body: some View {
        // Stacks views on top of one another
        // hence Z stack
        // content is a function
        // its ommitted if its the last arg, so you can drop the () and use {}
    
        AspectVGrid(items: game.cards, aspectRatio: 2/3, content: { card in
            if card.isMatched && !card.isFaceUp {
                Rectangle().opacity(0)
            } else {
                CardView(card:card)
                    .padding(4)
                    .onTapGesture {
                        game.choose(card)
                    }
            }
        })
            .foregroundColor(.red)
            .padding(.horizontal)
        }
    }

// refactored view into view struct
struct CardView: View {
    // default true
    // becomes param to CardView(isFaceUp:value)
    //    @State var isFaceUp: Bool = true
 
    // previously MemoryGame<String>.Card
    let card: EmojiMemoryGame.Card
    
    var body: some View {
        
        GeometryReader(content: { geometry in
            ZStack {
                // let shape: RoundedRectangle = RoundedRectangle(cornerRadius: 20.0)
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                if card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    
                    Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90)).padding(DrawingConstants.circlePadding).opacity(DrawingConstants.circleOpacity)

                    Text(card.content).font(Font.system(size: min(geometry.size.width, geometry.size.height)*DrawingConstants.fontScale))
                    
                } else if card.isMatched {
                    shape.opacity(0)
                } else {
                    shape.fill()
                }
            }
        })
//        .onTapGesture {
//            // self is immutable
//            // views are always being created, and can't be changed
//            // Does not compile without @State (pointer)
//            isFaceUp = !isFaceUp
//        }
    }
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 2
        static let fontScale: CGFloat = 0.65
        static let circlePadding: CGFloat = 4
        static let circleOpacity: Double = 0.5
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        EmojiMemoryGameView(game: game).preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
        EmojiMemoryGameView(game: game).preferredColorScheme(.light)
    }
}
