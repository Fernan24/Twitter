//
//  TweetCell.swift
//  Twitter
//
//  Created by Fernando Rodríguez on 2/18/16.
//  Copyright © 2016 Fernando Rodríguez. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var favouritesLabel: UILabel!
    var tweet: Tweet! {
        didSet {
            displayNameLabel.text = tweet.user?.name
            usernameLabel.text = "@\((tweet.user?.screenname)!)"
            tweetLabel.text = tweet.text
            timeLabel.text = String(tweet.createdAt)
            let url = tweet.user?.profileImageUrl
            profileImage.setImageWithURL(NSURL(string: url!)!)
            retweetsLabel.text = String(tweet.retweetCount!)
            favouritesLabel.text = String(tweet.favouriteCount!)
        }
    }
    var retweeted = false
    var favorited = false
    
    @IBAction func retweet(sender: UIButton) {
        if !retweeted {
            TwitterClient.sharedInstance.retweet(tweet.tweetID!)
            retweetButton.setImage(UIImage(named: "retweet-action-on.png"), forState: .Normal)
            retweeted = true
            retweetsLabel.text = String(tweet.retweetCount!+1)
            
        }else {
            TwitterClient.sharedInstance.unretweet(tweet.tweetID!)
            retweetButton.setImage(UIImage(named: "retweet-action.png"), forState: .Normal)
            retweeted = false
            retweetsLabel.text = String(tweet.retweetCount!)
        }
        
        
    }
    @IBAction func favorite(sender: UIButton) {
        if !favorited {
            TwitterClient.sharedInstance.favorited(tweet.tweetID!)
            favoriteButton.setImage(UIImage(named: "like-action-on.png"), forState: .Normal)
            favorited = true
            favouritesLabel.text = String(tweet.favouriteCount!+1)
        }else {
            TwitterClient.sharedInstance.unfavorited(tweet.tweetID!)
            favoriteButton.setImage(UIImage(named: "like-action.png"), forState: .Normal)
            favorited = false
            favouritesLabel.text = String(tweet.favouriteCount!)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = 5
        profileImage.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
