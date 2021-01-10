//
//  FetchGroups.swift
//  Simple_vk
//
//  Created by Sergei Dorozhkin on 31.12.2020.
//

import Alamofire
import RealmSwift


final class ApiGetGroupsVK {
    static let shared = ApiGetGroupsVK()
    private let baseUrl = "https://api.vk.com/method/"
    private let version = "5.126"

    func getData() {
        guard let user = Session.instance.userId else {
            return
        }
        guard let apiKey = Session.instance.token else {
            return
        }
        let request = "groups.get"
        let parameters: Parameters = [
            "user_ids": user,
            "extended": 1,
            "fields": "city,members_count,start_date",
            "access_token": apiKey,
            "v": version
        ]
        let url = baseUrl + request
        AF.request(url, method: .get, parameters:
        parameters).responseData { [self] response in
            guard let data = response.value else {
                return
            }
            do {
                let groups = try JSONDecoder().decode(Response.self, from: data)
                saveMyGroupsData(groups.response.items)
            } catch {
                print(error)
            }
        }
    }

    private func saveMyGroupsData(_ items: [VkGroup]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(items, update: .modified)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}
