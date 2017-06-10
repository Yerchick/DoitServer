//
//  CollectionViewController.swift
//  DoitServer
//
//  Created by user on 03.06.17.
//  Copyright © 2017 Yerchick. All rights reserved.
//

import UIKit
import AlamofireImage
import FLAnimatedImage
import SVProgressHUD

class CollectionViewController: UICollectionViewController {

    fileprivate let reuseIdentifier = "newCell"
    fileprivate let itemsPerRow: CGFloat = 2
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    @IBAction func addImage(_ sender: UIBarButtonItem) {
     //   self.performSegue(withIdentifier: "addImage", sender: self)
    }
    
    @IBAction func showGif(_ sender: UIBarButtonItem) {
        Server.getGif { (result) in
            switch result {
            case .Success(let resultDict):
                print("Gif result success response: " + resultDict.description)
                let gifLocation = resultDict["gif"] as! String
                Settings.gifLocation = gifLocation
                self.showGif()
                break
            case .Failure(let error):
                
                break
            
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // getAllImages()
        getAllImages()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.hidesBackButton = true
        print("CollectionViewController loaded")
        
        
      //  self.collectionView?.register(ImagePhotoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func getAllImages(){
        SVProgressHUD.show()
        Server.getAllImagesRequest( {(result) in
            switch result
            {
            case .Success( _):
                SVProgressHUD.dismiss()
                //print("Success! " + respondString)
                self.collectionView?.reloadData()
                break
            case .Failure(let error):
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
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

        SVProgressHUD.show()
        cell.imageView?.af_setImage(withURL: imageURL, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.global(), imageTransition: UIImageView.ImageTransition.noTransition, runImageTransitionIfCached: true, completion: { (newImage) in
            SVProgressHUD.dismiss()
        })
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

extension CollectionViewController: UIPopoverPresentationControllerDelegate{
    
    func showGif(){
        print("showing GIF")
        let popoverContent = (self.storyboard?.instantiateViewController(withIdentifier: "popover"))! as! PopoverViewController
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSize.init(width: 200, height: 200)
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect.init(x: view.bounds.width/2 , y: view.bounds.height/2, width: 0, height: 0)
        
        do{
            popoverContent.image = try FLAnimatedImage.init(animatedGIFData: Data.init(contentsOf: URL.init(string: Settings.gifLocation!)!))
        }catch let errorr{
            print("error" + errorr.localizedDescription)
        }
        
       self.present(nav, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
