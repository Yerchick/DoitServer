//
//  Server.swift
//  DoitServer
//
//  Created by user on 01.06.17.
//  Copyright © 2017 Yerchick. All rights reserved.
//

import Foundation


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
    
    public static func getAllImagesRequest(_ completion: @escaping (AsyncResult<String>)->())  {
        let url = URL(string: "http://api.doitserver.in.ua/all")
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        //let postString = "email=" + email + "&password=" + password
        request.addValue(token!, forHTTPHeaderField: "token")
       // request.httpBody =  postString.data(using: String.Encoding.utf8)
        session.dataTask(with: request) { (data, response, error) -> Void in
            if let data = data {
                print("------------------------")
                do{
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    print("---------")
                    if let dict = json as? [String : Any?]{
                        if let images = dict["images"] as? [Any] {
                            //completion(AsyncResult.Success(number))
                          //  images.count
                            
                            print((images.first! as! [String: Any])["bigImagePath"] as! String)
                            ImagesHolder.sharedInstance.createImages(withArray: images)
                            completion(AsyncResult.Success(""))
                            print("2----")
                          // let image = Image.init(json: images.first as! [String : Any])
                           // print(image.debugDescription)
                        }
                        //if let gif
                    }
                    print("3---------")
//                    let json = try JSONSerialization.jsonObject(with: data, options: [])
//                    print(json)
//                    if let dict = json as? [String : String]{
//                        if let number = dict["token"] {
//                            completion(AsyncResult.Success(number))
//                        }
//                    }
                }catch{
                    completion(AsyncResult.Failure(error))
                }
            }
            }.resume()
    }

    
    
}
