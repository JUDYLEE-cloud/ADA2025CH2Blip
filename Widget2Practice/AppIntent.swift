// 위젯 설정 화면

import WidgetKit
import AppIntents

struct SelectableUser: AppEntity, Identifiable {
    var id: String { nickname }
    let nickname: String

    static var typeDisplayRepresentation: TypeDisplayRepresentation = .init(name: "친구")
    static var defaultQuery = UserQuery()

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(nickname)")
    }
}

struct UserQuery: EntityQuery {
    func suggestedEntities() async throws -> [SelectableUser] {
        loadPeopleFromUserDefaults().map { SelectableUser(nickname: $0.nickname) }
    }

    func entities(for identifiers: [String]) async throws -> [SelectableUser] {
        loadPeopleFromUserDefaults()
            .filter { identifiers.contains($0.nickname) }
            .map { SelectableUser(nickname: $0.nickname) }
    }
}

struct FriendStatusConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "친한 친구 선택"
    static var description = IntentDescription("위젯에 표시할 친구를 선택하세요.")

    @Parameter(title: "친한 친구")
    var friend: SelectableUser?
}
