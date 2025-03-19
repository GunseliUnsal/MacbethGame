import SwiftUI

struct DialogueMessage: Identifiable {
    let id = UUID()
    let character: String
    let text: String
}

struct Chapter1View: View {
    @State private var selectedChoice: Int? = nil
    @State private var showingDialogue = false
    @State private var currentDialogues: [DialogueMessage] = []
    @State private var currentDialogueIndex = 0
    @State private var showTapPrompt = true
    @State private var showFullHistory = false
    
    let prophecyDialogues = [
        DialogueMessage(character: "Witch 1", text: "All hail, Macbeth! Hail to thee, Thane of Glamis!"),
        DialogueMessage(character: "Witch 2", text: "All hail, Macbeth! Hail to thee, Thane of Cawdor!"),
        DialogueMessage(character: "Witch 3", text: "All hail, Macbeth, that shalt be King hereafter!"),
        DialogueMessage(character: "Macbeth", text: "Stay, you imperfect speakers, tell me more. By Sinel's death I know I am Thane of Glamis, but how of Cawdor?"),
        DialogueMessage(character: "Banquo", text: "Good sir, why do you start and seem to fear things that do sound so fair? Speak to me too, if you can look into the seeds of time."),
        DialogueMessage(character: "Witch 1", text: "Hail, lesser than Macbeth, and greater!"),
        DialogueMessage(character: "Witch 2", text: "Not so happy, yet much happier!"),
        DialogueMessage(character: "Witch 3", text: "Thou shalt get kings, though thou be none. So all hail, Macbeth and Banquo!"),
        DialogueMessage(character: "Macbeth", text: "Tell me more... Why do you dress me in borrowed robes of Cawdor?"),
        DialogueMessage(character: "Banquo", text: "The earth hath bubbles, as the water has, and these are of them. Whither are they vanished?")
    ]
    
    let mockingDialogues = [
        DialogueMessage(character: "Macbeth", text: "Ha! These are but wild and whirling words. Speak plainly, you midnight hags!"),
        DialogueMessage(character: "Witch 1", text: "The power of darkness is not to be mocked, Thane of Glamis."),
        DialogueMessage(character: "Witch 2", text: "Time shall unfold what pleated cunning hides."),
        DialogueMessage(character: "Witch 3", text: "When the hurlyburly's done, when the battle's lost and won, you shall understand the price of doubt."),
        DialogueMessage(character: "Banquo", text: "Macbeth, these creatures speak in riddles. Perhaps we should not provoke what we don't understand."),
        DialogueMessage(character: "Macbeth", text: "Riddles and vapors, nothing more! Yet... why does my heart knock against my ribs?"),
        DialogueMessage(character: "Witch 1", text: "Double, double toil and trouble; Fire burn, and cauldron bubble!"),
        DialogueMessage(character: "Banquo", text: "Look how our partner's rapt... These words have struck deep, despite your mockery.")
    ]
    
    var onContinue: () -> Void
    
    var body: some View {
        ZStack {
            // Arka plan rengi
            Color.black.opacity(0.9)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Başlık
                Text("The Witches' Prophecy")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                // Karakter görselleri
                HStack(spacing: 40) {
                    CharacterView(name: "Macbeth", symbol: "person.fill")
                    CharacterView(name: "Banquo", symbol: "person.2.fill")
                    CharacterView(name: "Witches", symbol: "sparkles")
                }
                .padding(.top, 20)
                
                // Açıklama
                Text("Macbeth and Banquo encounter three witches who predict their futures.")
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
                    .padding(.vertical, 20)
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
                        ChoiceButton(text: "Speak with the witches and learn their prophecy") {
                            selectedChoice = 0
                            currentDialogues = prophecyDialogues
                            showingDialogue = true
                        }
                        
                        ChoiceButton(text: "Mock the witches and question their powers") {
                            selectedChoice = 1
                            currentDialogues = mockingDialogues
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

struct CharacterView: View {
    let name: String
    let symbol: String
    
    var body: some View {
        VStack {
            Image(systemName: symbol)
                .font(.system(size: 40))
                .foregroundColor(.white)
            Text(name)
                .font(.caption)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    Chapter1View(onContinue: {})
} 
