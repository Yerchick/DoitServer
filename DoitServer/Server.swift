//
//  Server.swift
//  DoitServer
//
//  Created by user on 01.06.17.
//  Copyright © 2017 Yerchick. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

public enum AsyncResult<T>{
    case Success(T)
    case Failure(Error?)
}


public class Server {
    
    public static var token: String? = nil
    
    public static func sendSignInRequest(withEmail email:String, andPassword password:String, completion: @escaping (AsyncResult<String>)->())  {
        let url = URL(string: "http://api.doitserver.in.ua/login")
        //var result: String = ""
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let postString = "email=" + email + "&password=" + password
        request.httpBody =  postString.data(using: String.Encoding.utf8)
        session.dataTask(with: request) { (data, response, error) -> Void in
            if let data = data {
                print("------------------------")
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    if let dict = json as? [String : String]{
                        if let number = dict["token"] {
                            completion(AsyncResult.Success(number))
                        }
                    }
                }catch{
                    completion(AsyncResult.Failure(error))
                }
            }
            }.resume()
    }
    
    
    public static func upload(imageData:Data, imageLocation: NSURL, description desc:String, completion: @escaping (AsyncResult<String>)->())  {
        let url = URL(string: "http://api.doitserver.in.ua/image")
       // let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue(Server.token!, forHTTPHeaderField: "token")
        let imagePath = Bundle.main.bundlePath  + (imageLocation.path)!
        let hastag = ""
        let longitude = 1.233
        let latitude = 12.124
//        var postString = "image=" + imageLocation
//        postString += "&description=" + desc
//        postString += "&hashtag=" + hastag
//         postString += "&latitude=" + (latitude.description)
//        postString += "&longitude=" + (longitude.description)

        let headers: HTTPHeaders = ["token":Server.token!]
        
        
      Alamofire.upload(multipartFormData: { (multipartFormData) in
        multipartFormData.append(imageData, withName: "image", fileName: "photo.jpg", mimeType: "image/jpg")
       // multipartFormData.append(imagePath.data(using: String.Encoding.utf8)!, withName: "image")
        multipartFormData.append(desc.data(using: String.Encoding.utf8)!, withName: "description")
        multipartFormData.append(hastag.data(using: String.Encoding.utf8)!, withName: "hashtag")
        multipartFormData.append(latitude.description.data(using: String.Encoding.utf8)!, withName: "latitude")
        multipartFormData.append(longitude.description.data(using: String.Encoding.utf8)!, withName: "longitude")

        
      }, to: url!, method: .post, headers: headers, encodingCompletion: { (result) in
        switch(result){
        case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
            upload.responseJSON(completionHandler: { (uploadResponse) in
                //self.
                print(uploadResponse)
            })
        case .failure(let uploadError):
            
            print("error" + uploadError.localizedDescription)
            
        }
        })
        

    }
    
    
    public static func getAllImagesRequest(_ completion: @escaping (AsyncResult<String>)->())  {
        let url = URL(string: "http://api.doitserver.in.ua/all")
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue(token!, forHTTPHeaderField: "token")
        session.dataTask(with: request) { (data, response, error) -> Void in
            if let data = data {
                print("------------------------")
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    print("---------")
                    if let dict = json as? [String : Any?]{
                        if let images = dict["images"] as? [Any] {
                            print((images.first! as! [String: Any])["bigImagePath"] as! String)
                            ImagesHolder.sharedInstance.createImages(withArray: images)
                            completion(AsyncResult.Success(""))
                        }
                    }
                }catch{
                    completion(AsyncResult.Failure(error))
                }
        }
            }.resume()
    }


    
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
