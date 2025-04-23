import SwiftUI

struct HomeViewGradation: View {
    @State private var zoomScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack {
                        Image("HomeTopGradation")
                            .resizable()
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.1)
                    
                        Spacer()
                        
                        Image("HomeBottomGradation")
                            .resizable()
                            .frame(width: geometry.size.width, height: geometry.size.height * 0.1)
                }
                .allowsHitTesting(false)
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    HomeViewGradation()
}
