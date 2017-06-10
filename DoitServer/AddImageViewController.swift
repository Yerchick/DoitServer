//
//  AddImageViewController.swift
//  DoitServer
//
//  Created by user on 05.06.17.
//  Copyright © 2017 Yerchick. All rights reserved.
//

import UIKit

class AddImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

   // var imageLocation: NSURL? = nil
    @IBOutlet var descriptionFiled: UITextField!
    @IBOutlet var hashTagField: UITextField!
    
    @IBAction func uploadImage(_ sender: Any) {
        if(imageView.image != nil){
            
            
            
            let imageData = UIImageJPEGRepresentation(imageView.image!, 0.3)
            if imageData == nil {return}
            
            
           
            Server.upload(imageData: imageData!, description: descriptionFiled.text, hashtag: hashTagField.text, completion: { (result) in
                switch(result){
                case .Success(let responce):
                    DispatchQueue.main.async {
                        self.navigationController?.performSegue(withIdentifier: "collectionView", sender: self)
                    }
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
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    


    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView
        selectImage()
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
