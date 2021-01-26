//
//  AuthService.swift
//  Simple_vk
//
//  Created by Sergei Dorozhkin on 21.01.2021.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct GroupsToWrite {
    let id: Int
    let name: String
    let profileImage: String
}

struct FireService {
    
    weak var delegate: AlertMassagePopUp?
    
    static let shared = FireService()

    func logUserIn(email: String, pwd: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: pwd, completion: completion)
    }

    func registerUser(credentials: AuthCredentials, completion: @escaping (Error?, DatabaseReference) -> Void) {
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else {
            print("No image here")
            return
        }
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        storageRef.putData(imageData, metadata: nil) { (meta, error) in
            storageRef.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else {
                    print("DEBUG: ImageLoad\(error!.localizedDescription)")
                    return
                }
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                    guard error == nil else {
                        delegate?.alertMessage(error!.localizedDescription)
                        return
                    }
                    guard let uid = result?.user.uid else {
                        return
                    }
                    let values = ["email": credentials.email, "fullname": credentials.fullname,
                                  "username": credentials.username, "profileImage": profileImageUrl]
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                }
            }
        }
    }
    func uploadGroup(group: GroupsToWrite, completion: @escaping (Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        guard let userId = Session.instance.userId else {
            return
        }
        let groupId = String(group.id)
        let values = [
            "userIdVK": userId,
            "name": group.name,
            "profileImage": group.profileImage
        ] as [String: Any]
        
        REF_USER_GROUPS.child(groupId).child(uid).updateChildValues(values, withCompletionBlock: completion)
    }
}

protocol AlertMassagePopUp: class {
    func alertMessage(_ massage: String)
}
