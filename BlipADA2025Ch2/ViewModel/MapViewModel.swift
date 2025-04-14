import Foundation
import SwiftUI
import Combine

class MapViewModel: ObservableObject {
    @Published var people: [Person] = []
    @Published var zoomScale: CGFloat = 1.0
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    @Published var mapOffset: CGSize = .zero

    init() {
        generatePeople()
        savePeopleToUserDefaults()
        checkSavedPeople()
    }

    private func generatePeople() {
        // 유저 추가되면 여기 닉네임 추가
        let nicknames = ["JudyJ", "Glowny","Taeni", "Ito", "Wonjun", "Air", "Ken"]
        let statusIcons: [String?] = ["RedIcon", "YellowIcon", "GreenIcon", nil]
        people = (1...nicknames.count).map { index in
            let nickname = nicknames[index - 1]
            let userImageName = "User\(index)"
            let randomStatusIcon = statusIcons.randomElement()!

            let randomPoint1 = CGPoint(x: CGFloat.random(in: 20...2000), y: CGFloat.random(in: 100...1200))
            let randomPoint2 = CGPoint(x: CGFloat.random(in: 100...2000), y: CGFloat.random(in: 100...1200))
            let randomPoint3 = CGPoint(x: CGFloat.random(in: 100...2000), y: CGFloat.random(in: 100...1200))
            let randomPath: [CGPoint] = [randomPoint1, randomPoint2, randomPoint3]

            return Person(
                nickname: nickname,
                path: randomPath,
                currentPositionIndex: 0,
                speed: Double.random(in: 0.08...0.6),
                userImageName: userImageName,
                statusIconName: randomStatusIcon
            )
        }
    }
    
    func updatePeoplePositions() {
        for index in people.indices {
            var person = people[index]
            if !person.path.isEmpty {
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
