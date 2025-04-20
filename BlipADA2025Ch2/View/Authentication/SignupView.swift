import SwiftUI
// import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

// 조건 불충족시 버튼 비활성화
// 이메일은 꼭 이메일 형식, 비밀번호는 6글자 이상이여야 한다는 조건

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var nickname = ""
    @Published var email = ""
    @Published var password = ""
    @AppStorage("nickname", store: UserDefaults(suiteName: "group.com.ADA2025.blip")) var storedNickname: String = ""
    
    // 회원가입 함수
    func signIn() async -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            print("❌ 이메일 또는 비밀번호가 비어 있음")
            return false
        }

        do {
            print("🔄 회원가입 시도 중...")
            let returnUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
            print("✅ Firebase 계정 생성 성공")
            print(returnUserData)

            let db = Firestore.firestore()
            let userInfo: [String: Any] = [
                "uid": returnUserData.uid,
                "nickname": nickname,
                "email": email,
                "status": ""
            ]
            try await db.collection("users").document(returnUserData.uid).setData(userInfo)
            print("✅ Firestore 저장 성공")

            return true
        } catch {
            print("❌ 회원가입 에러: \(error.localizedDescription)")
            return false
        }
    }
    
    // 로그인 함수
    func login() async -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return false
        }

        do {
            let returnUserData = try await AuthenticationManager.shared.signIn(email: email, password: password)
            print(returnUserData)
            
            let db = Firestore.firestore()
            let snapshot = try await db.collection("users").document(returnUserData.uid).getDocument()
            if let data = snapshot.data(), let nickname = data["nickname"] as? String {
                storedNickname = nickname
                print("✅ AppStorage에 저장된 닉네임: \(storedNickname)")
            }

            return true
        } catch {
            print("❌ Login Error: \(error.localizedDescription)")
            return false
        }
    }
    
    // 로그아웃 함순
    func logout() {
        do {
            try Auth.auth().signOut()

            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.first?.rootViewController = UIHostingController(rootView: SplashView())
                windowScene.windows.first?.makeKeyAndVisible()
            }

        } catch {
            print("Logout error: \(error.localizedDescription)")
        }
    }
}

struct SignUpView: View {
    @StateObject private var viewModel = AuthViewModel()
    @Environment(\.dismiss) var dismiss
    
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
                    
                    Button {
                        Task {
                            let success = await viewModel.signIn()
                            if success {
                                dismiss()
                            }
                        }
                    } label: {
                        GreenButton(title: "Sign In")
                    }
                }
                .padding(.horizontal, 40)
            }
        }
    }
}

#Preview {
    SignUpView()
}
