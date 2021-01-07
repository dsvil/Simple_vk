//
//  FetchPhotos.swift
//  Simple_vk
//
//  Created by Sergei Dorozhkin on 01.01.2021.
//

import RealmSwift
import Alamofire

class ApiGetPhotosVK {

    static let shared = ApiGetPhotosVK()
    private let baseUrl = "https://api.vk.com/method/"
    private let version = "5.126"

    func getData(user: Int?, completion: @escaping () -> Void) {
        let request = "photos.get"
        guard let apiKey = Session.instance.token else {
            return
        }
        let parameters: Parameters = [
            "owner_id": user as Any,
            "album_id": "wall",
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
                let photos = try JSONDecoder().decode(ResponsePh.self, from: data)
                guard let user = user else {
                    return
                }
                photos.response.items.forEach {
                    $0.friendId = user
                }
                self.savePhotosData(photos.response.items)
                completion()
            } catch {
                print(error)
            }
        }
    }

    private func savePhotosData(_ items: [PhotoStaff]) {
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

