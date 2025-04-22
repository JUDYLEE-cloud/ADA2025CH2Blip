import SwiftUI

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var hasScrolled = false
    @State private var scrollProxy: ScrollViewProxy?
    
    var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: false) {
            ScrollViewReader { proxy in
                ZStack {
                    Image("Map")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(viewModel.zoomScale)
                        .gesture(
                            MagnifyGesture()
                                .onChanged { value in
                                    viewModel.zoomScale = value.magnification
                                }
                                .onEnded { value in
                                    viewModel.zoomScale = min(max(value.magnification, 1.0), 5.0)
                                }
                        )
                        .ignoresSafeArea()
                        .frame(width: 3670, height: 1100)
                        .overlay(
                            Color.clear
                                .frame(width: 1, height: 1)
                                .id("targetPoint")
                                .position(
                                    viewModel.people.first(where: { $0.isCurrentUser })?.path[
                                        viewModel.people.first(where: { $0.isCurrentUser })?.currentPositionIndex ?? 0
                                    ] ?? CGPoint(x: 1500, y: 800)
                                )
                        )
                        .gesture(
                            MagnifyGesture()
                                .onChanged { value in
                                    viewModel.zoomScale = value.magnification
                                }
                                .onEnded { value in
                                    viewModel.zoomScale = min(max(value.magnification, 1.0), 5.0)
                                }
                        )
                        .ignoresSafeArea()
                    
                    ForEach(viewModel.people.indices, id: \.self) { index in
                        let person = viewModel.people[index]
                        
                        Group {
                            if person.isCurrentUser {
                                MainUserMapIcon()
                            } else {
                                UserMapIcon(userImageName: person.userImageName, statusIconName: person.statusIconName)
                            }
                        }
                        .position(person.path[person.currentPositionIndex])
                        .scaleEffect(viewModel.zoomScale)
                        .animation(.linear(duration: 0.02), value: person.path[person.currentPositionIndex])
                    }
                }
                .onAppear {
                    self.scrollProxy = proxy
                    if !hasScrolled {
                        proxy.scrollTo("targetPoint", anchor: .center)
                        hasScrolled = true
                    }
                }
                
            }
        }
        .ignoresSafeArea()
        .onReceive(viewModel.timer) { _ in
            viewModel.updatePeoplePositions()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ScrollToTargetPoint"))) { _ in
            scrollToTargetPoint()
        }
    }
    
    private func scrollToTargetPoint() {
        if let proxy = scrollProxy {
            withAnimation {
                proxy.scrollTo("targetPoint", anchor: .center)
            }
        }
    }
}

#Preview {
    MapView()
}
