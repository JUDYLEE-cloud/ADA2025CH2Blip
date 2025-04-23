import Foundation
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

final class AuthenticationManager {
    static let shared = AuthenticationManager()
    private init() {}
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func signIn(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
}

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var nickname = ""
    @Published var email = ""
    @Published var password = ""
    @AppStorage("userImageName", store: UserDefaults(suiteName: "group.com.ADA2025.blip")) var storedUserImageName: String = ""
    @AppStorage("nickname", store: UserDefaults(suiteName: "group.com.ADA2025.blip")) var storedNickname: String = ""
    @Published var loginErrorMessage: String = ""
    @Published var signupErrorMessage: String = ""
    
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
                "status": "",
                "userImageName": "User0"
            ]
            try await db.collection("users").document(returnUserData.uid).setData(userInfo)
            print("✅ Firestore 저장 성공")

            return true
        } catch {
            signupErrorMessage = "SignIn Error: \(error.localizedDescription)"
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
            if let data = snapshot.data(), let nickname = data["nickname"] as? String,
               let imageName = data["userImageName"] as? String
            {
                storedNickname = nickname
                storedUserImageName = imageName
                
                UserDefaults.standard.set(nickname, forKey: "nickname")
                print("✅ 불러온 닉네임: \(storedNickname)")
                print("✅ 불러온 프로필 이미지 이름: \(storedUserImageName)")
            }

            return true
        } catch {
            loginErrorMessage = "Login Error: \(error.localizedDescription)"
            return false
        }
    }
    
    // 로그아웃 함순
    func logout() {
        do {
            try Auth.auth().signOut()
            
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "password")
            UserDefaults.standard.removeObject(forKey: "nickname")
            storedNickname = ""
            storedUserImageName = ""

            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                windowScene.windows.first?.rootViewController = UIHostingController(rootView: SplashView())
                windowScene.windows.first?.makeKeyAndVisible()
            }

        } catch {
            print("Logout error: \(error.localizedDescription)")
        }
    }
}
