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
    
    
    public static func upload(imageData:Data,description desc:String, completion: @escaping (AsyncResult<String>)->())  {
        let url = URL(string: "http://api.doitserver.in.ua/image")
        //var result: String = ""
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue(Server.token!, forHTTPHeaderField: "token")
        request.addValue("sDAsdasdasd", forHTTPHeaderField: "description")
        let hastag = ""
        let longitude = 1.233
        let latitude = 12.124
        var postString = "image="
        var data = NSMutableData()
         data.append(   postString.data(using: String.Encoding.utf8)! )
        data.append(imageData)
        postString = "&description=" + desc
        postString += "&hashtag=" + hastag
         postString += "&latitude=" + (latitude.description)
        postString += "&logitude=" + (longitude.description)
        data.append(postString.data(using: String.Encoding.utf8)!)
       //  let boundary = "Boundary-\(NSUUID().uuidString)"
        
//        let param = [
//            "description"  : desc,
//            "hashtag"    : "#Kargopolov",
//            "latitude"    : "9",
//            "longitude" : "12"
//        ]
//        
        
       // request.httpBody = createRequestBodyWith(parameters: param as [String : NSObject], imageData: imageData, boundary: boundary) as Data
        
        
        
        request.httpBody =  data as Data
        session.dataTask(with: request) { (data, response, error) -> Void in
            if let data = data {
                print("------------------------")
                do{
                    print("0------------------------")
                    print(data)
                    print("1------------------------")
                    print(response)
                    print("2------------------------")
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    print("3------------------------")
                    completion(AsyncResult.Success(json as Any as! String))

                    print(json)
                    if let dict = json as? [String : String]{
                     //   if let number = dict["token"] {
                                                   // }
                    }
                }catch{
                    completion(AsyncResult.Failure(error))
                }
            }
            }.resume()
    }

//    public static func createRequestBodyWith(parameters:[String:NSObject], imageData:Data, boundary:String) -> NSData{
//        
//        let body = NSMutableData()
//        
//        for (key, value) in parameters {
//            body.appendString(string: "--\(boundary)\r\n")
//            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//            body.appendString(string: "\(value)\r\n")
//        }
//        
//        body.appendString(string: "--\(boundary)\r\n")
//        
//        let mimetype = "image/jpg"
//        
//        let defFileName = "yourImageName.jpg"
//        
//     //   let imageData = Image UIImageJPEGRepresentation(yourImage, 1)
//        
//        body.appendString(string: "Content-Disposition: form-data; name=\"HelloWorld\"; filename=\"\(defFileName)\"\r\n")
//        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
//        body.append(imageData)
//        body.appendString(string: "\r\n")
//        
//        body.appendString(string: "--\(boundary)--\r\n")
//        
//        return body
//    }
    
    
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
