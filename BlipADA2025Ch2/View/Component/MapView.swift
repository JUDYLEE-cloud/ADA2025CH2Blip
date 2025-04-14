import SwiftUI

struct MapView: View {
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
                    let person = viewModel.people[index]
                    
                    Group {
                        if let statusIconName = person.statusIconName {
                            UserMapIcon(userImageName: person.userImageName, statusIconName: statusIconName)
                        } else {
                            UserMapIcon(userImageName: person.userImageName, statusIconName: nil)
                        }
                    }
                    .position(person.path[person.currentPositionIndex])
                    .scaleEffect(viewModel.zoomScale)
                    .animation(.linear(duration: 0.02), value: person.path[person.currentPositionIndex])
                }

                MainUserMapIcon()
                    .position(x: 1000, y: 800)
                    .scaleEffect(viewModel.zoomScale)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    MapView()
}
