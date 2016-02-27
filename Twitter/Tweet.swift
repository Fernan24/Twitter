//
//  Tweet.swift
//  Twitter
//
//  Created by Fernando Rodríguez on 2/15/16.
//  Copyright © 2016 Fernando Rodríguez. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var tweetID:String?
    var retweetCount:Int?
    var favouriteCount:Int?
    var elapsedTime:NSTimeInterval
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"]as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        elapsedTime = NSDate().timeIntervalSinceDate(createdAt!)
        tweetID = (dictionary["id_str"] as! String?)!
        retweetCount = Int((dictionary["retweet_count"] as! NSNumber?)!)
        favouriteCount = Int((dictionary["favorite_count"] as! NSNumber?)!)
    }
    class func tweetsWithArray(array:[NSDictionary] ) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
}
