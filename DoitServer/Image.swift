//
//  Image.swift
//  DoitServer
//
//  Created by user on 02.06.17.
//  Copyright © 2017 Yerchick. All rights reserved.
//

import Foundation

struct Parameters {
    var latitude: Float
    var longitude: Float
    var weather: String
    var adress: String
}

class Image {
    var bigImagePath: String = ""
    var created: String = ""
    var id: NSInteger = 0
    var parameters: Parameters? = nil
    var smallImagePath: String = ""
    var description: String = ""
    var hashtag : String = ""
    var imageView : Image? = nil
    
    init?(json:[String:Any]){
        print("initing image")
        if let hashtag = json["hashtag"] as? String{
            self.hashtag = hashtag
        }

        guard let bigImagePath = json["bigImagePath"] as? String,
            let created = json["created"] as? String,
            let id = json["id"] as? NSInteger,
            let paramsDic = json["parameters"] as? [String:Any],
            let latitude = paramsDic["latitude"] as? Float,
            let longitude = paramsDic["longitude"] as? Float,
            let weather = paramsDic["weather"] as? String,
            let smallImagePath = json["smallImagePath"] as? String
        
            else{
                print("Error initing image")
                return nil
        }
        var adress = json["adress"] as? String
        if(adress == nil){adress = ""}
        
        self.bigImagePath = bigImagePath
        self.created = created
        self.id = id
        self.parameters = Parameters.init(latitude: latitude, longitude: longitude, weather: weather, adress: adress!)
        self.smallImagePath = smallImagePath
        ImagesHolder.sharedInstance.LoadedImages.append(self)
        print(ImagesHolder.sharedInstance.LoadedImages.count)
    }
}




