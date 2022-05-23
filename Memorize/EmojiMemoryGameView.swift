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
        VStack{
            info
            gameBody
            HStack{
                new
                shuffle
            }
        }
        .foregroundColor(game.theme.color)
    }
    @State private var dealt = Set<Int>()
    
    private func deal (_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    private func isUndealt (_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    var gameBody :some View {
        AspectVGrid (items: game.cards, aspectRadio: 2/3,content: { card in
            if isUndealt(card) || (!card.isFaceUp && card.isMatched) {
                Color.clear
            } else {
                CardView(card)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .scale, removal: .opacity))
                    .onTapGesture{
                        
                        withAnimation{
                            game.choose(card)
                        }
                    }
            }
        })
        .onAppear(){
            withAnimation(){
                game.cards.forEach { card in
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
    
    var  new: some View {
        Button {
            game.newGame()
        } label: {
            VStack(alignment: .center) {
                Image(systemName: "paintbrush")
                    .font(.body)
                Text("NewTheme")
                    .fontWeight(.semibold)
                    .font(.footnote)
            }
        }
        .buttonStyle(GradientBackgroundStyle(game:game))
    }
}

struct CardView: View {
    let card: EmojiMemoryGame.Card
    
    init (_ card: EmojiMemoryGame.Card) {
        self.card = card
    }
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack {
                Pie(startAngel: Angle.degrees(0 - 90), endAngle: Angle.degrees(110 - 90))
                    .opacity(0.6)
                    .padding(4)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: card.isMatched)
                    .font(font(size:geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    private func font(size: CGSize) -> Font {
        Font.system(size:min(size.width, size.height) * 0.7)
    }
    struct DrawingConstent {
        static let cornerRadius:CGFloat = 10
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

