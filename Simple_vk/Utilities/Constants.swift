//
//  Constants.swift
//  Simple_vk
//
//  Created by Sergei Dorozhkin on 05.01.2021.
//

import Firebase

let DB_REF = Database.database().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")
let REF_USERS = DB_REF.child("users")
let STORAGE_REF = Storage.storage().reference()
let REF_USER_GROUPS = DB_REF.child("user-groups")



