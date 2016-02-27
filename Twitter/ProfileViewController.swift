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
    var userdata:User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username = "fernan2012dj"
        TwitterClient.sharedInstance.getUserData(username) { (user, error) -> () in
            self.userdata = user
            //print(self.userdata)
            self.profileImage.setImageWithURL(NSURL(string: (self.userdata?.profileImageUrl)!)!)
            self.bannerImage.setImageWithURL(NSURL(string: (self.userdata?.bannerImageUrl)!)!)
            self.displayNameLabel.text = (self.userdata?.name)!
            self.UsernameLabel.text = "@\((self.userdata?.screenname)!)"
            self.descriptionLabel.text = self.userdata?.userdescription
        }
        
        
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
