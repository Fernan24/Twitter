//
//  TweetComposeViewController.swift
//  Twitter
//
//  Created by Fernando Rodríguez on 2/24/16.
//  Copyright © 2016 Fernando Rodríguez. All rights reserved.
//

import UIKit
import DoneHUD



class TweetComposeViewController: UIViewController, UITextViewDelegate {
    var replyhandle:String?
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var defaultTextLabel: UILabel!
    @IBOutlet weak var displayNameLabel: UILabel!
    
    @IBAction func postTweet(sender: UIBarButtonItem){
        DoneHUD.showInView(self.view, message: "Done")
        if replyhandle?.characters.count>0 {
            TwitterClient.sharedInstance.replyTweet(tweetTextView.text, userID: replyhandle)
        } else {
            TwitterClient.sharedInstance.composeTweet(tweetTextView.text!)
        }
        replyhandle = ""
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            //put your code which should be executed with a delay here
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    @IBAction func cancel(sender: AnyObject) {
        replyhandle = ""
        dismissViewControllerAnimated(true, completion: nil)
    }
    var count = 140
    let limitLength = 140
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.delegate = self
        tweetTextView.becomeFirstResponder()
        if (replyhandle != nil ){
            tweetTextView.text = "@\(replyhandle!) "
        }
        count=limitLength - tweetTextView.text.characters.count
        countLabel.text = String(count)
        displayNameLabel.text = (User.currentUser?.screenname)!
        profileImage.setImageWithURL(NSURL(string: (User.currentUser?.profileImageUrl)!)!)
        if(count<140){
            defaultTextLabel.hidden = true
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textViewDidChange(textView: UITextView) {
        count = limitLength - textView.text.characters.count
        countLabel.text = String(count)
        if count != limitLength {
            defaultTextLabel.hidden = true
        }else {
            defaultTextLabel.hidden = false
        }
        checkMaxLength(textView, maxLength: limitLength)
    }
    
    func checkMaxLength(textField: UITextView, maxLength: Int) {
        if textField.text?.characters.count > maxLength {
            textField.deleteBackward()
        }
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
