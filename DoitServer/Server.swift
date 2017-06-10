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
    
    public static func sendSignUpRequest(withImage imageData:Data, userName:String?, email:String, andPassword password:String, completion: @escaping (AsyncResult<[String:AnyObject]>)->())  {
        let url = URL(string: "http://api.doitserver.in.ua/create")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData, withName: "avatar", fileName: "photo.jpg", mimeType: "image/jpg")
            if(userName != nil){
            multipartFormData.append((userName?.data(using: String.Encoding.utf8)!)!, withName: "username")
            }
            multipartFormData.append(email.data(using: String.Encoding.utf8)!, withName: "email")
            multipartFormData.append(password.description.data(using: String.Encoding.utf8)!, withName: "password")
        }, to: url!, method: .post, headers: [:], encodingCompletion: { (result) in
           
            switch(result){
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                
                upload.responseJSON(completionHandler: { (uploadResponse) in
                   // print("Server debug: " + uploadResponse.result.value)
                    let responseJson = uploadResponse.result.value as! [String: AnyObject]
                   // print("Debug response as JSON: \n" + (responseJson).description)
                    
                    completion(AsyncResult.Success(responseJson))
                })
            case .failure(let uploadError):
                print("Server debug Error: " + uploadError.localizedDescription)
                completion(AsyncResult.Failure(uploadError))
            }
        })

    }
    
    
    public static func upload(imageData:Data, description desc:String?, hashtag: String?, completion: @escaping (AsyncResult<[String: AnyObject]>)->())  {
        let url = URL(string: "http://api.doitserver.in.ua/image")
       // let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        //request.addValue(Server.token!, forHTTPHeaderField: "token")
        let hastags : String! = hashtag == nil ? "": hashtag!
        let longitude = 1.233
        let latitude = 12.124
        let headers: HTTPHeaders = ["token":Server.token!]
        
        
      Alamofire.upload(multipartFormData: { (multipartFormData) in
        multipartFormData.append(imageData, withName: "image", fileName: "photo.jpg", mimeType: "image/jpg")
        multipartFormData.append(((desc == nil ? "" : desc)?.data(using: String.Encoding.utf8)!)!, withName: "description")
        multipartFormData.append(hastags.data(using: String.Encoding.utf8)!, withName: "hashtag")
        multipartFormData.append(latitude.description.data(using: String.Encoding.utf8)!, withName: "latitude")
        multipartFormData.append(longitude.description.data(using: String.Encoding.utf8)!, withName: "longitude")

        
      }, to: url!, method: .post, headers: headers, encodingCompletion: { (result) in
        switch(result){
        case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
            upload.responseJSON(completionHandler: { (uploadResponse) in
                //self.
                 let responseJson = uploadResponse.result.value as! [String: AnyObject]
                completion(AsyncResult.Success(responseJson))
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
                            if(images.count > 0){
                           // print((images.first! as! [String: Any])["bigImagePath"] as! String)
                            ImagesHolder.sharedInstance.createImages(withArray: images)
                            }
                             completion(AsyncResult.Success(""))
                        }
                    }
                }catch{
                    completion(AsyncResult.Failure(error))
                }
        }
            }.resume()
    }
    
    public static func getGif(_ completion: @escaping (AsyncResult<[String:AnyObject]>)->())  {
        let url = URL(string: "http://api.doitserver.in.ua/gif")
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
                    if let dict = json as? [String : AnyObject]{
                        
                        completion(AsyncResult.Success(dict))
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
