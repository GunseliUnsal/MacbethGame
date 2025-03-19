import SwiftUI

struct DialogueBubble: View {
    let character: String
    let text: String
    
    private var alignment: HorizontalAlignment {
        character == "Macbeth" ? .leading : .trailing
    }
    
    private var backgroundColor: Color {
        switch character {
        case "Macbeth":
            return Color.purple.opacity(0.3)
        case "Lady Macbeth":
            return Color.red.opacity(0.3)
        case "Banquo":
            return Color.blue.opacity(0.3)
        case "Witch 1", "Witch 2", "Witch 3":
            return Color.green.opacity(0.3)
        default:
            return Color.gray.opacity(0.3)
        }
    }
    
    private var textColor: Color {
        switch character {
        case "Lady Macbeth":
            return .red
        case "Witch 1", "Witch 2", "Witch 3":
            return .green
        default:
            return .yellow
        }
    }
    
    var body: some View {
        VStack(alignment: alignment) {
            Text(character)
                .font(.headline)
                .foregroundColor(textColor)
            
            Text(text)
                .font(.body)
                .foregroundColor(.white)
                .multilineTextAlignment(alignment == .leading ? .leading : .trailing)
        }
        .frame(maxWidth: .infinity, alignment: alignment == .leading ? .leading : .trailing)
        .padding()
        .background(backgroundColor)
        .cornerRadius(15)
        .padding(.horizontal)
    }
}
