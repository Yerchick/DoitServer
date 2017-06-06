//
//  AddImageViewController.swift
//  DoitServer
//
//  Created by user on 05.06.17.
//  Copyright © 2017 Yerchick. All rights reserved.
//

import UIKit

class AddImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    var imageLocation: String = ""
    
    @IBAction func uploadImage(_ sender: Any) {
        if(imageView.image != nil){
            
            
            
            let imageData = UIImageJPEGRepresentation(imageView.image!, 1)
            if imageData == nil {return}
            
            
           
            Server.upload(imageData: imageData!, description: "megaDescription", completion: { (result) in
                switch(result){
                case .Success(let responce):
                    print("Success!!!!!!!!")
                    
                    break
                case .Failure(_):
                    
                    break
                }
            })
            
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        // Do any additional setup after loading the view.
    }
    
    func selectImage(){
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
           // print((info[UIImagePickerControllerReferenceURL]) )
            imageLocation = ((info[UIImagePickerControllerReferenceURL] as! NSURL).deletingPathExtension?.description)!
            print(imageLocation)
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    


    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView
        selectImage()
        // Upload image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
