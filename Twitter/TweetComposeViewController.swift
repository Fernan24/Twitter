//
//  TweetComposeViewController.swift
//  Twitter
//
//  Created by Fernando Rodríguez on 2/24/16.
//  Copyright © 2016 Fernando Rodríguez. All rights reserved.
//

import UIKit

class TweetComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var defaultTextLabel: UILabel!
    
    @IBAction func postTweet(sender: UIBarButtonItem) {
        let urlwithPercentEscapes = tweetTextView.text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        print(urlwithPercentEscapes!)
        TwitterClient.sharedInstance.composeTweet(urlwithPercentEscapes!)
    }
    var count = 140
    let limitLength = 140
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.delegate = self
        tweetTextView.becomeFirstResponder()
        //tweetTextView.clearsOnInsertion = true
        countLabel.text = String(count)
        // Do any additional setup after loading the view.
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
