//
// Created by Sergei Dorozhkin on 29.12.2020.
//

import Foundation

final class Session {
    var token: String?
    var userId: Int?
    private init(){}
    static let instance = Session()
}
