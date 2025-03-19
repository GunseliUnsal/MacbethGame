import SwiftUI

struct EpilogueView: View {
    @State private var isAnimating = false
    @State private var currentDialogueIndex = 0
    @State private var showTapPrompt = true
    var onPlayAgain: () -> Void
    
    let epilogueDialogues = [
        DialogueMessage(character: "Narrator", text: "And so ends the tale of Macbeth, a man consumed by ambition and undone by fate."),
        DialogueMessage(character: "Malcolm", text: "Let peace reign in Scotland, and may such tyranny never rise again.")
    ]
    
    var body: some View {
        ZStack {
            // Taht odası atmosferi
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.2, green: 0.2, blue: 0.3),
                    Color(red: 0.1, green: 0.1, blue: 0.2)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Işık efekti
            RadialGradient(
                gradient: Gradient(colors: [.yellow.opacity(0.2), .clear]),
                center: .top,
                startRadius: 50,
                endRadius: 400
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Başlık
                Text("The Fall of Macbeth")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 60)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.easeIn(duration: 1.5), value: isAnimating)
                
                // Taht simgesi
                Image(systemName: "crown.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.yellow)
                    .opacity(isAnimating ? 1 : 0)
                    .scaleEffect(isAnimating ? 1 : 0.5)
                    .animation(.easeIn(duration: 1.5).delay(0.5), value: isAnimating)
                
                // Açıklama
                Text("Macbeth meets his fate, and Malcolm is crowned king, restoring order to Scotland.")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.easeIn(duration: 1.5).delay(1), value: isAnimating)
                
                Spacer()
                
                // Diyaloglar
                VStack(spacing: 20) {
                    ForEach(0...currentDialogueIndex, id: \.self) { index in
                        if index < epilogueDialogues.count {
                            EpilogueBubble(character: epilogueDialogues[index].character,
                                         text: epilogueDialogues[index].text)
                                .opacity(isAnimating ? 1 : 0)
                                .offset(y: isAnimating ? 0 : 50)
                        }
                    }
                }
                .animation(.easeIn(duration: 1.5).delay(1.5), value: isAnimating)
                .padding(.horizontal, 20)
                .overlay(
                    showTapPrompt ?
                    Text("Tap to continue...")
                        .foregroundColor(.white.opacity(0.7))
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(10)
                        .padding(.bottom, 10)
                        .transition(.opacity)
                    : nil,
                    alignment: .bottom
                )
                .onTapGesture {
                    withAnimation {
                        if currentDialogueIndex < epilogueDialogues.count - 1 {
                            currentDialogueIndex += 1
                        } else {
                            showTapPrompt = false
                        }
                    }
                }
                
                // Play Again butonu
                if !showTapPrompt {
                    Button(action: {
                        onPlayAgain()
                    }) {
                        Text("Play Again")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(width: 200, height: 50)
                            .background(Color.white)
                            .cornerRadius(25)
                    }
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.easeIn(duration: 1.5).delay(2), value: isAnimating)
                    .padding(.bottom, 50)
                }
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct EpilogueBubble: View {
    let character: String
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(character)
                .font(.headline)
                .foregroundColor(.yellow)
            
            Text(text)
                .font(.body)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(15)
    }
}

#Preview {
    EpilogueView(onPlayAgain: {})
} 