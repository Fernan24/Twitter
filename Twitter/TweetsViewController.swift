//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Fernando Rodríguez on 2/16/16.
//  Copyright © 2016 Fernando Rodríguez. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var tweets:[Tweet]!
    var isMoreDataLoading = false
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 150
        
        let logo = UIImage(named: "Twitter_logo_blue_32.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        self.navigationController
        
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        }
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
    
        User.currentUser?.logout()
    
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        cell.tweet = tweets![indexPath.row]
        
        cell.tweetLabel.sizeToFit()
        
        return cell
    }
    func refreshControlAction(refreshControl: UIRefreshControl) {
        //Connect to the API to have the last update
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        }
        
        //update the collection data source
        refreshControl.endRefreshing()
    }
        
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "details" {
            let cell = sender as! TweetCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
            let tweetdetailViewController = segue.destinationViewController as! TweetDetailsViewController
            tweetdetailViewController.tweet = tweet
        }
        if segue.identifier == "profileview" {
            let button = sender as! UIButton
            let buttonFrame = button.convertRect(button.bounds, toView: self.tableView)
            let indexPath = tableView.indexPathForRowAtPoint(buttonFrame.origin)
            let profileController = segue.destinationViewController as! ProfileViewController
            profileController.username = (tweets![indexPath!.row].user?.screenname)!
        }
        if segue.identifier == "currentUser" {
            let controller = segue.destinationViewController as! ProfileViewController
            controller.username = _currentUser?.screenname
        }
        if segue.identifier == "replyfromcell" {
            let button = sender as! UIButton
            let buttonFrame = button.convertRect(button.bounds, toView: self.tableView)
            let indexPath = tableView.indexPathForRowAtPoint(buttonFrame.origin)
            let composeController = segue.destinationViewController as! TweetComposeViewController
            composeController.replyhandle = (tweets![indexPath!.row].user?.screenname)!
        }
        
        
    }


}
