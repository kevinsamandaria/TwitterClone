//
//  ProfileHeaderViewModel.swift
//  TwitterClone
//
//  Created by Kevin  Sam Andaria on 03/03/23.
//

import Foundation
import UIKit


enum profileFilterOption: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    private let user: User
    
    let usernameText: String
    
    var followersString: NSAttributedString? {
        return atributedText(withValue: user.stat?.followers ?? 0, text: " followers")
    }
    
    var followingString: NSAttributedString? {
        return atributedText(withValue: user.stat?.following ?? 0, text: " following")
    }
    
    var actionButtonTitle: String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        
        if !user.isFollowed && !user.isCurrentUser {
            return "Follow"
        }
        
        if user.isFollowed {
            return "Following"
        }
        
        return "Loading..."
    }
    
    init(user: User) {
        self.user = user
        self.usernameText = "@" + user.username
    }
    
    fileprivate func atributedText(withValue value: Int, text: String) -> NSAttributedString {
        let atributedTitle = NSMutableAttributedString(string: " \(value)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        atributedTitle.append(NSAttributedString(string: " \(text)", attributes: [.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        
        return atributedTitle
    }
}
