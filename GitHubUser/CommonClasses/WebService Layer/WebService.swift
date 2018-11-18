//
//  webService.swift
//  GitHubUser
//
//  Created by Aditya chitaliya on 17/11/18.
//  Copyright © 2018 Aditya chitaliya. All rights reserved.
//

import Foundation
import UIKit
class WebService: NSObject{
    static let shareInstance = WebService()
    func getServerAddress() -> String{
        return "https://api.github.com/users"
    }
    
    func getUserList(){
        let url : String = self.getServerAddress()
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = NSURL(string: url)! as URL
        request.httpMethod = "GET"
        self.makeApiCall(request, withNotificatioName: "userList")
    }
    
    func getUsersRepositories(_ userName: String){
        let url : String = self.getServerAddress() + userName
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = NSURL(string: url)! as URL
        request.httpMethod = "GET"
        self.makeApiCall(request, withNotificatioName: "userRepositories")
    }
    
    
    func makeApiCall(_ request: NSURLRequest, withNotificatioName notification: String){
        let req:URLRequest = request as URLRequest
        let configuration = URLSessionConfiguration .default
        let session = URLSession(configuration: configuration)
        
        let dataTask = session.dataTask(with: req, completionHandler: { ( data: Data?, response: URLResponse?, error: Error?) in
            // 1: Check HTTP Response for successful GET request
           DispatchQueue.main.async {
            guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                else {
                    print("error: not a valid http response")
                    NotificationCenter.default.post(name: Notification.Name(rawValue: notification), object: error, userInfo: nil)
                    //completionHandler(nil,statuscode as AnyObject, error)
                    return
            }
            switch (httpResponse.statusCode)
            {
            case 200:
                //let response = NSString (data: receivedData, encoding: String.Encoding.utf8.rawValue)
                //print("response is \(String(describing: response))")
                do {
                    let resposneDictionary: NSArray = try JSONSerialization.jsonObject(with: receivedData, options: .allowFragments) as! NSArray
                    NotificationCenter.default.post(name: Notification.Name(rawValue: notification), object: resposneDictionary, userInfo: nil)
                } catch {
                    print("error serializing JSON: \(error)")
                    NotificationCenter.default.post(name: Notification.Name(rawValue: notification), object: error, userInfo: nil)
                }

                break
            default:
                print("wallet GET request got response \(httpResponse.statusCode)")
                NotificationCenter.default.post(name: Notification.Name(rawValue: notification), object: error, userInfo: nil)
                
            }
            return ()
                }
        })
        dataTask.resume()
    }
    
    func makeApiCallToDownloadImage(_ urlString: String) -> UIImage{
        let session = URLSession(configuration: .default)
        let url: URL = URL(string: urlString)!
        var image: UIImage? = UIImage()
        let downloadPicTask = session.dataTask(with: url) { (data, response, error) in
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        image = UIImage(data: imageData)!
                      //  return imageData
                        // Do something with your image.
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        
        downloadPicTask.resume()
        if(image != nil){
            return UIImage(named: "user_icon")!
        }else{
            return image!
        }
        
    }
}
