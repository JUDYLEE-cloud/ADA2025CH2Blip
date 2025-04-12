import SwiftUI

struct Map: View {
    @StateObject private var viewModel = MapViewModel()
    
    var body: some View {
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
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
                    
                    ForEach(viewModel.people.indices, id: \.self) { index in
                        UserMapIcon(userImageName: viewModel.people[index].userImageName, statusIconName: viewModel.people[index].statusIconName)
                            .position(viewModel.people[index].path[viewModel.people[index].currentPositionIndex])
                            .scaleEffect(viewModel.zoomScale)
                            .animation(.linear(duration: 0.02), value: viewModel.people[index].path[viewModel.people[index].currentPositionIndex])
                    }
                    
                    GeometryReader { geometry in
                        MainUserMapIcon()
                            .position(x: 1000, y:800)
                            .scaleEffect(viewModel.zoomScale)
                    }

                }
            }
            .onReceive(viewModel.timer) { _ in
                viewModel.updatePeoplePositions()
                }
            .ignoresSafeArea()
        }
        }

//#Preview {
//    Map(scrollToMainUser: $scrollToMainUser)
//}
