import SwiftUI

struct UserMapIcon: View {
    var userImageName: String
    var statusIconName: String?
    @State private var rotation: Double = 0
    
    var backgroundImageName: String {
        switch statusIconName {
        case "RedIcon":
            return "UserMapRedBackground"
        case "GreenIcon":
            return "UserMapGreenBackground"
        case "YellowIcon":
            return "UserMapYellowBackground"
        default:
            return "UserMapBackground"
        }
    }
    
    var body: some View {
        ZStack {
            Image(backgroundImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Image(userImageName)
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.bottom, 11)
            
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
    UserMapIcon(userImageName: "User1", statusIconName: "GreenIcon")
}
