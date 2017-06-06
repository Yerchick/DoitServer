//
//  ImagePhotoCell.swift
//  DoitServer
//
//  Created by user on 03.06.17.
//  Copyright © 2017 Yerchick. All rights reserved.
//

import UIKit

class ImagePhotoCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!

    
    func setImageWith(url: URL) {
        print("Download Started")
        ImagesHolder.sharedInstance.getTemplateFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print("Download Finished " + data.debugDescription)
            DispatchQueue.main.async() { () -> Void in
                self.imageView.image = UIImage(data: data)
                
            }
        }
    }
    
}
