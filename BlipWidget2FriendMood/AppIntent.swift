import WidgetKit
import AppIntents

struct FriendStatusConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select a Friend"

    @Parameter(title: "Select a Friend")
    var friend: SelectableUser?
}
