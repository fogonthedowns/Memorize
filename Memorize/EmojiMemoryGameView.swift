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
            VStack {
                gameBody
                shuffle
            }
            .padding()
        }
    
    // temparary state in view, to control how UI opperates
    // only for use in view
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3, content: { card in
            if isUndealt(card) || card.isMatched && !card.isFaceUp {
                Color.clear // creates a rectangle with a clear color
            } else {
                CardView(card:card)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .scale, removal: .opacity))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.5)) {
                          game.choose(card)
                        }
                    }
            }
        })
        
        // don't put a view on screen, until its container appears
        .onAppear {
            withAnimation {
                for card in game.cards {
                    deal(card)
                }
            }
            // deal cards
        }
            .foregroundColor(.red)
    }
    
    
    var shuffle: some View {
        Button("Shuffle") {
            withAnimation {
                game.shuffle()
            }
        }
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
                Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90)).padding(DrawingConstants.circlePadding).opacity(DrawingConstants.circleOpacity)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) // only effects modifiers above, not below
                    .font(Font.system(size:DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits:geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        })
    }
    
    private func scale(thatFits size:CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize/DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 2
        static let fontScale: CGFloat = 0.7
        static let circlePadding: CGFloat = 4
        static let circleOpacity: Double = 0.5
        static let fontSize: CGFloat = 32
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        EmojiMemoryGameView(game: game).preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
        EmojiMemoryGameView(game: game).preferredColorScheme(.light)
    }
}
