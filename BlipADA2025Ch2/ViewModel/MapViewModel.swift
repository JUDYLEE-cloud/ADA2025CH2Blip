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
    }

    private func generatePeople() {
        // 유저 사진 많아지면 여기 숫자 수정
        people = (1...7).map { index in
            let userImageName = "User\(index)"
            let statusIcons = ["RedIcon", "YellowIcon", "GreenIcon"]
            let randomStatusIcon = statusIcons.randomElement()!

            let randomPoint1 = CGPoint(x: CGFloat.random(in: 20...2000), y: CGFloat.random(in: 100...1200))
            let randomPoint2 = CGPoint(x: CGFloat.random(in: 100...2000), y: CGFloat.random(in: 100...1200))
            let randomPoint3 = CGPoint(x: CGFloat.random(in: 100...2000), y: CGFloat.random(in: 100...1200))
            let randomPath: [CGPoint] = [randomPoint1, randomPoint2, randomPoint3]

            return Person(
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
}
