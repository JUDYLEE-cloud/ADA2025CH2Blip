import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

// 조건 불충족시 버튼 비활성화
// 이메일은 꼭 이메일 형식, 비밀번호는 6글자 이상이여야 한다는 조건

// 파일 분리
struct SignUpView: View {
    @StateObject private var viewModel = AuthViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var isSigninProcess = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundBlack")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Image("mainIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 130)
                            .padding(.leading, -20)
                        
                        Spacer()
                    }
                    .padding(.top, 20)
                    
                    Image("SignInTitle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: .infinity)
                        .padding(.bottom, 45)
                    
                    VStack(spacing: 35) {
                        TextFieldCustom(title: "NickName", text: $viewModel.nickname)
                            .autocapitalization(.none)
                            .autocorrectionDisabled(true)
                        TextFieldCustom(title: "Email", text: $viewModel.email)
                            .autocapitalization(.none)
                            .autocorrectionDisabled(true)
                        TextFieldCustom(title: "Password", text: $viewModel.password)
                            .autocapitalization(.none)
                            .autocorrectionDisabled(true)
                    }
                    
                    Spacer()
                    
                    Text(viewModel.signupErrorMessage)
                        .foregroundColor(.red)
                        .padding(.bottom, 10)
                        .multilineTextAlignment(.center)
                        .font(.caption)
                    
                    Button {
                        Task {
                            isSigninProcess = true
                            let success = await viewModel.signIn()
                            isSigninProcess = false
                            if success {
                                dismiss()
                                isSigninProcess = true
                            }
                        }
                    } label: {
                        GreenButton(title: "Sign In")
                    }
                    .disabled(isSigninProcess)
                    .opacity(isSigninProcess ? 0.5 : 1.0)
                }
                .padding(.horizontal, 40)
            }
        }
    }
}

#Preview {
    SignUpView()
}
