//
//  ImagesView.swift
//  DoitServer
//
//  Created by user on 01.06.17.
//  Copyright © 2017 Yerchick. All rights reserved.
//

import UIKit



final class ImagesView: UICollectionViewController{
 
    
    fileprivate let reuseIdentifier = "newCell"
    fileprivate let itemsPerRow: CGFloat = 2
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ImagesView did load")
        //addObserver(self, forKeyPath: #keyPath(ImagesHolder.LoadedImages), options: [], context: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
        Server.getAllImagesRequest { (result) in
            switch result
            {
            case .Success(let respondString):
                print("Images Success! " + respondString)
                
                break
            case .Failure(let error):
                print("Failure! " + error!.localizedDescription)
                break
            }
            self.collectionView?.reloadData()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ImagesView {
    
  

    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int{
        return  ImagesHolder.sharedInstance.LoadedImages.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImagePhotoCell
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
        
       // let image = ImagesHolder.sharedInstance.LoadedImages[indexPath[1]]
        
       // cell.backgroundColor = UIColor.black
        
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
        let availableWidth = view.frame.width - paddingSpace
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
    
}
