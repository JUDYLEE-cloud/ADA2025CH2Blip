import SwiftUI

struct MainUserMapIcon: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            Image("BlueCircle")
            Image("ThisWay")
                .padding(.bottom, 26)
                .padding(.leading, 33)
                .rotationEffect(.degrees(rotation))
        }
        .onAppear {
            startRotating()
        }
    }
    
    private func startRotating() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            let isMoving = Bool.random(probability: 0.1) // 20% 확률로 크게 이동, 나머지는 흔들기
            if isMoving {
                withAnimation(.easeInOut(duration: 1.5)) { // 크게 이동할 때 느리게
                    let direction = Bool.random() ? 1.0 : -1.0
                    rotation += direction * Double.random(in: 5...15)
                    normalizeRotation()
                }
            } else {
                withAnimation(.easeInOut(duration: 0.1)) { // 흔들 때는 빠르게
                    let smallDirection = Bool.random() ? 1.0 : -1.0
                    rotation += smallDirection * Double.random(in: 0.2...1.0)
                    normalizeRotation()
                }
            }
        }
    }
    
    private func normalizeRotation() {
        if rotation > 360 {
            rotation -= 360
        } else if rotation < 0 {
            rotation += 360
        }
    }
}

extension Bool {
    static func random(probability: Double) -> Bool {
        return Double.random(in: 0...1) < probability
    }
}

#Preview {
    MainUserMapIcon()
}
