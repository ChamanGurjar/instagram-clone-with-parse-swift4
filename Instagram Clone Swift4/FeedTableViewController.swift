//
//  FeedTableViewController.swift
//  Instagram Clone Swift4
//
//  Created by Chaman Gurjar on 10/01/19.
//  Copyright © 2019 Chaman Gurjar. All rights reserved.
//

import UIKit
import Parse

class FeedTableViewController: UITableViewController {
    
    private var usersDic = Dictionary<String, String>()  //[String : String]
    private var comments = Array<String>()
    private var userNames = Array<String>()
    private var imageFilesArray = Array<PFFile>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUsersFromParse()
        
        getFollowingUsers()
    }
    
    private func fetchUsersFromParse() {
        let query = PFUser.query()
        query?.whereKey("userName", notEqualTo: PFUser.current()?.username)
        query?.findObjectsInBackground(block: { (objects, error) in
            if let users = objects {
                for user in users as! [PFUser] {
                    self.usersDic[user.objectId!] = user.username!
                }
            }
        })
    }
    
    /** Fetch the details of the following users whom loggedIn User is following.
     */
    private func getFollowingUsers() {
        let query = PFQuery(className: "Following")
        query.whereKey("follower", equalTo: PFUser.current()?.objectId)
        
        query.findObjectsInBackground { (objects, error) in
            if let following = objects {
                for follower in following {
                    if let followedUser = follower["following"] {
                        self.getPostOfFollowedUser(followedUser)
                    }
                }
            }
        }
    }
    
    
    private func getPostOfFollowedUser(_ followedUser: Any) {
        let getPostOfUserQuery = PFQuery(className: "Post")
        getPostOfUserQuery.whereKey("userId", equalTo: followedUser)
        getPostOfUserQuery.findObjectsInBackground(block: { (fetchedPosts, error) in
            if let posts = fetchedPosts {
                posts.forEach({ (post) in
                    self.comments.append(post["comment"] as! String)
                    self.userNames.append(self.usersDic[post["userId"] as! String]!)
                    self.imageFilesArray.append(post["imageFile"] as! PFFile)
                    
                    self.tableView.reloadData()
                })
                
            }
        })
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension FeedTableViewController {
    // MARK: - Table view data source
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comments.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
        if comments.count > 0 {
            cell.comment.text = comments[indexPath.row]
            cell.userInfo.text = userNames[indexPath.row]
            imageFilesArray[indexPath.row].getDataInBackground { (data, error) in
                if let imageData = data {
                    if let image = UIImage(data: imageData) {
                        cell.postedImge.image = image
                    }
                }
            }
        }
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
}
