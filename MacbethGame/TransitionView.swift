import SwiftUI

// Animasyonlu metin bileşeni
struct AnimatedText: View {
    let text: String
    @State private var displayedText = ""
    @State private var currentIndex = 0
    let wordsPerStep = 2 // Her seferde kaç kelime gösterileceği
    
    var words: [String] {
        text.components(separatedBy: " ")
    }
    
    var body: some View {
        Text(displayedText)
            .font(.system(size: 20))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 30)
            .onAppear {
                startAnimation()
            }
    }
    
    private func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
            if currentIndex < words.count {
                let endIndex = min(currentIndex + wordsPerStep, words.count)
                let newWords = words[currentIndex..<endIndex].joined(separator: " ")
                if currentIndex > 0 {
                    displayedText += " " + newWords
                } else {
                    displayedText = newWords
                }
                currentIndex += wordsPerStep
            } else {
                timer.invalidate()
            }
        }
    }
}

struct TransitionView: View {
    @State private var isAnimating = false
    @State private var showDescription = false
    let title: String
    let description: String
    let buttonLabel: String
    let theme: TransitionTheme
    var onContinue: () -> Void
    
    var backgroundColors: [Color] {
        switch theme {
        case .forest: // Birinci geçiş için
            return [
                Color(red: 0.1, green: 0.1, blue: 0.15),
                Color(red: 0.15, green: 0.15, blue: 0.2)
            ]
        case .castle: // İkinci geçiş için
            return [
                Color(red: 0.2, green: 0.2, blue: 0.3),
                Color(red: 0.15, green: 0.15, blue: 0.25)
            ]
        case .bloody: // Üçüncü geçiş için
            return [
                Color(red: 0.3, green: 0.0, blue: 0.0),
                Color(red: 0.15, green: 0.0, blue: 0.0)
            ]
        case .haunted:
            return [
                Color(red: 0.05, green: 0.05, blue: 0.1),
                Color(red: 0.1, green: 0.0, blue: 0.2)
            ]
        case .battle:
            return [
                Color(red: 0.3, green: 0.1, blue: 0.1),  // Kızıl gökyüzü
                Color(red: 0.1, green: 0.0, blue: 0.0)   // Karanlık zemin
            ]
        case .epilogue:
            return [
                Color(red: 0.2, green: 0.2, blue: 0.4),  // Akşam gökyüzü
                Color(red: 0.1, green: 0.1, blue: 0.3)   // Saray atmosferi
            ]
        }
    }
    
    var themeSymbol: String {
        switch theme {
        case .forest:
            return "leaf.fill"
        case .castle:
            return "crown.fill"
        case .bloody:
            return "drop.fill"
        case .haunted:
            return "moon.stars.fill"
        case .battle:
            return "shield.lefthalf.filled.slash"  // Kırık kalkan simgesi
        case .epilogue:
            return "crown.fill"  // Taç simgesi
        }
    }
    
    var overlayEffect: some View {
        switch theme {
        case .forest:
            return AnyView(
                ZStack {
                    // Yaprak efekti
                    ForEach(0..<5) { index in
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.green.opacity(0.3))
                            .rotationEffect(.degrees(Double(index * 45)))
                            .offset(x: isAnimating ? CGFloat(index * 50) : -50,
                                   y: isAnimating ? CGFloat(index * 50) : -50)
                            .animation(
                                Animation.easeInOut(duration: 3)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.5),
                                value: isAnimating
                            )
                    }
                }
            )
            
        case .castle:
            return AnyView(
                ZStack {
                    // Parlayan taç efekti
                    ForEach(0..<3) { index in
                        Image(systemName: "crown.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.yellow.opacity(0.2))
                            .blur(radius: 5)
                            .scaleEffect(isAnimating ? 1.2 : 0.8)
                            .animation(
                                Animation.easeInOut(duration: 2)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.3),
                                value: isAnimating
                            )
                    }
                }
            )
            
