import SwiftUI

struct ChoiceButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 18))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.purple.opacity(0.6))
                .cornerRadius(15)
        }
    }
} 
