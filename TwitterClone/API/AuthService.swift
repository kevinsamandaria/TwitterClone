//
//  AuthService.swift
//  TwitterClone
//
//  Created by Kevin  Sam Andaria on 20/12/22.
//

import Firebase
import UIKit

struct AuthCredential{
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService{
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, pasword: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pasword, completion: completion)
    }
    
    func registerUsers(credential: AuthCredential, completion: @escaping(Error?, DatabaseReference) -> Void){
        let email = credential.email
        let password = credential.password
        let fullname = credential.fullname
        let username = credential.username
        
        guard let imageData = credential.profileImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        
        storageRef.putData(imageData, metadata: nil) { (meta, error) in
            storageRef.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        print("DEBUG: ERROR is \(error.localizedDescription)")
                        return
                    }
                    
                    guard let uid = result?.user.uid else { return }
                    
                    let values = [
                        "email": email,
                        "fullname": fullname,
                        "username": username,
                        "profileImageUrl": profileImageUrl
                    ]
                    
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                }
            }
        }
    }
}
