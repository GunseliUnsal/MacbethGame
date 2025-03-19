import SwiftUI

struct Chapter2View: View {
    @State private var selectedChoice: Int? = nil
    @State private var showingDialogue = false
    @State private var currentDialogues: [DialogueMessage] = []
    @State private var currentDialogueIndex = 0
    @State private var showTapPrompt = true
    @State private var showFullHistory = false
    var onContinue: () -> Void
    
    let humbleDialogues = [
        DialogueMessage(character: "Macbeth", text: "The Thane of Cawdor lives. Why do you dress me in borrowed robes?"),
        DialogueMessage(character: "Ross", text: "He who was the Thane of Cawdor lives indeed, but under heavy judgment bears that life which he deserves to lose."),
        DialogueMessage(character: "Macbeth", text: "Glamis, and Thane of Cawdor! The greatest is behind. My humble thanks for your pains."),
        DialogueMessage(character: "Banquo", text: "That trusted home might yet enkindle you unto the crown, besides the Thane of Cawdor."),
        DialogueMessage(character: "Macbeth", text: "If chance will have me king, why, chance may crown me without my stir."),
        DialogueMessage(character: "Banquo", text: "The instruments of darkness tell us truths, win us with honest trifles, to betray's in deepest consequence.")
    ]
    
    let ponderDialogues = [
        DialogueMessage(character: "Macbeth", text: "Two truths are told, as happy prologues to the swelling act of the imperial theme."),
        DialogueMessage(character: "Banquo", text: "Look, how our partner's rapt. This supernatural soliciting cannot be ill, cannot be good."),
        DialogueMessage(character: "Macbeth", text: "If ill, why hath it given me earnest of success, commencing in a truth? I am Thane of Cawdor."),
        DialogueMessage(character: "Banquo", text: "New honors come upon him, like our strange garments, cleave not to their mould but with the aid of use."),
        DialogueMessage(character: "Macbeth", text: "If good, why do I yield to that suggestion whose horrid image doth unfix my hair and make my seated heart knock at my ribs?"),
        DialogueMessage(character: "Banquo", text: "Worthy Macbeth, we stay upon your leisure. Yet I fear your thoughts stray to darker purposes."),
        DialogueMessage(character: "Macbeth", text: "If chance will have me king, why, chance may crown me without my stir... Yet the crown beckons.")
    ]
    
    var body: some View {
        ZStack {
            // Arka plan rengi
            Color(red: 0.1, green: 0.1, blue: 0.2)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Başlık
                Text("The Thane of Cawdor")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                // Karakter görselleri - bu sefer farklı simgeler
                HStack(spacing: 40) {
                    CharacterView(name: "Macbeth", symbol: "crown.fill")
                    CharacterView(name: "Banquo", symbol: "person.2.fill")
                    CharacterView(name: "Messenger", symbol: "scroll.fill")
                }
                .padding(.top, 20)
                
                // Açıklama
                Text("Macbeth is informed that he has been named Thane of Cawdor, confirming part of the witches' prophecy.")
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
                        ChoiceButton(text: "Accept the title humbly") {
                            selectedChoice = 0
                            currentDialogues = humbleDialogues
                            showingDialogue = true
                        }
                        
                        ChoiceButton(text: "Begin to ponder the prophecy") {
                            selectedChoice = 1
                            currentDialogues = ponderDialogues
                            showingDialogue = true
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
    Chapter2View(onContinue: {})
} 