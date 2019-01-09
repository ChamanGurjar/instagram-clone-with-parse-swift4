//
//  PostViewController.swift
//  Instagram Clone Swift4
//
//  Created by Chaman Gurjar on 09/01/19.
//  Copyright © 2019 Chaman Gurjar. All rights reserved.
//

import UIKit

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
        
    }
    
}
