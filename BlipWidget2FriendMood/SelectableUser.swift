import AppIntents

struct SelectableUser: AppEntity, Identifiable, Hashable {
    var id: String
    var nickname: String

    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Friend")

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(nickname)")
    }

    static var defaultQuery = SelectableUserQuery()
}

struct SelectableUserQuery: EntityQuery {
    func entities(for identifiers: [SelectableUser.ID]) async throws -> [SelectableUser] {
        let all = try await self.allEntities()
        return all.filter { identifiers.contains($0.id) }
    }

    func suggestedEntities() async throws -> [SelectableUser] {
        try await self.allEntities()
    }

    func allEntities() async throws -> [SelectableUser] {
        let userDefaults = UserDefaults(suiteName: "group.com.ADA2025.blip") // AppGroup 이름 맞춰줘야 함
        if let data = userDefaults?.data(forKey: "peopleData"),
           let people = try? JSONDecoder().decode([Person].self, from: data) {
            let selectableUsers = people.map { person in
                SelectableUser(id: person.id.uuidString, nickname: person.nickname)
            }
            if !selectableUsers.isEmpty {
                return selectableUsers
            }
        }
        print("❗️ peopleData가 비어있거나 없어서 기본 친구를 반환합니다.")
        // 기본 친구라도 반환해서 로딩 무한대 방지
        return [
            SelectableUser(id: UUID().uuidString, nickname: "Sample Friend")
        ]
    }
}
