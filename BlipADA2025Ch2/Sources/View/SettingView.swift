import SwiftUI
import FirebaseAuth

struct SettingView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    @State private var selectedDuration = 1
    @State private var selectedVisibility: String = "public"
    @State private var isUserSelectionModalPresented: Bool = false
    @State private var selectedMoodNoti: String = "Focus Mode"
    
    var body: some View {
        ZStack {
            Color("BackgroundBlack")
                .ignoresSafeArea()
            
            VStack {
                // 상단 네비게이션 바
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
                
                // 닉네임, 아이디, 프로필 출력하는 상단 부분
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text(viewModel.storedNickname.isEmpty ? "Nickname" : viewModel.storedNickname)
                            .foregroundColor(.white)
                            .font(.custom("Alexandria", size: 25))
                            .fontWeight(.bold)
                            .padding(.top, 20)
                        
                        Text("Blip ID: \(viewModel.storedNickname.lowercased())2025")
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
                    
                    Image(viewModel.storedUserImageName.isEmpty ? "User0" : viewModel.storedUserImageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 95, height: 95)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding(.horizontal, 34)
                .padding(.vertical, 30)
                .padding(.bottom, 20)
                
                // 환경설정 1 my mood setting
                VStack(alignment: .leading, spacing: 30) {
                    // 대제목
                    Text("My Mood Setting")
                        .foregroundColor(Color(hex: "#A0A0A0"))
                        .font(.custom("Alexandria", size: 17))
                    
                    // 1-1 mood setting
                    HStack {
                        Text("Mood Duration")
                            .fontWeight(.semibold)
                            .font(.custom("Alexandria", size: 18))
                        
                        Spacer()
                        
                        Menu {
                            ForEach(1...8, id: \.self) { hour in
                                Button {
                                    selectedDuration = hour
                                } label: {
                                    Text("\(hour) hour")
                                }
                            }
                        } label: {
                            HStack {
                                Text("\(selectedDuration) hours")
                                Image(systemName: "chevron.compact.up.chevron.compact.down")
                            }
                            .foregroundColor(Color(hex: "#C4C4C4"))
                        }
                    }
                    .padding(.horizontal, 10)
                    
                    // 1-2 mood visibility
                    HStack {
                        Text("Mood Visibility")
                            .fontWeight(.semibold)
                            .font(.custom("Alexandria", size: 18))
                        
                        Spacer()
                        
                        Menu {
                            Button("Public") {
                                selectedVisibility = "public"
                            }
                            Button("Friends only") {
                                selectedVisibility = "Friends only"
                            }
                            Button("Private") {
                                selectedVisibility = "private"
                            }
                        } label: {
                            HStack {
                                Text(selectedVisibility)
                                Image(systemName: "chevron.compact.up.chevron.compact.down")
                            }
                            .foregroundColor(Color(hex: "#C4C4C4"))
                        }
                    }
                    .padding(.horizontal, 10)
                } // 환경설정 1 my mood setting
                .padding(.horizontal, 30)
                .padding(.bottom, 35)
                
                // 환경설정 2 Notifications
                VStack(alignment: .leading, spacing: 30) {
                    // 대제목
                    Text("Notifications")
                        .foregroundColor(Color(hex: "#A0A0A0"))
                        .font(.custom("Alexandria", size: 17))
                    
                    // 2-1 user filtering
                    HStack {
                        Text("User Filtering")
                            .fontWeight(.semibold)
                            .font(.custom("Alexandria", size: 18))
                        
                        Spacer()
                        
                        Button {
                            isUserSelectionModalPresented = true
                        } label: {
                            ZStack(alignment: .leading) {
                                Image("User1")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 1))
                                    .shadow(radius: 3)
                                    .offset(x: 40)
                                    .zIndex(0)
                                
                                Image("User2")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 1))
                                    .shadow(radius: 3)
                                    .offset(x: 20)
                                    .zIndex(0)
                                
                                Image("User3")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 1))
                                    .shadow(radius: 3)
                                    .offset(x: 0)
                                    .zIndex(0)
                            }
                            .padding(.trailing, 37)
                            
                            Text("••• 4명")
                        }
                    }
                    .padding(.horizontal, 10)
                    
                    // 2-2 mood filtering
                    HStack {
                        Text("Mood Filtering")
                            .fontWeight(.semibold)
                            .font(.custom("Alexandria", size: 18))
                        
                        Spacer()
                        
                        Menu {
                            Button("Focus Mode") {
                                selectedMoodNoti = "public"
                            }
                            Button("Work Talk Only") {
                                selectedMoodNoti = "Friends only"
                            }
                            Button("Open to Any Chat") {
                                selectedMoodNoti = "private"
                            }
                        } label: {
                            HStack {
                                Text(selectedMoodNoti)
                                Image(systemName: "chevron.compact.up.chevron.compact.down")
                            }
                            .foregroundColor(Color(hex: "#C4C4C4"))
                        }
                    }
                    .padding(.horizontal, 10)
                } // 환경설정 2 Notifications
                .padding(.horizontal, 30)
                
                Spacer()
                
                GreenButton(title: "Save")
            } // 최상단 vstack
        }
        .sheet(isPresented: $isUserSelectionModalPresented, content: {
            UserSelectionModalView()
        })
        .environment(\.font, .custom("Alexandria", size: 15))
        .foregroundColor(.white)
    }
}

//#Preview {
//    SettingView(viewModel: AuthViewModel())
//}
    struct SettingView_Preview: PreviewProvider {
        static var devices = ["iPhone 11", "iPhone 16"]
        static var previews: some View {
            ForEach(devices, id: \.self) { device in
                SettingView(viewModel: AuthViewModel())
                    .previewDevice(PreviewDevice(rawValue: device))
                    .previewDisplayName(device)
            }
        }
    }

