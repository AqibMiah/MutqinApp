import SwiftUI

struct OnboardingView: View {
    @State private var isActive = false
    @State private var showLogin = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                Color(hex: "0E5C53")
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Logo
                    ZStack {
                        Rectangle()
                            .fill(.white)
                            .frame(width: 150, height: 150)
                            .cornerRadius(10)
                        
                        Text("Mutqin")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(Color(hex: "0E5C53"))
                    }
                    .padding(.top, 60)
                    
                    // Main text
                    VStack(spacing: 16) {
                        Text("Your journey to memorizing")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        Text("the Quran begins here.")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Learn, memorize and perfect your recitation")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.top, 8)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Buttons
                    VStack(spacing: 16) {
                        NavigationLink(destination: SignUpView()) {
                            Text("Get Started")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(Color(hex: "0E5C53"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                        
                        NavigationLink(destination: LoginView()) {
                            Text("Login")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                        }
                    
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// Color extension to support hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// Preview provider
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
} 
