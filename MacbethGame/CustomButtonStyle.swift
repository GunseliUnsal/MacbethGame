import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(color.opacity(0.6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
} 