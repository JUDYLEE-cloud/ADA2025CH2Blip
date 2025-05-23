import SwiftUI
import FirebaseAuth

struct SplashView: View {
    @State private var circleAnimate = false
    @State private var showBlip = false
    @State private var isActive = false
    
    @State private var isLoggedIn = false
    
    var body: some View {
        if isActive {
            if isLoggedIn {
                HomeView()
            } else {
                LoginView()
            }
        } else {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "#4ADD85").opacity(0.7))
                            .frame(width: circleAnimate ? 170 : 100, height: circleAnimate ? 170: 100)
                            .blur(radius: circleAnimate ? 100 : 20)
                            .animation(
                                .easeOut(duration: 0.5), value: circleAnimate)
                        
                        Image("mainIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 350)
                            .padding(.leading, 15)
                    }
                    
                    Image("Blip!")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 107, height: 71)
                        .padding(.top, 10)
                        .opacity(showBlip ? 1 : 0)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    circleAnimate = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showBlip = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                self.isActive = true
                                self.isLoggedIn = Auth.auth().currentUser != nil
                            }
                        }
                    }
                }
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    SplashView()
}
