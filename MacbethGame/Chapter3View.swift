import SwiftUI

struct Chapter3View: View {
    @State private var selectedChoice: Int? = nil
    @State private var showingDialogue = false
    @State private var currentDialogues: [DialogueMessage] = []
    @State private var currentDialogueIndex = 0
    @State private var showTapPrompt = true
    @State private var showFullHistory = false
    var onContinue: () -> Void
    
    let acceptDialogues = [
        DialogueMessage(character: "Lady Macbeth", text: "Glamis thou art, and Cawdor, and shalt be what thou art promised. Yet I do fear thy nature; it is too full o' the milk of human kindness."),
        DialogueMessage(character: "Macbeth", text: "My dearest love, Duncan comes here tonight."),
        DialogueMessage(character: "Lady Macbeth", text: "O, never shall sun that morrow see! Your face, my thane, is as a book where men may read strange matters."),
        DialogueMessage(character: "Macbeth", text: "If it were done when 'tis done, then 'twere well it were done quickly..."),
        DialogueMessage(character: "Lady Macbeth", text: "He that's coming must be provided for: and you shall put this night's great business into my dispatch."),
        DialogueMessage(character: "Macbeth", text: "I am settled, and bend up each corporal agent to this terrible feat."),
        DialogueMessage(character: "Lady Macbeth", text: "Leave all the rest to me. The raven himself is hoarse that croaks the fatal entrance of Duncan under my battlements.")
    ]
    
    let refuseDialogues = [
        DialogueMessage(character: "Macbeth", text: "He's here in double trust: First, as I am his kinsman and his subject, strong both against the deed..."),
        DialogueMessage(character: "Lady Macbeth", text: "Was the hope drunk wherein you dressed yourself? Hath it slept since?"),
        DialogueMessage(character: "Macbeth", text: "I dare do all that may become a man; who dares do more is none."),
        DialogueMessage(character: "Lady Macbeth", text: "What beast was't, then, that made you break this enterprise to me?"),
        DialogueMessage(character: "Macbeth", text: "Prithee, peace: I dare not, yet I would."),
        DialogueMessage(character: "Lady Macbeth", text: "Art thou afeard to be the same in thine own act and valor as thou art in desire?"),
        DialogueMessage(character: "Macbeth", text: "If we should fail?"),
        DialogueMessage(character: "Lady Macbeth", text: "We fail? But screw your courage to the sticking-place, and we'll not fail!")
    ]
    
    var body: some View {
        ZStack {
            // Arka plan rengi - Lady Macbeth'in karanlık doğasını yansıtan koyu kırmızı ton
            Color(red: 0.2, green: 0.05, blue: 0.1)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Başlık
                Text("Lady Macbeth's Persuasion")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                // Karakter görselleri
                HStack(spacing: 40) {
                    CharacterView(name: "Lady Macbeth", symbol: "crown.fill")
                        .overlay(
                            Image(systemName: "flame.fill")
                                .foregroundColor(.red)
                                .offset(y: -20)
                        )
                    CharacterView(name: "Macbeth", symbol: "person.fill")
                }
                .padding(.top, 20)
                
                // Açıklama
                Text("Lady Macbeth learns of the prophecy and persuades Macbeth to seize the throne.")
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
                                showFullHistory = true
                            }
                        }
                    }
                } else {
                    // Seçenekler
                    VStack(spacing: 20) {
                        Button(action: {
                            selectedChoice = 0
                            currentDialogues = acceptDialogues
                            showingDialogue = true
                        }) {
                            Text("Agree to Lady Macbeth's plan")
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
                            Text("Refuse and argue with her")
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
}

#Preview {
    Chapter3View(onContinue: {})
} 