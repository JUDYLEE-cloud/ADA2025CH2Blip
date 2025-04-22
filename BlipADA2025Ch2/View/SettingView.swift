import SwiftUI
import FirebaseAuth

struct SettingView: View {
    @State private var selectedDuration = 1
    @StateObject private var viewModel = AuthViewModel()
    @Environment(\.dismiss) var dismiss
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    var body: some View {
        ZStack {
            Color("BackgroundBlack")
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.backward")
                    }
                    Spacer()
                    Text("Setting")
                    Spacer()
                    Button {
                        viewModel.logout()
                        isLoggedIn = false
                    } label: {
                        Image(systemName: "iphone.and.arrow.right.outward")
                    }
                }
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding(.horizontal, 30)
                .padding(.top, 20)
                
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text(viewModel.storedNickname.isEmpty ? "Nickname" : viewModel.storedNickname)
                            .foregroundColor(.white)
                            .font(.custom("Alexandria", size: 25))
                            .fontWeight(.bold)
                            .padding(.top, 20)
                        
                        Text("Blip ID: judy0718")
                            .foregroundColor(Color(hex: "#A0A0A0"))
                            .padding(10)
                            .padding(.horizontal, 5)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray, lineWidth: 1)
                                    .background(Color.clear)
                            )
                    }
                    Spacer()
                    
                    Image("User1")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 95, height: 95)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding(.horizontal, 34)
                .padding(.vertical, 30)
                
                VStack {
                    Text("My Mood Setting")
                        .foregroundColor(Color(hex: "#A0A0A0"))
                        .font(.custom("Alexandria", size: 13))
                    VStack(alignment: .leading) {
                        Text("Mood Duration")
                            .fontWeight(.semibold)
                        Picker("Mood Duration", selection: $selectedDuration) {
                            ForEach(1...8, id: \.self) { hour in
                                Text("\(hour)시간").tag(hour)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 120)
                        .clipped()
                    }
                }
                
                Spacer()
            }
        }
        .environment(\.font, .custom("Alexandria", size: 15))
        .foregroundColor(.white)
    }
}

//#Preview {
//    SettingView()
//}
struct SettingView_Preview: PreviewProvider {
    static var devices = ["iPhone 11", "iPhone 16 Pro Max"]
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            SettingView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
 
