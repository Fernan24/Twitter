//
//  ProfileViewController.swift
//  
//
//  Created by Fernando Rodríguez on 2/22/16.
//
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var username:String?
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var UsernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var userdata:User?
    var tweets:[Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 150
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        TwitterClient.sharedInstance.getUserData(username) { (user, error) -> () in
            self.userdata = user
            //print(self.userdata)
            self.profileImage.setImageWithURL(NSURL(string: (self.userdata?.profileImageUrl)!)!)
            self.bannerImage.setImageWithURL(NSURL(string: (self.userdata?.bannerImageUrl)!)!)
            self.displayNameLabel.text = (self.userdata?.name)!
            self.UsernameLabel.text = "@\((self.userdata?.screenname)!)"
            self.descriptionLabel.text = self.userdata?.userdescription
            self.followersCountLabel.text = String((self.userdata?.followerCount)!)
            self.followingCountLabel.text = String((self.userdata?.followingCount)!)
            self.tweetCountLabel.text = String((self.userdata?.tweetsCount)!)
        }
        TwitterClient.sharedInstance.userTimelineWithParams(nil, userID: username) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        }
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        username = ""
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath) as! ProfileCell
        
        cell.tweet = tweets![indexPath.row]
        
        cell.tweetLabel.sizeToFit()
        
        return cell
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        //Connect to the API to have the last update
        TwitterClient.sharedInstance.userTimelineWithParams(nil, userID: username) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        }
        
        //update the collection data source
        refreshControl.endRefreshing()
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "profiledetails" {
            let cell = sender as! ProfileCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
            let tweetdetailViewController = segue.destinationViewController as! TweetDetailsViewController
            tweetdetailViewController.tweet = tweet
        }
        
    }
}
