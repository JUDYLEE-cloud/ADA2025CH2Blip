import SwiftUI

struct UserSelectionModalView: View {
    @State private var users: [UserInfo] = []
    @State private var selectedNicknames: Set<String> = []
    @Environment(\.editMode) var editMode
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Color("BackgroundBlack").ignoresSafeArea()
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(users, id: \.nickname) { user in
                                HStack {
                                    Image(user.userImageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                    
                                    Text(user.nickname)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Image(systemName: selectedNicknames.contains(user.nickname) ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(Color("MainColor"))
                                        .font(.title2)
                                        .onTapGesture {
                                            if selectedNicknames.contains(user.nickname) {
                                                selectedNicknames.remove(user.nickname)
                                            } else {
                                                selectedNicknames.insert(user.nickname)
                                            }
                                        }
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                                .background(Color("BackgroundBlack"))
                            }
                        }
//                        .padding(.vertical, 4)
//                        .listStyle(.plain)
//                        .listRowBackground(Color("BackgroundBlack"))
//                        .tint(Color("CustomGray"))
                    }
                    .listRowBackground(Color("BackgroundBlack")) // 🔥 리스트 항목 배경
                    .scrollContentBackground(.hidden)
                    .background(Color("BackgroundBlack")) // 🔥 전체 리스트 배경
                }
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            saveSelection()
                            dismiss()
                        }
                    }
                }
                .environment(\.editMode, .constant(.active))
                .onAppear {
                    loadUsersFromDefaults()
                }
            }
            .background(Color("BackgroundBlack").ignoresSafeArea())
        }
    }

    private func loadUsersFromDefaults() {
        let userDefaults = UserDefaults(suiteName: "group.com.ADA2025.blip")
        if let data = userDefaults?.data(forKey: "peopleData"),
           let decoded = try? JSONDecoder().decode([UserInfo].self, from: data) {
            users = decoded
        } else {
            print("❗️ 유저 데이터 불러오기 실패")
        }
    }
    
    private func saveSelection() {
        let userDefaults = UserDefaults(suiteName: "group.com.ADA2025.blip")
        userDefaults?.set(Array(selectedNicknames), forKey: "popupSelectedUserNicknames")
    }
}

struct UserSelectionModalView_Preview: PreviewProvider {
    static var devices = ["iPhone 11", "iPhone 16"]
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            UserSelectionModalView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
