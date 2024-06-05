//
//  TweetService.swift
//  TwitterClone
//
//  Created by Kevin  Sam Andaria on 11/02/23.
//

import Foundation
import Firebase

struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(caption: String, type:UploadTweetConfiguration, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["uid": uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "retweet": 0,
                      "caption": caption] as [String : Any]
        
        switch type {
        case .tweet:
            REF_TWEET.childByAutoId().updateChildValues(values) { (error, ref) in
                guard let tweetID = ref.key else { return }
                REF_USER_TWEET.child(uid).updateChildValues([tweetID: 1], withCompletionBlock: completion)
            }
            
        case .reply(let tweet):
            REF_TWEET_REPLIES.child(tweet.tweetID).childByAutoId().updateChildValues(values, withCompletionBlock: completion)
            
        }
    }
    
    func fetchTweet(completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        REF_TWEET.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetID = snapshot.key
            
            UserService.shared.fetchUser(uid:  uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchTweet(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        REF_USER_TWEET.child(user.uid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            
            REF_TWEET.child(tweetID).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String:Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                
                UserService.shared.fetchUser(uid:  uid) { user in
                    let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
        }
    }
    
    func fetchReplies(forTweet tweet: Tweet, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        REF_TWEET_REPLIES.child(tweet.tweetID).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String : AnyObject] else { return }
            
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetID = snapshot.key
            
            UserService.shared.fetchUser(uid:  uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func likeTweet(tweet: Tweet, completion: @escaping (DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let likes = tweet.didlike ? tweet.likes - 1 : tweet.likes + 1
        REF_TWEET_LIKE.child(tweet.tweetID).child("likes").setValue(likes)
        
        if tweet.didlike {
            REF_USER_LIKES.child(currentUid).child(tweet.tweetID).removeValue { err, ref in
                REF_TWEET_LIKE.child(tweet.tweetID).removeValue(completionBlock: completion)
            }
        } else {
            REF_USER_LIKES.child(currentUid).updateChildValues([tweet.tweetID: 1]) { err, ref in
                REF_TWEET_LIKE.child(tweet.tweetID).updateChildValues([currentUid: 1], withCompletionBlock: completion)
            }
        }
    }
    
    func checkIfUserLikedTweet(_ tweet: Tweet, completion: @escaping(Bool) -> Void) {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_LIKES.child(currentUid).child(tweet.tweetID).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
}
