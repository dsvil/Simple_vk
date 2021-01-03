//
//  FetchSearchedGroups.swift
//  Simple_vk
//
//  Created by Sergei Dorozhkin on 01.01.2021.
//

import Alamofire
import RealmSwift

final class ApiGetGroupsVKSearch {

    static let shared = ApiGetGroupsVKSearch()
    let baseUrl = "https://api.vk.com/method/"
    let version = "5.126"

    func getData(searchText: String, completion: @escaping ([VkGroup]) -> Void) {
        let request = "groups.search"
        guard let apiKey = Session.instance.token else {
            return
        }
        let parameters: Parameters = [
            "q": searchText,
            "type": "group",
            "sort": 0,
            "access_token": apiKey,
            "v": version
        ]
        let url = baseUrl + request
        AF.request(url, method: .get, parameters:
        parameters).responseData { response in
            guard let data = response.value else {
                return
            }
            do {
                let groups = try JSONDecoder().decode(Response.self, from: data)
                self.saveGroupsData(groups.response.items)
                completion(groups.response.items)
            } catch {
                print(error)
            }
        }
    }
    func saveGroupsData(_ items: [VkGroup]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(items)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}
