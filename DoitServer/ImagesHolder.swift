//
//  ImagesHolder.swift
//  DoitServer
//
//  Created by user on 02.06.17.
//  Copyright © 2017 Yerchick. All rights reserved.
//

import Foundation


final class ImagesHolder{
    
    private init(){}
    
    var LoadedImages : [Image] = []
    
    static let sharedInstance = ImagesHolder()
    
    public func createImages(withArray array: [Any] ){
     print("creating images")
        array.forEach { (json:Any) in
            let dict = json as! [String: Any]
            print(Image.init(json: dict).debugDescription)
        }
       // print(LoadedImages.count)
        
    }
    
    
    
    public func getTemplateFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
}
