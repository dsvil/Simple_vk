//
// Created by Sergei Dorozhkin on 30.12.2020.
//

import Foundation
import RealmSwift

class Response: Decodable {
    var response: Datable
}

class Datable: Decodable {
    var items: [VkGroup]
}

class VkGroup: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var icon: String = ""


    enum CodingKeys: String, CodingKey {
        case id
        case name
        case icon = "photo_50"
    }
}
