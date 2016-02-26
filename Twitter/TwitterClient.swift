//
//  TwitterClient.swift
//  Twitter
//
//  Created by Fernando Rodríguez on 2/15/16.
//  Copyright © 2016 Fernando Rodríguez. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "p4WOeM9qBBAtIMIhbHllqBAzz"
let twitterConsumerSecret = "k73N9qkzAAPUzVIQi7hnJj4F6oIhbiH5qMr9tZtcK7XhyueEs3"
let twitterBaseUrl = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    var loginCompletion: ((user:User?, error: NSError?)->())?
    class var sharedInstance:TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseUrl, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    func loginWithCompletion(completion :(user: User?, error: NSError?)->()) {
        loginCompletion = completion
        //fetch request token and redirect t authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "Get", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: {(requestToken:BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            let authURL = NSURL(string:"https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }, failure: {(error: NSError!) -> Void in
                print("Failed to get request token")
                self.loginCompletion!(user: nil, error: error)
        })
    }
    func openUrl(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token",
            method: "POST",
            requestToken: BDBOAuth1Credential(queryString: url.query),
            success: {(accessToken: BDBOAuth1Credential!) -> Void in
                print("got access token")
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil,
                    success: {(operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                        //print("user: \(response)")
                        let user = User(dictionary: response as! NSDictionary)
                        User.currentUser = user
                        //print("username: \(user.name)")
                        self.loginCompletion?(user: user, error: nil)
                        
                    }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                        
                        print("error getting user")
                        self.loginCompletion?(user: nil, error: error)
                        
                })
                
            }) {(error: NSError!) -> Void in
                print("Failed to receive acces token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweet: [Tweet]?, error: NSError?)-> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params,
            success: { (operation: NSURLSessionDataTask?, response: AnyObject?) -> Void in
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
               
                completion(tweet: tweets, error: nil)
            },
            
            failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Failed to get the infomation")
                completion(tweet: nil, error: error)
                self.loginCompletion!(user: nil, error: error)
        })
        
    }
    func retweet(id:String){
        TwitterClient.sharedInstance.POST("1.1/statuses/retweet/\(id).json", parameters:nil , success: { (operation:NSURLSessionDataTask?, response:AnyObject?) -> Void in
            print("successfully retweeted")
            }) { (operation:NSURLSessionDataTask?, error:NSError!) -> Void in
                print("failed to retweet")
                
        }
        
    }
    func unretweet(id:String) {
        TwitterClient.sharedInstance.POST("1.1/statuses/unretweet/\(id).json", parameters:nil , success: { (operation:NSURLSessionDataTask?, response:AnyObject?) -> Void in
            print("successfully unretweeted")
            print(response)
            }) { (operation:NSURLSessionDataTask?, error:NSError!) -> Void in
                print("failed to unretweet")
        }
    }
    
    func favorited(id:String) {
        TwitterClient.sharedInstance.POST("1.1/favorites/create.json?id=\(id)", parameters:nil , success: { (operation:NSURLSessionDataTask?, response:AnyObject?) -> Void in
            print("successfully favorited")
            print(response)
            }) { (operation:NSURLSessionDataTask?, error:NSError!) -> Void in
                print("failed to favorited")
        }
    }
    func unfavorited(id:String) {
        TwitterClient.sharedInstance.POST("1.1/favorites/destroy.json?id=\(id)", parameters:nil , success: { (operation:NSURLSessionDataTask?, response:AnyObject?) -> Void in
            print("successfully unfavorited")
            print(response)
            }) { (operation:NSURLSessionDataTask?, error:NSError!) -> Void in
                print("failed to unfavorited")
        }
    }
    func getUserData(screenName:String, completion: (user: NSDictionary?, error: NSError?)-> ()) {
        var userRepsonse:NSDictionary?
        TwitterClient.sharedInstance.GET("1.1/users/show.json?screen_name=\(screenName)", parameters: nil, success: { (operation: NSURLSessionDataTask?, response: AnyObject?) -> Void in
            print("Success")
            userRepsonse = response as! NSDictionary
            //print(userRepsonse!)
            completion(user: userRepsonse, error: nil)
            }) { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Failed to get user")
                completion(user: nil, error: error)
        }
    }
    func composeTweet (text:String?) {
        POST("1.1/statuses/update.json?status=\(text)", parameters: nil, success: { (operation:NSURLSessionDataTask, response:AnyObject?) -> Void in
            print("successfuly posted tweet")
            }) { (operation:NSURLSessionDataTask?, error:NSError) -> Void in
                print("failed to tweet")
        }
    }
    
}
