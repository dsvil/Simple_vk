//
//  FetchNews.swift
//  Simple_vk
//
//  Created by Sergei Dorozhkin on 04.01.2021.
//

import UIKit
import Alamofire

class ApiGetNewsVK {
    static let shared = ApiGetNewsVK()
    let baseUrl = "https://api.vk.com/method/"
    let version = "5.126"

    func getData() {
        let request = "wall.get"
//        let request = "newsfeed.get"
        guard let user = Session.instance.userId else {
            return
        }
        guard let apiKey = Session.instance.token else {
            return
        }
        let parameters: Parameters = [
            "user_ids": user,
            "owner_id": user,
            "extended": 1,
            "filters": "all",
            "count": 5,
            "access_token": apiKey,
            "v": version
        ]
        let url = baseUrl + request
        AF.request(url, method: .get, parameters:
        parameters).responseJSON { repsonse in
//                        print(repsonse.value!)
        }
    }
}
