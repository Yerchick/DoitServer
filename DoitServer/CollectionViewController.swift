//
//  CollectionViewController.swift
//  DoitServer
//
//  Created by user on 03.06.17.
//  Copyright © 2017 Yerchick. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    fileprivate let reuseIdentifier = "newCell"
    fileprivate let itemsPerRow: CGFloat = 2
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    

    
    
    @IBOutlet weak var collectionView: ImagesView!
    
    override func viewDidLoad() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewDidLoad()
        print("CollectionViewController loaded")
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        Server.getAllImagesRequest( {(result) in
            switch result
            {
            case .Success( _):
                //print("Success! " + respondString)
                self.collectionView.reloadData()
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

    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImagePhotoCell
        print("Index path"  + indexPath.item.description)
        
        let imageSmallLocation = ImagesHolder.sharedInstance.LoadedImages[indexPath.item].smallImagePath
        let imageURL = URL(string: imageSmallLocation)!
        print ("Loadind with Url " + imageURL.debugDescription)
        cell.setImageWith(url: imageURL)

        //self.collectionView.reloadData()
        return cell
    }
    

    
    
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  ImagesHolder.sharedInstance.LoadedImages.count
    }
    
//    override func numberOfItems(inSection section: Int) -> Int {
//        print("number of items")
//        return  ImagesHolder.sharedInstance.LoadedImages.count
//    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
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
    
    //4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
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




