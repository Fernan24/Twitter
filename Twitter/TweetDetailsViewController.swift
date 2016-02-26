//
//  TweetDetailsViewController.swift
//  Twitter
//
//  Created by Fernando Rodríguez on 2/25/16.
//  Copyright © 2016 Fernando Rodríguez. All rights reserved.
//

import UIKit
import AFNetworking
class TweetDetailsViewController: UIViewController {
    
    var tweet:Tweet!

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    var retweeted = false
    var favorited = false
    @IBAction func retweet(sender: AnyObject) {
        if !retweeted {
            TwitterClient.sharedInstance.retweet(tweet.tweetID!)
            retweetButton.setImage(UIImage(named: "retweet-action-on.png"), forState: .Normal)
            retweeted = true
            retweetCountLabel.text = String(tweet.retweetCount!+1)
            
        }else {
            TwitterClient.sharedInstance.unretweet(tweet.tweetID!)
            retweetButton.setImage(UIImage(named: "retweet-action.png"), forState: .Normal)
            retweeted = false
            retweetCountLabel.text = String(tweet.retweetCount!)
        }
    }
    @IBAction func favorite(sender: AnyObject) {
        if !favorited {
            TwitterClient.sharedInstance.favorited(tweet.tweetID!)
            favoriteButton.setImage(UIImage(named: "like-action-on.png"), forState: .Normal)
            favorited = true
            favoriteCountLabel.text = String(tweet.favouriteCount!+1)
        }else {
            TwitterClient.sharedInstance.unfavorited(tweet.tweetID!)
            favoriteButton.setImage(UIImage(named: "like-action.png"), forState: .Normal)
            favorited = false
            favoriteCountLabel.text = String(tweet.favouriteCount!)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.setImageWithURL(NSURL(string: (tweet.user?.profileImageUrl)!)!)
        displayNameLabel.text = tweet.user?.name
        usernameLabel.text = tweet.user?.screenname
        tweetTextLabel.text = tweet.text
        timeLabel.text = tweet.createdAtString
        retweetCountLabel.text = String(tweet.retweetCount!)
        favoriteCountLabel.text = String(tweet.favouriteCount!)
        profileImage.layer.cornerRadius = 5
        profileImage.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
