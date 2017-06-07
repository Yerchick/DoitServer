//
//  CollectionViewController.swift
//  DoitServer
//
//  Created by user on 03.06.17.
//  Copyright © 2017 Yerchick. All rights reserved.
//

import UIKit
import AlamofireImage

class CollectionViewController: UICollectionViewController {

    fileprivate let reuseIdentifier = "newCell"
    fileprivate let itemsPerRow: CGFloat = 2
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    @IBAction func addImage(_ sender: UIBarButtonItem) {
     //   self.performSegue(withIdentifier: "addImage", sender: self)
    }
    
    @IBAction func showGif(_ sender: UIBarButtonItem) {
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // getAllImages()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.hidesBackButton = true
        print("CollectionViewController loaded")
        getAllImages()
      //  self.collectionView?.register(ImagePhotoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func getAllImages(){
        Server.getAllImagesRequest( {(result) in
            switch result
            {
            case .Success( _):
                //print("Success! " + respondString)
                self.collectionView?.reloadData()
                break
            case .Failure( _):
                //print("Failure! " + error!.localizedDescription)
                break
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImagePhotoCell
        print("Index path"  + indexPath.item.description)
        
        let image = ImagesHolder.sharedInstance.LoadedImages[indexPath.item]
        let imageSmallLocation = image.smallImagePath
        let imageURL = URL(string: imageSmallLocation)!
        print ("Loadind with Url " + imageURL.debugDescription)
     //   cell.setImageWith(url: imageURL)
        cell.imageView?.af_setImage(withURL: imageURL)
        cell.setAdress(label: (image.parameters?.adress)!)
        cell.setWeather(label: (image.parameters?.weather)!)
        
        return cell
    }
    

    
    
    
    
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  ImagesHolder.sharedInstance.LoadedImages.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

}




