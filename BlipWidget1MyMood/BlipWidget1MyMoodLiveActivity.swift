//
//  BlipWidget1MyMoodLiveActivity.swift
//  BlipWidget1MyMood
//
//  Created by 이주현 on 4/13/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct BlipWidget1MyMoodAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct BlipWidget1MyMoodLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BlipWidget1MyMoodAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension BlipWidget1MyMoodAttributes {
    fileprivate static var preview: BlipWidget1MyMoodAttributes {
        BlipWidget1MyMoodAttributes(name: "World")
    }
}

extension BlipWidget1MyMoodAttributes.ContentState {
    fileprivate static var smiley: BlipWidget1MyMoodAttributes.ContentState {
        BlipWidget1MyMoodAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: BlipWidget1MyMoodAttributes.ContentState {
         BlipWidget1MyMoodAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: BlipWidget1MyMoodAttributes.preview) {
   BlipWidget1MyMoodLiveActivity()
} contentStates: {
    BlipWidget1MyMoodAttributes.ContentState.smiley
    BlipWidget1MyMoodAttributes.ContentState.starEyes
}
