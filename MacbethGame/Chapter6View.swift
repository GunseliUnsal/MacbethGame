import SwiftUI

struct Chapter6View: View {
    @State private var selectedChoice: Int? = nil
    @State private var showingDialogue = false
    @State private var currentDialogues: [DialogueMessage] = []
    @State private var swordAngle = 0.0
    @State private var currentDialogueIndex = 0
    @State private var showTapPrompt = true
    @State private var showFullHistory = false
    var onContinue: () -> Void
    
    let fightDialogues = [
        DialogueMessage(character: "Macbeth", text: "They have tied me to a stake; I cannot fly, but, bear-like, I must fight the course."),
        DialogueMessage(character: "Macduff", text: "Turn, hell-hound, turn! Of all men else I have avoided thee. My voice is in my sword!"),
        DialogueMessage(character: "Macbeth", text: "Let fall thy blade on vulnerable crests; I bear a charmed life, which must not yield to one of woman born."),
        DialogueMessage(character: "Macduff", text: "Despair thy charm, and let the angel whom thou still hast served tell thee, Macduff was from his mother's womb untimely ripped."),
        DialogueMessage(character: "Macbeth", text: "Accursed be that tongue that tells me so, for it hath cow'd my better part of man!"),
        DialogueMessage(character: "Macduff", text: "Then yield thee, coward, and live to be the show and gaze o' the time!"),
        DialogueMessage(character: "Macbeth", text: "I will not yield to kiss the ground before young Malcolm's feet, and to be baited with the rabble's curse.")
    ]
    
    let surrenderDialogues = [
        DialogueMessage(character: "Macbeth", text: "Why should I play the Roman fool, and die on mine own sword? Whiles I see lives, the gashes do better upon them."),
        DialogueMessage(character: "Macduff", text: "Then yield thee, coward, and live to be the show and gaze o' the time."),
        DialogueMessage(character: "Macbeth", text: "Of all men else I have avoided thee: but get thee back; my soul is too much charged with blood of thine already."),
        DialogueMessage(character: "Macduff", text: "I have no words: my voice is in my sword, thou bloodier villain than terms can give thee out!"),
        DialogueMessage(character: "Macbeth", text: "Though Birnam wood be come to Dunsinane, and thou opposed, being of no woman born, yet I will try the last."),
        DialogueMessage(character: "Macduff", text: "Your kingdom stands on brittle glass. The time is free.")
    ]
    
    var body: some View {
        ZStack {
            // Savaş atmosferi için arka plan
            Color(red: 0.2, green: 0.0, blue: 0.0)
                .ignoresSafeArea()
            
            // Savaş efekti için gradient
            RadialGradient(
                gradient: Gradient(colors: [.orange.opacity(0.3), .clear]),
                center: .center,
                startRadius: 100,
                endRadius: 300
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Başlık
                Text("Battle with Macduff")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                // Karakter görselleri ve kılıç animasyonu
                HStack(spacing: 40) {
                    CharacterView(name: "Macbeth", symbol: "shield.fill")
                    
                    // Animasyonlu kılıç
                    Image(systemName: "bolt.horizontal.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.orange)
                        .rotationEffect(.degrees(swordAngle))
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: swordAngle
                        )
                        .onAppear {
                            swordAngle = 360
                        }
                    
                    CharacterView(name: "Macduff", symbol: "person.fill.checkmark")
                }
                .padding(.top, 20)
                
                // Açıklama
                Text("The final confrontation: Macbeth must face Macduff, whose family he destroyed.")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                
                Spacer()
                
                if showingDialogue {
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
                                showFullHistory = true
                            }
                        }
                    }
                } else {
                    // Seçenekler
                    VStack(spacing: 20) {
                        Button(action: {
                            selectedChoice = 0
                            currentDialogues = fightDialogues
                            showingDialogue = true
                        }) {
                            Text("Fight Macduff")
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
                            currentDialogues = surrenderDialogues
                            showingDialogue = true
                        }) {
                            Text("Surrender to fate")
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
                        Text("Continue to Epilogue")
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
            return Color.red.opacity(0.3)
        case "Macduff":
            return Color.orange.opacity(0.3)
        default:
            return Color.gray.opacity(0.3)
        }
    }
}

// Savaş efekti için özel modifier
struct BattleEffect: ViewModifier {
    let isFighting: Bool
    
    func body(content: Content) -> some View {
        if isFighting {
            content
                .shadow(color: .red.opacity(0.5), radius: 5, x: 0, y: 0)
        } else {
            content
        }
    }
}

#Preview {
    Chapter6View(onContinue: {})
} 