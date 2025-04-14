import Foundation

enum MoodType: String, CaseIterable, Equatable {
    case focus
    case workTalk
    case openChat
    // case reset

    var iconName: String {
        switch self {
        case .focus: return "RedIcon"
        case .workTalk: return "YellowIcon"
        case .openChat: return "GreenIcon"
        // case .reset: return "Mascarade"
        }
    }

    var title: String {
        switch self {
        case .focus: return "Focus Mode"
        case .workTalk: return "Work Talk Only"
        case .openChat: return "Open to Any Chat"
        // case .reset: return "Mood Reset"
        }
    }

    var subtitle: String {
        switch self {
        case .focus: return "혼자 집중하는 중이에요.\n급한 일이 아니라면 나중에 이야기해주세요."
        case .workTalk: return "작업 얘기는 언제든 환영이에요.\n사적인 얘기는 잠시만 미뤄주세요."
        case .openChat: return "여유로운 시간이에요.\n업무든 일상이든 편하게 이야기해요."
        // case .reset: return "감정 상태를 설정하고 싶지 않아요."
        }
    }
}
