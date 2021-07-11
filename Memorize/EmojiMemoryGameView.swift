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
    
    @Namespace private var dealingNamespace
    
    //var emojis:Array<String> = ["👻","🏀","🔥","👋"]
   // @State var emojiCount:Int = 20
    
    // some View means "something that behaves like a View"
    // varaible name: Type
    // after View is a function {}, that is nameless and
    // has no arguments
    // the return is implied,
    // return Text()
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                gameBody
                HStack {
                  shuffle
                  Spacer()
                  restart
                }
                .padding(.horizontal)
            }
            deckBody
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
    
    private func dealAnimcation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: {$0.id == card.id }) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        // default to zero
        // optional
        -Double(game.cards.firstIndex(where: {$0.id == card.id}) ?? 0)
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2/3, content: { card in
            if isUndealt(card) || card.isMatched && !card.isFaceUp {
                Color.clear // creates a rectangle with a clear color
            } else {
                CardView(card:card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    // identity means don't do any animation
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.5)) {
                          game.choose(card)
                        }
                    }
            }
        })
            .foregroundColor(.red)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) {
                card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
        // don't put a view on screen, until its container appears
        .onTapGesture {
                for card in game.cards {
                    withAnimation(dealAnimcation(for: card)) {
                    deal(card)
                }
            }
            // deal cards
        }
    }
    
    
    var shuffle: some View {
        Button("Shuffle") {
            withAnimation {
                game.shuffle()
            }
        }
    }
    
    var restart: some View {
        Button("Restart") {
            withAnimation {
                dealt = []
                game.restart()
            }
        }
    }
    
    private struct CardConstants {
        static let totalDealDuration: Double = 2.0
        static let dealDuration: Double = 1.0
        static let aspectRatio: CGFloat = 2/3
        static let fontSize: CGFloat = 32
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
        static let color = Color.red
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
                Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining)*360-90))
                    .padding(DrawingConstants.circlePadding)
                    .opacity(DrawingConstants.circleOpacity)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) // only effects modifiers above, not below
                    .padding(5)
                    .font(Font.system(size:DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits:geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        })
    }
    
    private func scale(thatFits size:CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
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
