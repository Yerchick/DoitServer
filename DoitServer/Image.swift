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
//    init(withPathToBigImage bigPath: String, created dateCreated: String,withId id:integer_t, parameters params:Parameters, andSmallImagePath smallImage:String){
//        bigImagePath = bigPath
//        created = dateCreated
//        self.id = id
//        parameters = params
//        smallImagePath = smallImage
//    }
    
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
        self.bigImagePath = bigImagePath
        self.created = created
        self.id = id
        self.parameters = Parameters.init(latitude: latitude, longitude: longitude, weather: weather)
        self.smallImagePath = smallImagePath
        ImagesHolder.sharedInstance.LoadedImages.append(self)
        print(ImagesHolder.sharedInstance.LoadedImages.count)
    }
}




