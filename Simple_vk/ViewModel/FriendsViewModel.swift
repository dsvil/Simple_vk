//
// Created by Sergei Dorozhkin on 02.01.2021.
//

import Foundation
import UIKit


struct FriendsViewModel {
    let friend: VkFriend

    init(friend: VkFriend) {
        self.friend = friend
    }

    var profileImageUrl: URL? {
        URL(string: friend.icon)
    }

    var item: NSAttributedString {
        let fio = NSMutableAttributedString(string: friend.lastName, attributes: [.font: UIFont.boldSystemFont(ofSize: 18)])
        fio.append(NSAttributedString(string: " \(friend.firstName)", attributes: [.font: UIFont.boldSystemFont(ofSize: 18)]))
        return fio
    }
}


