//
//  AppIntent.swift
//  BlipWidget2FriendMood
//
//  Created by 이주현 on 4/14/25.
//

import WidgetKit
import AppIntents

//struct ConfigurationAppIntent: WidgetConfigurationIntent {
//    static var title: LocalizedStringResource { "Configuration" }
//    static var description: IntentDescription { "This is an example widget." }
//
//    // An example configurable parameter.
//    @Parameter(title: "Favorite Emoji", default: "😃")
//    var favoriteEmoji: String
//}

struct FriendStatusConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select a Friend"

    @Parameter(title: "Select a Friend")
    var friend: SelectableUser?
}
