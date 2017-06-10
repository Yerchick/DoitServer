//
//  AddImageViewController.swift
//  DoitServer
//
//  Created by user on 05.06.17.
//  Copyright © 2017 Yerchick. All rights reserved.
//

import UIKit
import CoreLocation

class AddImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

   // var imageLocation: NSURL? = nil
    @IBOutlet var descriptionFiled: UITextField!
    @IBOutlet var hashTagField: UITextField!
    
    @IBAction func uploadImage(_ sender: Any) {
        if(imageView.image != nil){
            
           self.updateCurrentLocation()
            
            let imageData = UIImageJPEGRepresentation(imageView.image!, 0.3)
            if imageData == nil {return}
            
            
           
            Server.upload(imageData: imageData!, description: descriptionFiled.text, hashtag: hashTagField.text, completion: { (result) in
                switch(result){
                case .Success(let responce):
                    DispatchQueue.main.async {
                        self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier:"collectionView"), animated: true)
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
    
   
    

}

extension AddImageViewController : CLLocationManagerDelegate{
    func updateCurrentLocation() {
    let locationManager = CLLocationManager()
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
    let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        Settings.latitude = locValue.latitude as Double
        Settings.longitude = locValue.longitude as Double
    }
}

