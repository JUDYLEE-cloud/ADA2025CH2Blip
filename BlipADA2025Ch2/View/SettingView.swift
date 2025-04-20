import SwiftUI
import FirebaseAuth

struct SettingView: View {
    @StateObject private var viewModel = AuthViewModel()
    @Environment(\.dismiss) var dismiss
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    var body: some View {
        ZStack {
            Color("BackgroundBlack")
                .ignoresSafeArea()
            
            VStack {
                Text("안녕하세요, \(viewModel.storedNickname)님!")
                    .foregroundColor(.white)
                    .font(.title2)
                    .padding(.top, 20)
                
                Spacer()

                Button(action: {
                    viewModel.logout()
                    isLoggedIn = false
                }) {
                    Text("로그아웃")
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                }

                Spacer()
            }
        }
    }
}

#Preview {
    SettingView()
}
