////
////  BlipWidget2FriendMoodLiveActivity.swift
////  BlipWidget2FriendMood
////
////  Created by 이주현 on 4/14/25.
////
//
//import ActivityKit
//import WidgetKit
//import SwiftUI
//
//struct BlipWidget2FriendMoodAttributes: ActivityAttributes {
//    public struct ContentState: Codable, Hashable {
//        // Dynamic stateful properties about your activity go here!
//        var emoji: String
//    }
//
//    // Fixed non-changing properties about your activity go here!
//    var name: String
//}
//
//struct BlipWidget2FriendMoodLiveActivity: Widget {
//    var body: some WidgetConfiguration {
//        ActivityConfiguration(for: BlipWidget2FriendMoodAttributes.self) { context in
//            // Lock screen/banner UI goes here
//            VStack {
//                Text("Hello \(context.state.emoji)")
//            }
//            .activityBackgroundTint(Color.cyan)
//            .activitySystemActionForegroundColor(Color.black)
//
//        } dynamicIsland: { context in
//            DynamicIsland {
//                DynamicIslandExpandedRegion(.leading) {
//                    Text("Leading")
//                }
//                DynamicIslandExpandedRegion(.trailing) {
//                    Text("Trailing")
//                }
//                DynamicIslandExpandedRegion(.bottom) {
//                    Text("Bottom \(context.state.emoji)")
//                    // more content
//                }
//            } compactLeading: {
//                Text("L")
//            } compactTrailing: {
//                Text("T \(context.state.emoji)")
//            } minimal: {
//                Text(context.state.emoji)
//            }
//            .widgetURL(URL(string: "http://www.apple.com"))
//            .keylineTint(Color.red)
//        }
//    }
//}
//
//extension BlipWidget2FriendMoodAttributes {
//    fileprivate static var preview: BlipWidget2FriendMoodAttributes {
//        BlipWidget2FriendMoodAttributes(name: "World")
//    }
//}
//
//extension BlipWidget2FriendMoodAttributes.ContentState {
//    fileprivate static var smiley: BlipWidget2FriendMoodAttributes.ContentState {
//        BlipWidget2FriendMoodAttributes.ContentState(emoji: "😀")
//     }
//     
//     fileprivate static var starEyes: BlipWidget2FriendMoodAttributes.ContentState {
//         BlipWidget2FriendMoodAttributes.ContentState(emoji: "🤩")
//     }
//}
//
//#Preview("Notification", as: .content, using: BlipWidget2FriendMoodAttributes.preview) {
//   BlipWidget2FriendMoodLiveActivity()
//} contentStates: {
//    BlipWidget2FriendMoodAttributes.ContentState.smiley
//    BlipWidget2FriendMoodAttributes.ContentState.starEyes
//}
