import Foundation
import SwiftUI

class DistanceAlertManager: ObservableObject {
    @Published var alertTarget: Person? = nil

    func checkProximity(from me: Person, to others: [Person], threshold: CGFloat = 100) {
        for person in others where !person.isCurrentUser {
            let myPoint = me.path[me.currentPositionIndex]
            let theirPoint = person.path[person.currentPositionIndex]
            let dx = myPoint.x - theirPoint.x
            let dy = myPoint.y - theirPoint.y
            let distance = sqrt(dx*dx + dy*dy)

            if distance < threshold {
                if alertTarget?.nickname != person.nickname {
                    alertTarget = person
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.alertTarget = nil
                    }
                }
                break
            }
        }
    }
}
