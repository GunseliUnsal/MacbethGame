import SwiftUI

struct Chapter5View: View {
    @State private var selectedChoice: Int? = nil
    @State private var showingDialogue = false
    @State private var currentDialogues: [DialogueMessage] = []
    @State private var ghostOpacity = 0.0
    @State private var currentDialogueIndex = 0
    @State private var showTapPrompt = true
    @State private var showFullHistory = false
    var onContinue: () -> Void
    
    let faceDialogues = [
        DialogueMessage(character: "Macbeth", text: "Thou canst not say I did it: never shake thy gory locks at me!"),
        DialogueMessage(character: "Lady Macbeth", text: "Sit, worthy friends: my lord is often thus, and hath been from his youth."),
        DialogueMessage(character: "Banquo's Ghost", text: "Here is your crown, and here your feast. But know that blood will have blood."),
        DialogueMessage(character: "Macbeth", text: "Avaunt! and quit my sight! Let the earth hide thee! Thy bones are marrowless, thy blood is cold."),
        DialogueMessage(character: "Lady Macbeth", text: "Think of this, good peers, but as a thing of custom: 'tis no other."),
        DialogueMessage(character: "Macbeth", text: "What man dare, I dare. Take any shape but that, and my firm nerves shall never tremble."),
        DialogueMessage(character: "Banquo's Ghost", text: "The times have been that, when the brains were out, the man would die, and there an end."),
        DialogueMessage(character: "Lady Macbeth", text: "You have displaced the mirth, broke the good meeting, with most admired disorder.")
    ]
    
    let ignoreDialogues = [
        DialogueMessage(character: "Macbeth", text: "It will have blood, they say: blood will have blood. Stones have been known to move, and trees to speak."),
        DialogueMessage(character: "Lady Macbeth", text: "You lack the season of all natures, sleep. What's done is done."),
        DialogueMessage(character: "Macbeth", text: "Better be with the dead, whom we, to gain our peace, have sent to peace."),
        DialogueMessage(character: "Lady Macbeth", text: "Come on. Gentle my lord, sleek o'er your rugged looks; be bright and jovial among your guests tonight."),
        DialogueMessage(character: "Banquo's Ghost", text: "Your crown sits heavy, usurper. The seeds of your destruction grow within."),
        DialogueMessage(character: "Macbeth", text: "I am in blood stepped in so far that, should I wade no more, returning were as tedious as go o'er.")
    ]
    
    var body: some View {
        ZStack {
            // Karanlık ziyafet salonu atmosferi
            Color(red: 0.05, green: 0.05, blue: 0.1)
                .ignoresSafeArea()
            
            // Hayalet efekti için mavi gradient
            RadialGradient(
                gradient: Gradient(colors: [.blue.opacity(0.2), .clear]),
                center: .center,
                startRadius: 50,
                endRadius: 250
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Başlık
                Text("The Ghost of Banquo")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                // Karakter görselleri ve hayalet efekti
                HStack(spacing: 40) {
                    CharacterView(name: "Macbeth", symbol: "crown.fill")
                    
                    // Hayalet efekti
                    ZStack {
                        CharacterView(name: "Banquo", symbol: "person.fill.questionmark")
                            .opacity(ghostOpacity)
                            .blur(radius: 1)
                            .overlay(
                                Circle()
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 2)
                                    .scaleEffect(ghostOpacity * 1.2)
                            )
                    }
                    .animation(
                        Animation.easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true),
                        value: ghostOpacity
                    )
                    .onAppear {
                        ghostOpacity = 0.7
                    }
                    
                    CharacterView(name: "Lady Macbeth", symbol: "crown.fill")
                }
                .padding(.top, 20)
                
                // Açıklama
                Text("At a royal banquet, Macbeth is haunted by Banquo's ghost, a reminder of his sins.")
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
                            currentDialogues = faceDialogues
                            showingDialogue = true
                        }) {
                            Text("Face the ghost")
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
                            currentDialogues = ignoreDialogues
                            showingDialogue = true
                        }) {
                            Text("Ignore the ghost")
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
        case "Banquo's Ghost":
            return Color.blue.opacity(0.3)
        default:
            return Color.gray.opacity(0.3)
        }
    }
}

// Hayalet efekti için özel modifier
struct GhostEffect: ViewModifier {
    let isGhost: Bool
    
    func body(content: Content) -> some View {
        if isGhost {
            content
                .blur(radius: 0.5)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                )
        } else {
            content
        }
    }
}

#Preview {
    Chapter5View(onContinue: {})
} 