//
//  MainScreenTableViewController.swift
//  Instagram Clone Swift4
//
//  Created by Chaman Gurjar on 08/01/19.
//  Copyright © 2019 Chaman Gurjar. All rights reserved.
//

import UIKit
import Parse

class UsersTableViewController: UITableViewController {
    
    private var users = Array<String>() //[String]()
    private var objectIds = Array<String>()  //[String]()
    private var isFollowing = Dictionary<String, Bool>()  //[String: Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUsersFromParse()
    }
    
    private func fetchUsersFromParse() {
        let query = PFUser.query()
        query?.whereKey("username", notEqualTo: PFUser.current()?.username)
        query?.findObjectsInBackground(block: { (fetchedUsers, err) in
            if let error = err {
                print(error.localizedDescription)
            } else if let users = fetchedUsers {
                self.users.removeAll()
                self.objectIds.removeAll()
                self.isFollowing.removeAll()
                for user in users as! [PFUser] {
                    if let userName = user.username, let userId = user.objectId {
                        self.users.append(userName.components(separatedBy: "@")[0])
                        self.objectIds.append(userId)
                        print("Saving User and userID")
                        self.getFollowingData(userId)
                    }
                }
                
                Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
                    self.tableView.reloadData()
                })
                //                self.tableView.reloadData()
                //                print("Reloading Table")
            }
            
        })
    }
    
    private func getFollowingData(_ userId: String) {
        let query = PFQuery(className: "Following")
        query.whereKey("follower", equalTo: PFUser.current()?.objectId)
        query.whereKey("following", equalTo: userId)
        query.findObjectsInBackground(block: { (fetchedObjects, error) in
            if let objects = fetchedObjects {
                if objects.isEmpty {
                    print("\(userId) NotFollowing and \(self.isFollowing.count)")
                    self.isFollowing[userId] = false
                } else {
                    print("\(userId) Following and \(self.isFollowing.count)")
                    self.isFollowing[userId] = true
                }
            }
        })
    }
    
    @IBAction func logoutUser(_ sender: UIBarButtonItem) {
        PFUser.logOut()
        performSegue(withIdentifier: "logout", sender: self)
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

extension UsersTableViewController {
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row]
        print("User \(users[indexPath.row])")
        print("Finding for \([objectIds[indexPath.row])")
        if let followingUser = isFollowing[objectIds[indexPath.row]] {
            if followingUser {
                cell.accessoryType = .checkmark
            }
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if let followingUser = isFollowing[objectIds[indexPath.row]] {
            if followingUser {
                isFollowing[objectIds[indexPath.row]] = false
                cell?.accessoryType = .none
                unfollowUser(indexPath)
            } else {
                isFollowing[objectIds[indexPath.row]] = true
                cell?.accessoryType = .checkmark
                followUser(indexPath)
            }
        }
        
    }
    
    private func followUser(_ indexPath: IndexPath) {
        let following = PFObject(className: "Following")
        following["follower"] = PFUser.current()?.objectId
        following["following"] = objectIds[indexPath.row]
        following.saveInBackground()
    }
    
    private func unfollowUser(_ indexPath: IndexPath) {
        let query = PFQuery(className: "Following")
        query.whereKey("follower", equalTo: PFUser.current()?.objectId)
        query.whereKey("following", equalTo: objectIds[indexPath.row])
        query.findObjectsInBackground(block: { (fetchedObjects, error) in
            if let objects = fetchedObjects {
                objects.forEach({ (object) in
                    object.deleteInBackground()
                })
                
            }
        })
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
