import WidgetKit
import SwiftUI

struct FriendStatusEntry: TimelineEntry {
    let date: Date
    let friend: Person
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> FriendStatusEntry {
        FriendStatusEntry(date: Date(), friend: sampleFriend)
    }

    func snapshot(for configuration: FriendStatusConfigurationIntent, in context: Context) async -> FriendStatusEntry {
        let people = loadPeopleFromUserDefaults()
        let friend: Person
        if let selectedFriendId = configuration.friend?.id,
           let matched = people.first(where: { $0.id.uuidString == selectedFriendId }) {
            friend = matched
        } else {
            friend = sampleFriend
        }
        return FriendStatusEntry(date: Date(), friend: friend)
    }

    func timeline(for configuration: FriendStatusConfigurationIntent, in context: Context) async -> Timeline<FriendStatusEntry> {
        let people = loadPeopleFromUserDefaults()
        let friend: Person
        if let selectedFriendId = configuration.friend?.id,
           let matched = people.first(where: { $0.id.uuidString == selectedFriendId }) {
            friend = matched
        } else {
            friend = sampleFriend
        }
        let entry = FriendStatusEntry(date: Date(), friend: friend)
        return Timeline(entries: [entry], policy: .never)
    }
    
    func loadPeopleFromUserDefaults() -> [Person] {
        let userDefaults = UserDefaults(suiteName: "group.com.ADA2025.blip")
        if let data = userDefaults?.data(forKey: "peopleData"),
           let people = try? JSONDecoder().decode([Person].self, from: data) {
            return people
        } else {
            print("❗️ peopleData를 불러오는 데 실패했습니다.")
        }
        return []
    }
}

// 샘플 Friend (Preview용)
let sampleFriend = Person(
    nickname: "Air",
    userImageName: "User6",
    statusIconName: "RedIcon"
)

struct BlipWidget2FriendMoodEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(spacing: 7) {
            HStack {
                Text(entry.friend.nickname.isEmpty ? "닉네임 없음" : entry.friend.nickname)
                    .font(.custom("Alexandria-Bold", size: 14))
                    .foregroundColor(Color(hex: "#0D2481"))
                
                Spacer()
            }
            
            ZStack {
                Image(
                    entry.friend.statusIconName == "RedIcon" ? "StatusRedBackground" :
                    entry.friend.statusIconName == "YellowIcon" ? "StatusYellowBackground" :
                    entry.friend.statusIconName == "GreenIcon" ? "StatusGreenBackground" :
                    "StatusBackground"
                )
                .resizable()
                .aspectRatio(contentMode: .fit)
                
                Image(entry.friend.userImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 82)
                    .padding(.bottom, 7)
                
                if let statusIconName = entry.friend.statusIconName {
                    Image(statusIconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .padding(.leading, -55)
                        .padding(.top, 50)
                }
            }
            .frame(width: 100, height: 100)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Image("FriendWidgetBackground"))
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

@main
struct BlipWidget2FriendMood: Widget {
    let kind: String = "FriendStatusWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: FriendStatusConfigurationIntent.self, provider: Provider()) { entry in
            BlipWidget2FriendMoodEntryView(entry: entry)
        }
        .configurationDisplayName("Friend Status")
        .description("Check your friend's mood at a glance!")
        .supportedFamilies([.systemSmall])
    }
}

#Preview("Friend Status Widget", as: .systemSmall) {
    BlipWidget2FriendMood()
} timeline: {
    FriendStatusEntry(date: .now, friend: sampleFriend)
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
