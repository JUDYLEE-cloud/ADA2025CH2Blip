import SwiftUI
import WidgetKit
import FirebaseFirestore
import FirebaseAuth

struct MoodModalView: View {
    @State private var selectedMood: MoodTypeModel?

    init() {
        let storedMoodRaw = UserDefaults(suiteName: "group.com.ADA2025.blip")?.string(forKey: "selectedMoodType")
//        _selectedMood = State(initialValue: MoodTypeModel(rawValue: storedMoodRaw ?? "") ?? .focus)
        if let raw = storedMoodRaw, let mood = MoodTypeModel(rawValue: raw) {
            _selectedMood = State(initialValue: mood)
        } else {
            _selectedMood = State(initialValue: nil)
        }
    }
    
    @Environment(\.dismiss) private var dismiss
    // :: app storage key를 넣어서 관리해보기
    @AppStorage("selectedMoodType", store: UserDefaults(suiteName: "group.com.ADA2025.blip")) private var storedMoodType: String = ""

    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 3)
                    .frame(width: 40, height: 5)
                    .foregroundColor(.gray)
                    .padding(.top, 25)

            Text("What's your mood?")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 30)
                .padding(.bottom, 20)

            VStack(spacing: 12) {
                ForEach(MoodTypeModel.allCases, id: \.self) { mood in
                    let isSelected = selectedMood == mood

                    HStack {
                        Image(mood.iconName)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(13)
                            .background(Color.gray.opacity(0.2).cornerRadius(12))
                            .opacity(isSelected ? 1.0 : 0.7)
                            .padding(.bottom, 1)
                        
                        VStack(alignment: .leading) {
                            Text(mood.title)
                                .foregroundColor(.white)
                                .font(.system(size: 23))
                                .padding(.bottom, 1)
                                .opacity(isSelected ? 1.0 : 0.7)
                            
                            Text(mood.subtitle)
                                .foregroundColor(.white)
                                .font(.system(size: 13))
                                .lineSpacing(4)
                                .opacity(isSelected ? 1.0 : 0.7)
                        }
                        .padding(.leading, 6)
    
                        Spacer()
                    }
                    .padding()
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.green : Color.clear, lineWidth: 2)
                    )
                    .onTapGesture {
                        // selectedMood = mood
                        selectedMood = (selectedMood == mood) ? nil : mood
                    }
                }
            }
            .padding(.horizontal, 24)

            Spacer()
            
            Button {
                // app storage에 저장
                storedMoodType = selectedMood?.rawValue ?? ""
                // 위젯에 반영 app storage
                WidgetCenter.shared.reloadAllTimelines()
                
                // firebase 서버에 저장
//                let email = UserDefaults.standard.string(forKey: "email") ?? ""
//                let password = UserDefaults.standard.string(forKey: "password") ?? ""
//                let nickname = UserDefaults.standard.string(forKey: "nickname") ?? ""
                Task {
                    do {
                        guard let currentUser = Auth.auth().currentUser else {
                            print("❌ 현재 로그인된 사용자가 없습니다")
                            return
                        }

                        let db = Firestore.firestore()
                        let statusToSave = selectedMood?.iconName ?? ""
                        let nickname = UserDefaults.standard.string(forKey: "nickname") ?? ""

                        let userInfo: [String: Any] = [
                            "status": statusToSave,
                            "nickname": nickname
                        ]

                        print("🔥 저장 전 정보: \(userInfo)")

                        try await db.collection("users").document(currentUser.uid).setData(userInfo, merge: true)

                        print("✅ Firestore에 status 저장 성공")
                        WidgetCenter.shared.reloadAllTimelines()
                        dismiss()
                    } catch {
                        print("❌ Firestore 저장 실패: \(error)")
                    }
                }
                
                // 모달 뷰 종료
                dismiss()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("MainColor"))
                        .frame(height: 44)
                        .padding(.horizontal, 30)
                    
                    Text("Save")
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black)
                }
                .padding(.bottom, 30)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BackgroundBlack").ignoresSafeArea())
    }
}


#Preview {
    MoodModalView()
}
