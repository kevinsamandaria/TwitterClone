//
//  Constants.swift
//  TwitterClone
//
//  Created by Kevin  Sam Andaria on 20/12/22.
//

import Firebase

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_image")

let DB_REF = Database.database(url: "https://twitterclone-e67b5-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
let REF_USERS = DB_REF.child("users")
let REF_TWEET = DB_REF.child("tweets")
let REF_USER_TWEET = DB_REF.child("user-tweets")
let REF_USER_FOLLOWERS = DB_REF.child("user-followers")
let REF_USER_FOLLOWING = DB_REF.child("user-following")
let REF_TWEET_REPLIES = DB_REF.child("tweet-replies")


