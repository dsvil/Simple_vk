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
    var sizes = [GetUrl]()
}

class GetUrl: Object, Decodable {
    @objc dynamic var type: String = ""
    @objc dynamic var url: String = ""
}

