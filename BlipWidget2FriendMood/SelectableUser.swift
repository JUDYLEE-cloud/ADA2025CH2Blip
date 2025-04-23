import AppIntents
import SwiftUI

struct SelectableUser: AppEntity, Identifiable, Hashable {
    var id: String
    var nickname: String
    var statusIconName: String
    var userImageName: String

    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Friend")

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(nickname)")
    }

    static var defaultQuery = SelectableUserQuery()
}

struct SelectableUserQuery: EntityQuery {
    @AppStorage("nickname", store: UserDefaults(suiteName: "group.com.ADA2025.blip")) var storedNickname: String = ""
    
    func entities(for identifiers: [SelectableUser.ID]) async throws -> [SelectableUser] {
        let all = try await self.allEntities()
        return all.filter { identifiers.contains($0.id) }
    }

    func suggestedEntities() async throws -> [SelectableUser] {
        try await self.allEntities()
    }

    func allEntities() async throws -> [SelectableUser] {
        let userDefaults = UserDefaults(suiteName: "group.com.ADA2025.blip")
        
        if let data = userDefaults?.data(forKey: "peopleData"),
           let people = try? JSONDecoder().decode([Person].self, from: data) {
            // 🔥 Log before filtering
            print("🔥 people count: \(people.count)")
            print("🔥 storedNickname: \(storedNickname)")
            // 🟢 Log each nickname
            for person in people {
                print("🟢 person.nickname: \(person.nickname)")
            }
            let selectableUsers = people
                .filter { $0.nickname.lowercased() != storedNickname.lowercased() }
                .map { person in
                    SelectableUser(id: person.nickname, nickname: person.nickname, statusIconName: person.statusIconName ?? "", userImageName: person.userImageName)
                }
            if !selectableUsers.isEmpty {
                return selectableUsers
            }
        }
        
        print("❗️ peopleData가 비어있거나 없어서 기본 친구를 반환합니다.")
        return [
            SelectableUser(id: UUID().uuidString, nickname: "Error", statusIconName: "", userImageName: "")
        ]
    }
}

// struct UserList: Codable {
//     let id: UUID
//     let nickname: String
// }

//import AppIntents
//import SwiftUI
//
//struct SelectableUser: AppEntity, Identifiable, Hashable {
//    var id: String
//    var nickname: String
//
//    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Friend")
//
//    var displayRepresentation: DisplayRepresentation {
//        DisplayRepresentation(title: "\(nickname)")
//    }
//
//    static var defaultQuery = SelectableUserQuery()
//}
//
//struct SelectableUserQuery: EntityQuery {
//    @AppStorage("nickname", store: UserDefaults(suiteName: "group.com.ADA2025.blip")) var storedNickname: String = ""
//    func entities(for identifiers: [SelectableUser.ID]) async throws -> [SelectableUser] {
//        let all = try await self.allEntities()
//        return all.filter { identifiers.contains($0.id) }
//    }
//
//    func suggestedEntities() async throws -> [SelectableUser] {
//        try await self.allEntities()
//    }
//
//    func allEntities() async throws -> [SelectableUser] {
//        let userDefaults = UserDefaults(suiteName: "group.com.ADA2025.blip")
//        if let data = userDefaults?.data(forKey: "peopleData"),
//           let people = try? JSONDecoder().decode([UserInfo].self, from: data) {
//            _ = storedNickname
//            let selectableUsers = people
//                .filter { $0.nickname.lowercased() != storedNickname.lowercased() }
//                .map { person in
//                    SelectableUser(id: person.nickname, nickname: person.nickname)
//                }
//            if !selectableUsers.isEmpty {
//                return selectableUsers
//            }
//        }
//        print("❗️ peopleData가 비어있거나 없어서 기본 친구를 반환합니다.")
//        return [
//            SelectableUser(id: UUID().uuidString, nickname: "Sample Friend")
//        ]
//    }
//}
//
//struct UserList: Codable {
//    let id: UUID
//    let nickname: String
//}
