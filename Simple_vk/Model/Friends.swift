//
// Created by Sergei Dorozhkin on 30.12.2020.
//

import Foundation
import RealmSwift

class ResponseFd: Decodable {
    var response: DatableFd
}

class DatableFd: Decodable {
    var items: [VkFriend]
}

class VkFriend: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var icon: String


    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case icon = "photo_100"
    }

    override static func primaryKey() -> String? {
        return "id"
    }

    override static func indexedProperties() -> [String] {
        return ["firstName", "lastName"]
    }
}

