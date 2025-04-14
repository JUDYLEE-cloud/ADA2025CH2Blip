import SwiftUI

struct UserMapIcon: View {
    var userImageName: String
    var statusIconName: String?
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            Image("UserMapBackground")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Image(userImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 67, height: 65)
                .padding(.bottom, 13)
            
            if let statusIconName = statusIconName {
                Image(statusIconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .padding(.leading, -50)
                    .padding(.top, 40)
            }
            
        }
        .frame(width: 81, height: 92)
    }
}

#Preview {
    UserMapIcon(userImageName: "User7", statusIconName: "YellowIcon")
}
