//
// Created by Sergei Dorozhkin on 30.12.2020.
//

import Alamofire
import RealmSwift

final class ApiGetFriendsVK {
    static let shared = ApiGetFriendsVK()
    private let baseUrl = "https://api.vk.com/method/"
    private let version = "5.126"

    func getData() {
        let request = "friends.get"
        guard let user = Session.instance.userId else {
            return
        }
        guard let apiKey = Session.instance.token else {
            return
        }
        let parameters: Parameters = [
            "user_ids": user,
            "fields": "photo_100",
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
                let friends = try JSONDecoder().decode(ResponseFd.self, from: data)
                self.saveMyFriendsData(friends.response.items)
            } catch {
                print(error)
            }
        }
    }

    private func saveMyFriendsData(_ items: [VkFriend]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(items, update: .all)
            print(realm.configuration.fileURL!)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}

