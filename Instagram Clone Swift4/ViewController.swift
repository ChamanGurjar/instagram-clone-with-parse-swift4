//
//  ViewController.swift
//  Instagram Clone Swift4
//
//  Created by Chaman Gurjar on 06/01/19.
//  Copyright © 2019 Chaman Gurjar. All rights reserved.
//

import UIKit
import Parse

//Parse server is hosted on -> https://back4app.com
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveSampleObjectToParseServer()
    }
    
    private func saveSampleObjectToParseServer() {
        let gameScore = PFObject(className:"GameScore")
        gameScore["score"] = 1337
        gameScore["playerName"] = "Sean Plott"
        gameScore["cheatMode"] = false
        gameScore.saveInBackground {
            (success: Bool, error: Error?) in
            if (success) {
                print("The object has been saved.")
            } else {
                print(error)
            }
        }
    }
    
}

