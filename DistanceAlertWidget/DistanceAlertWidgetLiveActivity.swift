import ActivityKit
import WidgetKit
import SwiftUI

struct DistanceAlertWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var nickname: String
        var status: String
        var distance: String
    }

    var name: String
}

struct DistanceAlertWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DistanceAlertWidgetAttributes.self) { context in
            HStack {
                // 이미지
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color("GradationRedStart"), Color("GradationRedEnd")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image("User2")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 42, height: 42)
                        .clipShape(Circle())
                }
                
                // 글씨
                VStack(alignment: .leading) {
                    Text("\(context.state.status)")
                        .font(.caption)
                        .foregroundColor(Color.red)
                    
                    Text("\(context.state.nickname) in \(context.state.distance)")
                        .font(.callout)
                }
                
                Spacer()
                
                // 제일 오른쪽 아이콘
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color("GradationRedStart"), Color("GradationRedEnd")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 40, height: 40)
                    
                    
                    // :: 써드파티 뭐시기를 써서 string 안쓰고 이미지 관리 하는 법이 있음
                    Image("RedIcon")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 25, height: 25)
                        .clipShape(Circle())
                }
                
            }
            .padding(.horizontal, 10)
            .activityBackgroundTint(Color.black)
            .activitySystemActionForegroundColor(.white)

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("📍")
                        .font(.title2)
                }

                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing) {
                        Text(context.state.nickname)
                            .font(.headline)
                        Text(context.state.status)
                            .font(.caption)
                    }
                }

                DynamicIslandExpandedRegion(.center) {
                    VStack {
                        Text("\(context.state.nickname) 님이 근처에 있어요!")
                            .font(.subheadline)
                        Text("거리: \(context.state.distance)")
                            .font(.caption)
                    }
                }
            } compactLeading: {
                Text("📍")
            } compactTrailing: {
                Text(context.state.nickname.prefix(2))
            } minimal: {
                Text("👀")
            }
        }
    }
}

extension DistanceAlertWidgetAttributes {
    fileprivate static var preview: DistanceAlertWidgetAttributes {
        DistanceAlertWidgetAttributes(name: "World")
    }
}

extension DistanceAlertWidgetAttributes.ContentState {
    fileprivate static var example1: DistanceAlertWidgetAttributes.ContentState {
        DistanceAlertWidgetAttributes.ContentState(nickname: "Glowny", status: "Work Talk Only", distance: "10m")
    }

    fileprivate static var example2: DistanceAlertWidgetAttributes.ContentState {
        DistanceAlertWidgetAttributes.ContentState(nickname: "Alice", status: "Focus Mode", distance: "12m")
    }
}

#Preview("Notification", as: .content, using: DistanceAlertWidgetAttributes.preview) {
    DistanceAlertWidgetLiveActivity()
} contentStates: {
    DistanceAlertWidgetAttributes.ContentState.example1
    DistanceAlertWidgetAttributes.ContentState.example2
}
