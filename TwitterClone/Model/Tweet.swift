//
//  Tweet.swift
//  TwitterClone
//
//  Created by Kevin  Sam Andaria on 12/02/23.
//

import Foundation

struct Tweet {
    let caption: String
    let tweetID: String
    let uid: String
    var likes: Int
    var timestamp: Date!
    let retweetCount: Int
    var user: User
    var didlike = false
    
    init(user: User, tweetID: String, dictionary: [String:Any]) {
        self.tweetID = tweetID
        self.user = user
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.retweetCount = dictionary["retweet"] as?  Int ?? 0
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
}
