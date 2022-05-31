//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Ken Wang on 2022/3/21.
//  View
import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game : EmojiMemoryGame
    
    var body: some View {
        ZStack(alignment: .bottom){
            VStack{
                info
                gameBody
                HStack{
                    restart
                    Spacer()
                    shuffle
                }
                
                .padding(.horizontal)
            }
            deckBody
        }
        .padding()
    }
    
    @State private var dealt = Set<Int>()
    
    private func deal (_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    private func isUndealt (_ card: EmojiMemoryGame.Card) -> Bool {
        return !dealt.contains(card.id)
    }
    
    @Namespace private var cardNamespace
    var gameBody: some View {
        AspectVGrid (items: game.cards, aspectRadio: 2/3,content: { card in
            if isUndealt(card) || (!card.isFaceUp && card.isMatched) {
                Rectangle().opacity(0)
            } else {
                CardView(card)
                    .zIndex(zIndex(of: card))
                    .padding(4)
                    .matchedGeometryEffect(id: card.id, in: cardNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .onTapGesture{
                        withAnimation{
                            game.choose(card)
                        }
                    }
            }
        })
        .foregroundColor(game.theme.color)
    }
    
    private func dealAnimation (for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        let delayTotal = 2.0
        
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (delayTotal / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: 0.5).delay(delay)
    }
    
    private func zIndex (of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    var deckBody: some View {
        ZStack{
            ForEach(game.cards.filter(isUndealt)) {
                card in CardView(card)
                    .zIndex(zIndex(of: card))
                    .matchedGeometryEffect(id: card.id, in: cardNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
            }
        }
        .frame(width: 60, height: 90)
        .foregroundColor(game.theme.color)
        .onTapGesture {
            game.cards.forEach { card in
                withAnimation(dealAnimation(for: card)){
                    deal(card)
                }
            }
        }
    }
    
    var  shuffle: some View {
        Button {
            withAnimation(){
                game.shuffle()
            }
        } label: {
            VStack(alignment: .center) {
                Image(systemName: "paintbrush")
                    .font(.body)
                Text("Shuffle")
                    .fontWeight(.semibold)
                    .font(.footnote)
            }
        }
        .buttonStyle(GradientBackgroundStyle(game:game))
    }
    
    var restart: some View {
        Button{
            withAnimation{
            dealt = []
            game.restart()
            }
        } label: {
            VStack{
            Image(systemName: "paintbrush")
                .font(.body)
            Text("Restart")
                .fontWeight(.semibold)
                .font(.footnote)
            }
        }
        .buttonStyle(GradientBackgroundStyle(game:game))
    }
    
    var info: some View {
        VStack{
            Text("Theme:    \(game.getTheme)")
            HStack(alignment: .center) {
                Text("Score:")
                Spacer()
                Text("\(game.getScore)")
                    .font(.title)
            }
            .font(.system(.headline))
            .padding(.horizontal)
        }
    }
}

struct CardView: View {
    let card: EmojiMemoryGame.Card
    
    init (_ card: EmojiMemoryGame.Card) {
        self.card = card
    }
    
    @State private var currentRemainingPercent = 0.0
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack {
                Group {
                if card.isConsumingBonusTime {
                    Pie(startAngle: Angle.degrees(0 - 90), endAngle: Angle.degrees((1 - currentRemainingPercent) * 360 - 90))
                        .onAppear() {
                            currentRemainingPercent = card.bonusRemaining
                            withAnimation (.linear(duration: card.bonusTimeRemaining)){
                                currentRemainingPercent = 0
                            }
                        }
                } else {
                    Pie(startAngle: Angle.degrees(0 - 90), endAngle: Angle.degrees((1 - card.bonusRemaining) * 360 - 90))
                }
            }
                    .opacity(0.6)
                    .padding(4)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: card.isMatched)
                    .font(font(size: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    private func font(size: CGSize) -> Font {
        Font.system(size:min(size.width, size.height) * DrawingConstent.fontScale)
    }
    
    struct DrawingConstent {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.7
    }
}

struct GradientBackgroundStyle: ButtonStyle {
    @ObservedObject var game : EmojiMemoryGame
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0 , maxWidth: .infinity, maxHeight: 45)
            .padding(.horizontal,10)
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [ game.theme.color, game.theme.dcolor]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(40)
            .padding(.horizontal, 0)
            .scaleEffect(configuration.isPressed ? 0.9 :1.0)
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        
        EmojiMemoryGameView(game: game)
            .preferredColorScheme(.dark)
            .previewInterfaceOrientation(.portrait)
    }
}

