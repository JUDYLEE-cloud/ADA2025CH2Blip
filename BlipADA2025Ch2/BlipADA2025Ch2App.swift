import SwiftUI
import FirebaseCore
import Firebase
import FirebaseAuth
import FirebaseFirestore

@main
struct BlipADA2025Ch2App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if isLoggedIn {
                    HomeView()
                } else {
                    LoginView()
                }
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("Configured Firebase!")
        
        // 위젯2를 위해 firebase에서 유저 닉네임 리스트 가져오기
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents, error == nil else {
                print("❗️ Firebase users 가져오기 실패: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            let people: [UserNicknameList] = documents.compactMap { doc in
                if let nickname = doc["nickname"] as? String {
                    return UserNicknameList(id: UUID(), nickname: nickname)
                } else {
                    return nil
                }
            }

            do {
                let data = try JSONEncoder().encode(people)
                let userDefaults = UserDefaults(suiteName: "group.com.ADA2025.blip")
                userDefaults?.set(data, forKey: "peopleData")
                print("✅ peopleData 저장 완료: \(people.map { $0.nickname })")
            } catch {
                print("❗️ peopleData 인코딩 실패: \(error.localizedDescription)")
            }
        }
        
        return true
    }
}

struct UserNicknameList: Codable {
    let id: UUID
    let nickname: String
}
