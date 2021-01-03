//
// Created by Sergei Dorozhkin on 02.01.2021.
//

import Foundation
import UIKit


struct GroupViewModel {
    let group: VkGroup

    init(group: VkGroup) {
        self.group = group
    }

    var profileImageUrl: URL? {
        URL(string: group.icon)
    }

    var item: NSAttributedString {
        let name = NSMutableAttributedString(string: group.name, attributes: [.font: UIFont.boldSystemFont(ofSize: 18)])
        return name
    }
}
