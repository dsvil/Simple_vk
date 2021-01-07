//
// Created by Sergei Dorozhkin on 30.12.2020.
//

import Foundation
import RealmSwift

class ResponsePh: Decodable {
    var response: DatablePh
}

class DatablePh: Decodable {
    var items: [PhotoStaff]
}

class PhotoStaff: Object, Decodable {
    @objc dynamic var id: Int = 0
    var sizes = List<GetUrl>()
    @objc dynamic var friendId: Int = 0

    enum CodingKeys: String, CodingKey {
        case id
        case sizes
    }

    override static func primaryKey() -> String? {
        return "id"
    }


}

class GetUrl: Object, Decodable {
    @objc dynamic var type: String = ""
    @objc dynamic var url: String = ""

    let id = LinkingObjects(fromType: PhotoStaff.self, property: "sizes")

    enum CodingKeys: String, CodingKey {
        case type
        case url
    }
}