        case .bloody:
            return AnyView(
                ZStack {
                    // Kan damlası efekti
                    ForEach(0..<8) { index in
                        Image(systemName: "drop.fill")
                            .foregroundColor(.red.opacity(0.3))
                            .rotationEffect(.degrees(Double(index * 45)))
                            .offset(y: isAnimating ? 200 : -50)
                            .animation(
                                Animation.easeIn(duration: 3)
                                    .repeatForever(autoreverses: false)
                                    .delay(Double(index) * 0.2),
                                value: isAnimating
                            )
                    }
                    // Kırmızı nabız efekti
                    Circle()
                        .fill(Color.red.opacity(0.2))
                        .blur(radius: 30)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .animation(
                            Animation.easeInOut(duration: 1)
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                }
            )
            
        case .haunted:
            return AnyView(
                ZStack {
                    // Hayalet efekti
                    ForEach(0..<5) { index in
                        Image(systemName: "person.fill.questionmark")
                            .font(.system(size: 30))
                            .foregroundColor(.white.opacity(0.1))
                            .blur(radius: 5)
                            .offset(
                                x: isAnimating ? CGFloat(sin(Double(index)) * 100) : 0,
                                y: isAnimating ? CGFloat(cos(Double(index)) * 100) : 0
                            )
                            .animation(
                                Animation.easeInOut(duration: 4)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.5),
                                value: isAnimating
                            )
                    }
                    
                    // Titreyen yıldızlar efekti
                    ForEach(0..<10) { index in
                        Image(systemName: "sparkle")
                            .font(.system(size: 15))
                            .foregroundColor(.white.opacity(0.3))
                            .offset(
                                x: CGFloat.random(in: -100...100),
                                y: CGFloat.random(in: -200...200)
                            )
                            .scaleEffect(isAnimating ? 1.2 : 0.8)
                            .animation(
                                Animation.easeInOut(duration: 1)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.1),
                                value: isAnimating
                            )
                    }
                }
            )
            
        case .battle:
            return AnyView(
                ZStack {
                    // Savaş dumanı efekti
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .blur(radius: 30)
                            .frame(width: 200, height: 200)
                            .offset(
                                x: isAnimating ? CGFloat.random(in: -100...100) : 0,
                                y: isAnimating ? CGFloat.random(in: -100...100) : 0
                            )
                            .animation(
                                Animation.easeInOut(duration: 4)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index)),
                                value: isAnimating
                            )
                    }
                    
                    // Kılıç ve kalkan efekti
                    HStack {
                        Image(systemName: "shield.lefthalf.filled")
                        Image(systemName: "bolt.horizontal.fill")
                    }
                    .font(.system(size: 40))
                    .foregroundColor(.orange.opacity(0.3))
                    .rotationEffect(.degrees(isAnimating ? 15 : -15))
                    .animation(
                        Animation.easeInOut(duration: 2)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
                    
                    // Yanan ateş efekti
                    ForEach(0..<5) { index in
                        Image(systemName: "flame.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.orange.opacity(0.2))
                            .offset(
                                x: CGFloat.random(in: -150...150),
                                y: CGFloat.random(in: -100...100)
                            )
                            .scaleEffect(isAnimating ? 1.2 : 0.8)
                            .animation(
                                Animation.easeInOut(duration: 1)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.2),
                                value: isAnimating
                            )
                    }
                }
            )
        case .epilogue:
            return AnyView(
                ZStack {
                    // Işık huzmesi efekti
                    ForEach(0..<5) { index in
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [.yellow.opacity(0.1), .clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 50, height: 300)
                            .rotationEffect(.degrees(Double(index * 30)))
                            .offset(y: -100)
                            .opacity(isAnimating ? 0.5 : 0.2)
                            .animation(
                                Animation.easeInOut(duration: 3)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.3),
                                value: isAnimating
                            )
                    }
                    
                    // Yıldız efekti
                    ForEach(0..<8) { index in
                        Image(systemName: "sparkle")
                            .font(.system(size: 20))
                            .foregroundColor(.yellow.opacity(0.3))
                            .offset(
                                x: CGFloat.random(in: -150...150),
                                y: CGFloat.random(in: -200...200)
                            )
                            .scaleEffect(isAnimating ? 1.2 : 0.8)
                            .animation(
                                Animation.easeInOut(duration: 2)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.2),
                                value: isAnimating
                            )
                    }
                    
                    // Taç efekti
                    Image(systemName: "crown.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.yellow.opacity(0.2))
                        .blur(radius: 5)
                        .offset(y: -50)
                        .scaleEffect(isAnimating ? 1.1 : 0.9)
                        .animation(
                            Animation.easeInOut(duration: 2)
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                }
            )
        }
    }
    
    var body: some View {
        ZStack {
            // Arka plan
            LinearGradient(gradient: Gradient(colors: backgroundColors),
                         startPoint: .top,
                         endPoint: .bottom)
                .ignoresSafeArea()
            
            // Tema efekti
            overlayEffect
            
            // Sis efekti
            GeometryReader { geometry in
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .blur(radius: 50)
                        .offset(x: isAnimating ? geometry.size.width : -geometry.size.width,
                               y: CGFloat(index * 100))
                        .frame(width: 100, height: 100)
                        .animation(
                            Animation.linear(duration: 8)
                                .repeatForever(autoreverses: false)
                                .delay(Double(index) * 4),
                            value: isAnimating
                        )
                }
            }
            
            VStack(spacing: 30) {
                // Başlık ve tema simgesi
                VStack(spacing: 10) {
                    Image(systemName: themeSymbol)
                        .font(.system(size: 50))
                        .foregroundColor(.white.opacity(0.8))
                        .symbolEffect(.bounce, options: .repeating, value: isAnimating)
                    
                    Text(title)
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 60)
                .opacity(isAnimating ? 1 : 0)
                .animation(.easeIn(duration: 1), value: isAnimating)
                
                Spacer()
                
                // Animasyonlu açıklama metni
                ScrollView {
                    if showDescription {
                        AnimatedText(text: description)
                    }
                }
                .frame(maxHeight: 300)
                
                Spacer()
                
                // Devam butonu
                Button(action: {
                    onContinue()
                }) {
                    Text(buttonLabel)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(width: 250, height: 50)
                        .background(Color.white)
                        .cornerRadius(25)
                }
                .opacity(isAnimating && showDescription ? 1 : 0)
                .animation(.easeIn(duration: 1), value: isAnimating && showDescription)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            isAnimating = true
            // Başlık gösterildikten sonra açıklama metnini başlat
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showDescription = true
            }
        }
        .preferredColorScheme(.dark) // Koyu tema zorla
    }
}

enum TransitionTheme {
    case forest    // Birinci geçiş için
    case castle    // İkinci geçiş için
    case bloody    // Üçüncü geçiş için
    case haunted   // Dördüncü geçiş için
    case battle    // Beşinci geçiş için
    case epilogue  // Son sahne için - törensel tema
}

#Preview {
    TransitionView(
        title: "The Prophecy Lingers",
        description: "The witches vanish into the mist, leaving Macbeth and Banquo to ponder their strange words. Suddenly, a messenger arrives to inform Macbeth that he is now the Thane of Cawdor, fulfilling part of the prophecy. Kehanetin ilk kısmı gerçekleşmiştir. Macbeth is bewildered; is this merely a coincidence, or do the witches’ words signify something more?",
        buttonLabel: "Continue to Castle Arrival",
        theme: .forest,
        onContinue: {}
    )
} 
