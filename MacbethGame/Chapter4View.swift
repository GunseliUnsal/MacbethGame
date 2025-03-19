import SwiftUI

struct Chapter4View: View {
    @State private var selectedChoice: Int? = nil
    @State private var showingDialogue = false
    @State private var currentDialogues: [DialogueMessage] = []
    @State private var isAnimatingDagger = false
    @State private var currentDialogueIndex = 0
    @State private var showTapPrompt = true
    @State private var showFullHistory = false
    var onContinue: () -> Void
    
    let murderDialogues = [
        DialogueMessage(character: "Macbeth", text: "Is this a dagger which I see before me, the handle toward my hand? Come, let me clutch thee."),
        DialogueMessage(character: "Macbeth", text: "I have thee not, and yet I see thee still. Art thou not, fatal vision, sensible to feeling as to sight?"),
        DialogueMessage(character: "Macbeth", text: "I go, and it is done; the bell invites me. Hear it not, Duncan, for it is a knell that summons thee to heaven or to hell."),
        DialogueMessage(character: "Lady Macbeth", text: "That which hath made them drunk hath made me bold; what hath quenched them hath given me fire."),
        DialogueMessage(character: "Macbeth", text: "I have done the deed. Didst thou not hear a noise?"),
        DialogueMessage(character: "Lady Macbeth", text: "I heard the owl scream and the crickets cry. Did not you speak?"),
        DialogueMessage(character: "Macbeth", text: "Methought I heard a voice cry 'Sleep no more! Macbeth does murder sleep.'"),
        DialogueMessage(character: "Lady Macbeth", text: "A little water clears us of this deed: How easy is it, then!")
    ]
    
    let refuseDialogues = [
        DialogueMessage(character: "Macbeth", text: "We will proceed no further in this business. He hath honored me of late."),
        DialogueMessage(character: "Lady Macbeth", text: "Was the hope drunk wherein you dressed yourself? From this time such I account thy love."),
        DialogueMessage(character: "Macbeth", text: "I dare do all that may become a man; who dares do more is none."),
        DialogueMessage(character: "Lady Macbeth", text: "When you durst do it, then you were a man; And, to be more than what you were, you would be so much more the man."),
        DialogueMessage(character: "Macbeth", text: "My hands are of your colour; but I shame to wear a heart so white."),
        DialogueMessage(character: "Lady Macbeth", text: "These deeds must not be thought after these ways; so, it will make us mad.")
    ]
    
    var body: some View {
        ZStack {
            // Karanlık ve kanlı bir atmosfer için arka plan
            Color.black
                .ignoresSafeArea()
            
            // Kırmızı gradient efekti
            RadialGradient(
                gradient: Gradient(colors: [.red.opacity(0.2), .clear]),
                center: .center,
                startRadius: 100,
                endRadius: 300
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Başlık
                Text("The Murder of King Duncan")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                // Karakter görselleri ve hançer animasyonu
                HStack(spacing: 40) {
                    CharacterView(name: "Duncan", symbol: "moon.stars.fill")
                    
                    // Animasyonlu hançer
                    Image(systemName: "shield.lefthalf.filled")
                        .font(.system(size: 40))
                        .foregroundColor(.red)
                        .rotationEffect(.degrees(isAnimatingDagger ? 180 : 0))
                        .animation(
                            Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                            value: isAnimatingDagger
                        )
                        .onAppear {
                            isAnimatingDagger = true
                        }
                    
                    CharacterView(name: "Macbeth", symbol: "person.fill")
                }
                .padding(.top, 20)
                
                // Açıklama
                Text("As Duncan sleeps in Macbeth's castle, the moment of decision arrives.")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                
                Spacer()
                
                if showingDialogue {
                    // Diyalog görünümü
                    ScrollView {
                        VStack(spacing: 15) {
                            if showFullHistory {
                                // Tüm konuşmalar bittiğinde liste görünümü
                                ForEach(0..<currentDialogues.count, id: \.self) { index in
                                    DialogueBubble(
                                        character: currentDialogues[index].character,
                                        text: currentDialogues[index].text
                                    )
                                }
                            } else {
                                // Aktif konuşma için ortalanmış görünüm
                                Spacer()
                                if currentDialogueIndex < currentDialogues.count {
                                    DialogueBubble(
                                        character: currentDialogues[currentDialogueIndex].character,
                                        text: currentDialogues[currentDialogueIndex].text
                                    )
                                    .dialogueAnimation(
                                        isCurrentMessage: true,
                                        isLastMessage: currentDialogueIndex == currentDialogues.count - 1,
                                        character: currentDialogues[currentDialogueIndex].character,
                                        showFullHistory: $showFullHistory
                                    )
                                }
                                Spacer()
                            }
                        }
                        .padding()
                    }
                    .frame(maxHeight: 400)
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
                            if currentDialogueIndex < currentDialogues.count - 1 {
                                currentDialogueIndex += 1
                            } else {
                                showTapPrompt = false
                            }
                        }
                    }
                } else {
                    // Seçenekler
                    VStack(spacing: 20) {
                        Button(action: {
                            selectedChoice = 0
                            currentDialogues = murderDialogues
                            showingDialogue = true
                        }) {
                            Text("Carry out the murder")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.purple.opacity(0.6))
                                .cornerRadius(15)
                        }
                        
                        Button(action: {
                            selectedChoice = 1
                            currentDialogues = refuseDialogues
                            showingDialogue = true
                        }) {
                            Text("Refuse at the last moment")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.purple.opacity(0.6))
                                .cornerRadius(15)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                if showingDialogue && !showTapPrompt {
                    Button(action: {
                        onContinue()
                    }) {
                        Text("Continue")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(width: 200, height: 50)
                            .background(Color.white)
                            .cornerRadius(25)
                    }
                    .padding(.bottom, 30)
                }
            }
        }
    }
    
    private func getBubbleColor(for character: String) -> Color {
        switch character {
        case "Macbeth":
            return Color.purple.opacity(0.3)
        case "Lady Macbeth":
            return Color.red.opacity(0.3)
        default:
            return Color.gray.opacity(0.3)
        }
    }
}

// Özel DialogueBubble stili
extension DialogueBubble {
    var bloodEffect: some View {
        self.overlay(
            Circle()
                .fill(Color.red)
                .frame(width: 5, height: 5)
                .blur(radius: 2)
                .offset(x: -10, y: -10)
        )
    }
}

#Preview {
    Chapter4View(onContinue: {})
} 