import SwiftUI

struct MoodModalView: View {
    @State private var selectedMood: MoodType = .focus
    @Binding var selectedMoodIcon: String
    @Environment(\.dismiss) private var dismiss

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
            
            Button {
                selectedMoodIcon = selectedMood.iconName
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

enum MoodType: String, CaseIterable, Equatable {
    case focus
    case workTalk
    case openChat
    
    var iconName: String {
        switch self {
        case .focus: return "RedIcon"
        case .workTalk: return "YellowIcon"
        case .openChat: return "GreenIcon"
        }
    }

    var title: String {
        switch self {
        case .focus: return "Focus Mode"
        case .workTalk: return "Work Talk Only"
        case .openChat: return "Open to Any Chat"
        }
    }
    var subtitle: String {
        switch self {
        case .focus: return "혼자 집중하는 중이에요.\n급한 일이 아니라면 나중에 이야기해주세요."
        case .workTalk: return "작업 얘기는 언제든 환영이에요.\n사적인 얘기는 잠시만 미뤄주세요."
        case .openChat: return "여유로운 시간이에요.\n업무든 일상이든 편하게 이야기해요."
        }
    }

    
}

#Preview {
    MoodModalView(selectedMoodIcon: .constant("Mascarade"))
}
