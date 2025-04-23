struct WidgetUserInfo: Codable, Hashable {
    let nickname: String
    let userImageName: String
    let statusIconName: String
}

let emptyFriend = WidgetUserInfo(nickname: "Sample Friend", userImageName: "User0", statusIconName: "GreenIcon")

func loadPeopleFromUserDefaults() -> [WidgetUserInfo] {
    let userDefaults = UserDefaults(suiteName: "group.com.ADA2025.blip")
    if let data = userDefaults?.data(forKey: "peopleData"),
       let people = try? JSONDecoder().decode([WidgetUserInfo].self, from: data) {
        return people
    }
    return []
}
// 위젯 화면 구성

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), friend: emptyFriend)
    }

    func snapshot(for configuration: FriendStatusConfigurationIntent, in context: Context) async -> SimpleEntry {
        let friend = matchedFriend(for: configuration.friend)
        return SimpleEntry(date: Date(), friend: friend)
    }

    func timeline(for configuration: FriendStatusConfigurationIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let friend = matchedFriend(for: configuration.friend)
        let entry = SimpleEntry(date: Date(), friend: friend)
        return Timeline(entries: [entry], policy: .atEnd)
    }

    private func matchedFriend(for selected: SelectableUser?) -> WidgetUserInfo {
        let all = loadPeopleFromUserDefaults()
        guard let nickname = selected?.nickname else { return emptyFriend }
        return all.first { $0.nickname == nickname } ?? emptyFriend
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let friend: WidgetUserInfo
}

struct Widget2PracticeEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        if entry.friend.nickname.isEmpty {
            VStack {
                Text("📌 Pick your favorite friend\nin the widget settings")
                    .multilineTextAlignment(.center)
                    .font(.custom("Alexandria-Bold", size: 14))
                    .foregroundColor(.gray)
            }
        } else {
            VStack(spacing: 0) {
                HStack {
                    Text(entry.friend.nickname)
                        .font(.custom("Alexandria-Bold", size: 14))
                        .foregroundColor(Color(hex: "#0D2481"))
                        .padding(.leading, 10)
                    
                    Spacer()
                }
                ZStack {
                    Image(
                        entry.friend.statusIconName == "RedIcon" ? "UserMapRedBackground" :
                            entry.friend.statusIconName == "YellowIcon" ? "UserMapYellowBackground" :
                            entry.friend.statusIconName == "GreenIcon" ? "UserMapGreenBackground" :
                            "UserMapBackgroundWidget"
                    )
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 140)
                    Image(entry.friend.userImageName)
                        .resizable()
                        .interpolation(.low)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.bottom, 10)
                    
                    Image(entry.friend.statusIconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .padding(.leading, -55)
                        .padding(.top, 50)
                }
                .padding(.top, 5)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                entry.friend.nickname.isEmpty
                ? nil
                : Image("FriendWidgetBackground")
            )
            .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

struct Widget2Practice: Widget {
    let kind: String = "Widget2Practice"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: FriendStatusConfigurationIntent.self, provider: Provider()) { entry in
            Widget2PracticeEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Friend Status")
        .description("Check your friend's mood at a glance!")
    }
}

#Preview(as: .systemSmall) {
    Widget2Practice()
} timeline: {
    SimpleEntry(date: .now, friend: WidgetUserInfo(
        nickname: "JudyJ",
        userImageName: "User1",
        statusIconName: "GreenIcon"
    ))
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
