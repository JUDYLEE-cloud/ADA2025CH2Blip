import Foundation
import SwiftUI

struct Person: Identifiable, Codable {
    let id: UUID
    
    var nickname: String
    
    var path: [CGPoint]
    var currentPositionIndex: Int
    var speed: Double
    var waitTimeRemaining: TimeInterval
    
    var userImageName: String
    var statusIconName: String?
    var isCurrentUser: Bool // 추후 삭제?
    
    init (
        nickname: String,
        
        path: [CGPoint] = [],
        currentPositionIndex: Int = 0,
        speed: Double = 0,
        waitTimeRemaining: TimeInterval = 0,
        
        userImageName: String = "",
        statusIconName: String? = nil,
        isCurrentUser: Bool = false
    ) {
        self.id = UUID()
        self.nickname = nickname
        
        self.path = path
        self.currentPositionIndex = currentPositionIndex
        self.speed = speed
        self.waitTimeRemaining = waitTimeRemaining
        
        self.userImageName = userImageName
        self.statusIconName = statusIconName
        self.isCurrentUser = isCurrentUser
    }
}
