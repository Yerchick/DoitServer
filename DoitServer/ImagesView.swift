//
//  ImagesView.swift
//  DoitServer
//
//  Created by user on 01.06.17.
//  Copyright © 2017 Yerchick. All rights reserved.
//

import UIKit



 class ImagesView: UICollectionView{
 
    
    fileprivate let reuseIdentifier = "newCell"
    fileprivate let itemsPerRow: CGFloat = 2
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
   
    
    
    
    
    
    override func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell? {
        let cell = self.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImagePhotoCell
        print("Index path"  + indexPath.debugDescription)
        
        let imageSmallLocation = ImagesHolder.sharedInstance.LoadedImages[indexPath[1]].smallImagePath
        let imageURL = URL(string: imageSmallLocation)!
        print (imageSmallLocation)
        ImagesHolder.sharedInstance.getTemplateFromUrl(url: imageURL) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            //  print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                cell.imageView.image = UIImage(data: data)
                
            }
        }
        return cell

    }
}



extension ImagesView : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = self.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
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
    override func numberOfItems(inSection section: Int) -> Int {
        print("number of items " + ImagesHolder.sharedInstance.LoadedImages.count.description)
        return  ImagesHolder.sharedInstance.LoadedImages.count
    }
}
