import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
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
                        
                        TextFieldCustom(title: "Password", text: $viewModel.password)
                    }
                    
                    Spacer()
                    
                    Button {
                        Task {
                            let success = await viewModel.login()
                            if success {
                                isLoggedIn = true
                            }
                        }
                    } label: {
                        GreenButton(title: "Log In")
                    }

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
