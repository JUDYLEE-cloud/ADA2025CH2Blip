import WidgetKit
import SwiftUI

struct MoodEntry: TimelineEntry {
    let date: Date
    let mood: MoodType?
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> MoodEntry {
        MoodEntry(date: Date(), mood: readStoredMood())
    }

    func getSnapshot(in context: Context, completion: @escaping (MoodEntry) -> Void) {
        let entry = MoodEntry(date: Date(), mood: readStoredMood())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MoodEntry>) -> Void) {
        let currentDate = Date()
        let expiryDate = Calendar.current.date(byAdding: .hour, value: 3, to: currentDate)!
        
        let entry = MoodEntry(date: currentDate, mood: readStoredMood())
        let timeline = Timeline(entries: [entry], policy: .after(expiryDate))
        
        completion(timeline)
    }
    
    private func readStoredMood() -> MoodType? {
        let defaults = UserDefaults(suiteName: "group.com.ADA2025.blip")
        
        guard let storedMoodType = defaults?.string(forKey: "selectedMoodType"),
              !storedMoodType.isEmpty,
              let mood = MoodType(rawValue: storedMoodType) else {
            return nil
        }
        
        return mood
    }
}

struct BlipMoodWidgetEntryView: View {
    var entry: MoodEntry
    @AppStorage("nickname", store: UserDefaults(suiteName: "group.com.ADA2025.blip")) var storedNickname: String = "My"
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text("\(storedNickname)'s Mood")
                        .font(.custom("Alexandria-Medium", size: 12))
                        .foregroundColor(Color(hex: "707070"))
                    Spacer()
                }
                
                let isMoodEmpty = (entry.mood == nil || (entry.mood == .focus && entry.mood?.title == "focus"))

                Text(isMoodEmpty ? "What is your mood?" : entry.mood?.title ?? "")
                    .font(.custom("Alexandria-SemiBold", size: isMoodEmpty ? 12 : (entry.mood?.titleFontSize ?? 17)))
                    .foregroundColor(Color(hex: "#0D2481"))
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            
            VStack {
                Spacer()
                
                if entry.mood == nil || (entry.mood == .focus && entry.mood?.title == "focus") {
                    Image("TripleBackground")
                        .resizable()
                        .frame(width: 130, height: 80)
                        .border(Color.red, width: 1)
                } else {
                    ZStack {
                        Image(entry.mood?.backgroundImageName ?? "")
                            .frame(width: 130, height: 80)
                        
                        Image(entry.mood?.iconName ?? "")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .padding(.bottom, 8)
                    }
                    .padding(.bottom, -8)
                }
            }
        }
        .containerBackground(.fill.tertiary, for: .widget)
        
    }
}

struct BlipWidget1MyMood: Widget {
    let kind: String = "BlipMoodWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BlipMoodWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Mood")
        .description("Shows your current mood status.")
        .supportedFamilies([.systemSmall]) // 2x2 크기 (Small Widget)
    }
}

#Preview("BlipWidget1MyMood Preview", as: .systemSmall) {
    BlipWidget1MyMood()
} timeline: {
    MoodEntry(date: Date(), mood: .focus)
    MoodEntry(date: Date().addingTimeInterval(60*60), mood: .workTalk)
    MoodEntry(date: Date().addingTimeInterval(2*60*60), mood: .openChat)
}


extension MoodType {
    var backgroundImageName: String {
        switch self {
        case .focus:
            return "RedBackground"
        case .workTalk:
            return "YellowBackground"
        case .openChat:
            return "GreenBackground"
        }
    }
    
    var titleFontSize: CGFloat {
        switch self {
        case .focus: return 17
        case .workTalk: return 15
        case .openChat: return 14
        }
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        
        self.init(red: r, green: g, blue: b)
    }
}
