import SwiftUI

struct IntroView: View {
    @State private var isAnimating = false
    var onBeginTapped: () -> Void
    
    var body: some View {
        ZStack {
            Image("macbeth")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Text("Macbeth Interactive")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 100)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.easeIn(duration: 1.2), value: isAnimating)
                
                Text("Step into the world of Shakespeare's Macbeth, where ambition and fate intertwine. Experience the key events of this timeless tragedy, make choices, and uncover its lessons.")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                    .padding(.horizontal)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.easeIn(duration: 1.2).delay(0.5), value: isAnimating)
                
                Spacer()
                

                Button(action: {
                    onBeginTapped()
                }) {
                    Text("Begin")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(width: 200, height: 50)
                        .background(Color.white)
                        .cornerRadius(25)
                }
                .padding(.bottom, 50)
                .opacity(isAnimating ? 1 : 0)
                .animation(.easeIn(duration: 1.2).delay(1), value: isAnimating)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    IntroView(onBeginTapped: {})
} 
