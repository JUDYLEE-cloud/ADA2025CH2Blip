import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var isLogInProcess = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundBlack")
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Image("LoginTitle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 180)
                            .padding(.leading, -35)
                        
                        Spacer()
                    }
                    .padding(.top, 50)
                    .padding(.bottom, 30)
                    
                    VStack(spacing: 35) {
                        TextFieldCustom(title: "Email", text: $viewModel.email)
                            .autocapitalization(.none)
                            .autocorrectionDisabled(true)
                        
                        TextFieldCustom(title: "Password", text: $viewModel.password)
                            .autocapitalization(.none)
                            .autocorrectionDisabled(true)
                    }
                    
                    Spacer()
                    
                    Text(viewModel.loginErrorMessage)
                        .foregroundColor(.red)
                        .padding(.bottom, 10)
                        .multilineTextAlignment(.center)
                        .font(.caption)
                    
                    Button {
                        Task {
                            isLogInProcess = true
                            let success = await viewModel.login()
                            isLogInProcess = false
                            if success {
                                isLoggedIn = true
                            }
                        }
                    } label: {
                        GreenButton(title: "Log In")
                    }
                    .disabled(isLogInProcess)
                    .opacity(isLogInProcess ? 0.5 : 1.0)
                    
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign up?")
                            .font(.custom("", size: 17))
                            .foregroundColor(Color(hex: "#BFBFBF"))
                            .underline()
                            .padding(.top, -20)
                            .padding(.bottom, 20)
                    }

                }
                .padding(.horizontal, 40)
            }
            .navigationDestination(isPresented: $isLoggedIn) {
                HomeView()
            .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    LoginView()
}
