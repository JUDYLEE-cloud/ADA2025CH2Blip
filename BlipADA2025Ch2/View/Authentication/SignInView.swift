import SwiftUI

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signIn() {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        Task {
            do {
                let returnUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
                print("Sign in Success")
                print(returnUserData)
            } catch {
                print("Error: \(error)")
            }
        }
    }
}

struct SignInView: View {
    @StateObject private var viewModel = SignInEmailViewModel()
    
    var body: some View {
        ZStack {
            Color("BackgroundBlack")
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Image("mainIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 130)
                        .padding(.leading, -20)
                    
                    Spacer()
                }
                .padding(.top, 40)
                
                Image("SignInTitle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .infinity)
                    .padding(.bottom, 40)
                
                VStack(spacing: 33) {
                    TextFieldCustom(title: "Email", text: $viewModel.email)
                    
                    TextFieldCustom(title: "Password", text: $viewModel.password)
                }
                
                Spacer()
                
                GreenButton(title: "Sign In")
                
            }
            .padding(.horizontal, 40)
        }

    }
}

#Preview {
    SignInView()
}
