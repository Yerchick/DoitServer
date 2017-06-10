//
//  SignUpViewController.swift
//  DoitServer
//
//  Created by user on 01.06.17.
//  Copyright © 2017 Yerchick. All rights reserved.
//

import UIKit

class SignUpViewController : UIViewController{
    
    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var userName: UITextField!
    @IBOutlet var userEmail: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    @IBAction func signUp(_ sender: Any) {
        if(avatarImage.image == nil || userEmail.text == "" || passwordField.text == ""){
            return
            //TODO show info to fill with valid data
        }
        let imageData = UIImageJPEGRepresentation(avatarImage.image!, 0.3)
        if imageData == nil {return}
        
        
        Server.sendSignUpRequest(withImage: imageData!, userName: userName.text, email: userEmail.text!, andPassword: passwordField.text!) { (asyncResult) in
            switch asyncResult {
            case .Success(let dict):
                    if let token = dict["token"] {
                       Server.token = token as? String
                        DispatchQueue.main.async {
                            self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier:"collectionView"), animated: true)
                        }
                    }
                break;
            case .Failure(let error):
                print(error)
                break;
            }
        }
    }
    
    let imagePicker = UIImagePickerController()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        avatarImage.clipsToBounds = true
        avatarImage.layer.cornerRadius = avatarImage.frame.height/2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        avatarImage.isUserInteractionEnabled = true
        avatarImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }

}

extension SignUpViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            avatarImage.contentMode = .scaleAspectFit
            avatarImage.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
