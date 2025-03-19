import SwiftUI

struct DialogueAnimationModifier: ViewModifier {
    let isCurrentMessage: Bool
    let isLastMessage: Bool
    let character: String
    @Binding var showFullHistory: Bool
    
    func body(content: Content) -> some View {
        content
            .opacity(isCurrentMessage || showFullHistory ? 1 : 0)
            .offset(x: calculateOffset(), y: 0)
            .scaleEffect(isCurrentMessage && !showFullHistory ? 1.05 : 1.0)
            .animation(.spring(duration: 0.5), value: isCurrentMessage)
    }
    
    private func calculateOffset() -> CGFloat {
        if !showFullHistory {
            return character == "Macbeth" ? -20 : 20
        }
        return character == "Macbeth" ? -20 : 20
    }
}

extension View {
    func dialogueAnimation(isCurrentMessage: Bool, isLastMessage: Bool, character: String, showFullHistory: Binding<Bool>) -> some View {
        modifier(DialogueAnimationModifier(
            isCurrentMessage: isCurrentMessage,
            isLastMessage: isLastMessage,
            character: character,
            showFullHistory: showFullHistory
        ))
    }
} 