import SwiftUI
import WidgetKit

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
            
            // 마지막에 삭제
            Button {
                let defaults = UserDefaults(suiteName: "group.com.ADA2025.blip")
                defaults?.removeObject(forKey: "selectedMoodType")
                defaults?.removeObject(forKey: "selectedMoodSavedTime")
                storedMoodType = ""
                selectedMood = .focus // 내부 화면에서는 focus mode에 테두리
                WidgetCenter.shared.reloadAllTimelines()
            } label: {
                Text("Reset Mood (for Test)")
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button {
                storedMoodType = selectedMood.rawValue
                let defaults = UserDefaults(suiteName: "group.com.ADA2025.blip")
                defaults?.set(Date(), forKey: "selectedMoodSavedTime")
                WidgetCenter.shared.reloadAllTimelines()
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
        .background(Color.black.ignoresSafeArea())
    }
}


#Preview {
    MoodModalView()
}
