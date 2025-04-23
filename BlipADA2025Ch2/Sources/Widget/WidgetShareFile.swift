import Foundation
import FirebaseCore
import Firebase
import FirebaseAuth
import FirebaseFirestore
import WidgetKit

// 위젯2를 위해 firebase에서 유저 정보 가져오기
func fetchUsersForWidget(completion: (() -> Void)? = nil) {
    let db = Firestore.firestore()
    db.collection("users").getDocuments { (snapshot, error) in
        guard let documents = snapshot?.documents, error == nil else {
            print("❗️ Firebase users 가져오기 실패: \(error?.localizedDescription ?? "Unknown error")")
            return
        }
        // userDB 배열로 변환
        let storedNickname = UserDefaults.standard.string(forKey: "nickname") ?? ""
        let people: [UserInfo] = documents.compactMap { doc in
            if let nickname = doc["nickname"] as? String,
               nickname != storedNickname,
               let imageName = doc["userImageName"] as? String,
               let status = doc["status"] as? String {
                return UserInfo(nickname: nickname, userImageName: imageName, statusIconName: status)
            } else {
                return nil
            }
        }
        
        do {
            let data = try JSONEncoder().encode(people)
            let userDefaults = UserDefaults(suiteName: "group.com.ADA2025.blip")
            userDefaults?.set(data, forKey: "peopleData")
            userDefaults?.synchronize()
            WidgetCenter.shared.reloadAllTimelines()
            // peopleData라는 이름으로 저장
            print("✅ peopleData 저장 완료: \(people.map { $0.nickname })")
            
        } catch {
            print("❗️ peopleData 인코딩 실패: \(error.localizedDescription)")
        }
    }
}

struct UserInfo: Identifiable, Codable {
    var id: String {nickname}
    let nickname: String
    let userImageName: String
    let statusIconName: String?
}
