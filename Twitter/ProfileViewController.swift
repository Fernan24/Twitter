//
//  ProfileViewController.swift
//  
//
//  Created by Fernando Rodríguez on 2/22/16.
//
//

import UIKit
var username:String?
class ProfileViewController: UIViewController {

    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var UsernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var dictionary:NSDictionary?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TwitterClient.sharedInstance.getUserData("fernan2012dj") { (user, error) -> () in
            self.dictionary = user
        }
        print(dictionary)
        
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
