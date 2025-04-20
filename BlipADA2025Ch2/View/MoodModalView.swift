import SwiftUI
import WidgetKit
import FirebaseFirestore
import FirebaseAuth

struct MoodModalView: View {
    @State private var selectedMood: MoodType

    init() {
        let defaults = UserDefaults(suiteName: "group.com.ADA2025.blip")
        let savedTime = defaults?.object(forKey: "selectedMoodSavedTime") as? Date ?? Date.distantPast
        let now = Date()
        
        if now.timeIntervalSince(savedTime) > 3 * 60 * 60 {
            defaults?.removeObject(forKey: "selectedMoodType")
            defaults?.removeObject(forKey: "selectedMoodSavedTime")
            _selectedMood = State(initialValue: .focus)
        } else {
            let storedMoodRaw = defaults?.string(forKey: "selectedMoodType") ?? MoodType.focus.rawValue
            _selectedMood = State(initialValue: MoodType(rawValue: storedMoodRaw) ?? .focus)
        }
    }
    
    // @Binding var selectedMoodIcon: String
    @Environment(\.dismiss) private var dismiss
    @AppStorage("selectedMoodType", store: UserDefaults(suiteName: "group.com.ADA2025.blip")) private var storedMoodType: String = MoodType.focus.rawValue

    var body: some View {
        VStack(spacing: 20) {
            RoundedRectangle(cornerRadius: 3)
                    .frame(width: 40, height: 5)
                    .foregroundColor(.gray)
                    .padding(.top, 25)

            Text("What's your mood?")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 20)
                .padding(.bottom, 15)

            VStack(spacing: 16) {
                ForEach(MoodType.allCases, id: \.self) { mood in
                    let isSelected = selectedMood == mood

                    HStack {
                        Image(mood.iconName)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(13)
                            .background(Color.gray.opacity(0.2).cornerRadius(12))
                            .opacity(isSelected ? 1.0 : 0.7)
                        
                        VStack(alignment: .leading) {
                            Text(mood.title)
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding(.bottom, 1)
                                .opacity(isSelected ? 1.0 : 0.7)
                            
                            Text(mood.subtitle)
                                .foregroundColor(.white)
                                .font(.caption)
                                .opacity(isSelected ? 1.0 : 0.7)
                        }
                        .padding(.leading, 6)
    
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.green : Color.clear, lineWidth: 2)
                    )
                    .onTapGesture {
                        selectedMood = mood
                    }
                }
            }
            .padding(.horizontal, 24)

            Spacer()
            
            // 감정 삭제
            Button {
                let defaults = UserDefaults(suiteName: "group.com.ADA2025.blip")
                defaults?.removeObject(forKey: "selectedMoodType")
                defaults?.removeObject(forKey: "selectedMoodSavedTime")
                storedMoodType = ""
                selectedMood = .focus // 내부 화면에서는 focus mode에 테두리
                // 위젯에 반영
                WidgetCenter.shared.reloadAllTimelines()

                // firebase db에도 반영
                Task {
                    do {
                        guard let currentUser = Auth.auth().currentUser else {
                            print("❌ 현재 로그인된 사용자가 없습니다")
                            return
                        }

                        let db = Firestore.firestore()
                        try await db.collection("users").document(currentUser.uid).setData(["status": ""], merge: true)
                        print("✅ Firestore에서 status 초기화 성공")
                    } catch {
                        print("❌ Firestore status 초기화 실패: \(error)")
                    }
                }
            } label: {
                Text("Reset Mood (for Test)")
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button {
                // app storage에 저장
                storedMoodType = selectedMood.rawValue
                // 위젯에 반영 app storage
                WidgetCenter.shared.reloadAllTimelines()
                
                // firebase 서버에 저장
                let email = UserDefaults.standard.string(forKey: "email") ?? ""
                let password = UserDefaults.standard.string(forKey: "password") ?? ""
                let nickname = UserDefaults.standard.string(forKey: "nickname") ?? ""
                Task {
                    do {
                        guard let currentUser = Auth.auth().currentUser else {
                            print("❌ 현재 로그인된 사용자가 없습니다")
                            return
                        }

                        let db = Firestore.firestore()
                        let statusToSave = selectedMood.rawValue
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
