import Foundation
import SwiftUI
import Combine
import FirebaseFirestore

class MapViewModel: ObservableObject {
    // let firestoreManager = FirestoreManager()
    @Published var people: [Person] = []
    
    @Published var zoomScale: CGFloat = 1.0
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    @Published var mapOffset: CGSize = .zero
    
    @AppStorage("selectedMoodType", store: UserDefaults(suiteName: "group.com.ADA2025.blip"))
    var storedMoodType: String = MoodType.focus.rawValue
    

    init() {
        // generatePeople()
        savePeopleToUserDefaults()
        fetchUsersFromFirestore()
        checkSavedPeople()
    }

    private func fetchUsersFromFirestore() {
        let myNickname = UserDefaults.standard.string(forKey: "nickname") ?? ""
        let db = Firestore.firestore()
        
        db.collection("users").getDocuments { [weak self] (snapshot, error) in
            guard let self = self else {return}
            if let error = error {
                print("Firestore에서 user들 정보 가져오기 실패: \(error)")
                return
            }
            guard let documents = snapshot?.documents else { return }
            var fetchedUsers: [Person] = []
            for (_, doc) in documents.enumerated() {
                let data = doc.data()
                let nickname = data["nickname"] as? String ?? "Unknown"
                let status = data["status"] as? String ?? ""
                let userImageName = data["userImageName"] as? String ?? "User1"
                let randomPath: [CGPoint] = [
                    CGPoint(x: CGFloat.random(in: 20...2000), y: CGFloat.random(in: 100...1200)),
                    CGPoint(x: CGFloat.random(in: 100...2000), y: CGFloat.random(in: 100...1200)),
                    CGPoint(x: CGFloat.random(in: 100...2000), y: CGFloat.random(in: 100...1200))
                ]
                let person = Person(
                    nickname: nickname,
                    path: randomPath,
                    currentPositionIndex: 0,
                    speed: Double.random(in: 0.08...0.6),
                    waitTimeRemaining: 0,
                    userImageName: userImageName,
                    statusIconName: status,
                    isCurrentUser: nickname == myNickname
                )
                fetchedUsers.append(person)
            }
            DispatchQueue.main.async {
                self.people = fetchedUsers
                self.savePeopleToUserDefaults()
                print("Firestore에서 \(fetchedUsers.count)명 불러옵")
            }
        }
    }
//    private func generatePeople() {
//        let nicknames = ["JudyJ", "Glowny", "Taeni", "Ito", "Wonjun", "Air", "Ken"]
//        let statusIcons: [String?] = ["RedIcon", "YellowIcon", "GreenIcon", nil]
//        people = (0..<nicknames.count).map { index in
//            let nickname = nicknames[index]
//            let userImageName = "User\(index + 1)"
//            let randomStatusIcon = statusIcons.randomElement()!
//
//            let randomPoint1 = CGPoint(x: CGFloat.random(in: 20...2000), y: CGFloat.random(in: 100...1200))
//            let randomPoint2 = CGPoint(x: CGFloat.random(in: 100...2000), y: CGFloat.random(in: 100...1200))
//            let randomPoint3 = CGPoint(x: CGFloat.random(in: 100...2000), y: CGFloat.random(in: 100...1200))
//            let randomPath: [CGPoint] = [randomPoint1, randomPoint2, randomPoint3]
//
//            return Person(
//                nickname: nickname,
//                
//                path: randomPath,
//                currentPositionIndex: 0,
//                speed: Double.random(in: 0.08...0.6),
//                waitTimeReamaning: 0,
//                
//                userImageName: userImageName,
//                statusIconName: randomStatusIcon,
//                
//                isCurrentUser: index == 0 // 첫 번째 인물은 현재 사용자로 설정
//            )
//        }
//        
//        // appstorage에 저장된 감정을 첫번째 인물에게 부여
//        if let mood = MoodType(rawValue: storedMoodType),
//           let currentUserIndex = people.firstIndex(where: { $0.isCurrentUser }) {
//            people[currentUserIndex].statusIconName = mood.iconName
//        }
//    }
    
    func updatePeoplePositions() {
        for index in people.indices {
            var person = people[index]
            if person.waitTimeRemaining > 0 {
                person.waitTimeRemaining -= 0.02 
            } else if !person.path.isEmpty {
                let nextIndex = (person.currentPositionIndex + 1) % person.path.count
                let currentPoint = person.path[person.currentPositionIndex]
                let nextPoint = person.path[nextIndex]
                let dx = nextPoint.x - currentPoint.x
                let dy = nextPoint.y - currentPoint.y
                let distance = sqrt(dx*dx + dy*dy)

                if distance > person.speed {
                    let ratio = person.speed / distance
                    let moveX = dx * ratio
                    let moveY = dy * ratio
                    person.path[person.currentPositionIndex].x += moveX
                    person.path[person.currentPositionIndex].y += moveY
                } else {
                    person.currentPositionIndex = nextIndex
                    person.waitTimeRemaining = Double.random(in: 5.0 ... 12.0)
                }
            }
            people[index] = person
        }
    }
    
    func checkSavedPeople() {
        let userDefaults = UserDefaults(suiteName: "group.com.ADA2025.blip")
        if let data = userDefaults?.data(forKey: "peopleData"),
           let decoded = try? JSONDecoder().decode([Person].self, from: data) {
            print("✅ 저장된 사람 수: \(decoded.count)")
            if let first = decoded.first {
                print("✅ 첫번째 사람 닉네임:", first.nickname)
            }
        } else {
            print("❗ 저장된 peopleData가 없습니다.")
        }
    }
    
    func savePeopleToUserDefaults() {
        if let data = try? JSONEncoder().encode(people) {
            let userDefaults = UserDefaults(suiteName: "group.com.ADA2025.blip")
            userDefaults?.set(data, forKey: "peopleData")
            print("✅ peopleData 저장 완료, 저장된 사람 수: \(people.count)")
            
            // 저장 후 바로 확인
            if let savedData = userDefaults?.data(forKey: "peopleData"),
               let decoded = try? JSONDecoder().decode([Person].self, from: savedData) {
                print("✅ 저장 직후 읽은 사람 수: \(decoded.count)")
            } else {
                print("❗ 저장 직후 읽기 실패")
            }
        } else {
            print("❗ peopleData 저장 실패")
        }
    }

}
