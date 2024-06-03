//
//  UploadTweetViewModel.swift
//  TwitterClone
//
//  Created by Kevin  Sam Andaria on 15/03/23.
//

import Foundation
import UIKit

enum UploadTweetConfiguration {
    case tweet
    case reply(Tweet)
}

struct UploadTweetViewModel {
    let actionButtonTitle: String
    let placeholderText: String
    var replyText: String?
    var shouldShowReplyLabel: Bool
    
    init(config: UploadTweetConfiguration) {
        switch config {
        case .tweet:
            actionButtonTitle = "Tweet"
            placeholderText = "What's Happening?"
            shouldShowReplyLabel = false
        case .reply(let tweet):
            actionButtonTitle = "Reply"
            placeholderText = "Tweet Your Replies"
            replyText = "Replying to @\(tweet.user.username)"
            shouldShowReplyLabel = true
        }
    }
}
