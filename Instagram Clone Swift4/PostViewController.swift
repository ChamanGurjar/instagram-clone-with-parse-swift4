//
//  PostViewController.swift
//  Instagram Clone Swift4
//
//  Created by Chaman Gurjar on 09/01/19.
//  Copyright © 2019 Chaman Gurjar. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet private weak var postImageView: UIImageView!
    @IBOutlet weak var commentTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func chooseImage(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            postImageView.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postImage(_ sender: UIButton) {
        if let image = postImageView.image {
            let post = PFObject(className: "Post")
            post["userId"] = PFUser.current()?.objectId
            post["comment"] = commentTF.text!
            
            if let imageData = image.jpegData(compressionQuality: 1) {
                let imageFile = PFFile(name: "image.png", data: imageData)
                post["imageFile"] = imageFile
                
                post.saveInBackground { (success, err) in
                    if success {
                        self.showAlert(title: "Hurrah, Success", message: "Your image has been posted successfully")
                        self.commentTF.text = ""
                        self.postImageView.image = nil
                    } else {
                        self.showAlert(title: "Uhhh, Error", message: "Sorry image couldn't be posted. Please try again.")
                    }
                }
            }
        }
    }
    
    
    private func showAlert(title: String,  message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
