//
//  FlickrAPIHelper.swift
//  VirtualTourist
//
//  Created by Ilia Tikhomirov on 02/02/16.
//  Copyright © 2016 Ilia Tikhomirov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class FlickrAPIHelper: NSObject {
    
    static let sharedInstance = FlickrAPIHelper()
    
    let FLICKR_API_KEY:String = "6bfda59aa52659caeadd3a1cdca74f8c"
    let FLICKR_URL:String = "https://api.flickr.com/services/rest/"
    let SEARCH_METHOD:String = "flickr.photos.getRecent"
    let FORMAT_TYPE:String = "json"
    let JSON_CALLBACK:Int = 1
    let PRIVACY_FILTER:Int = 1
    let ACCURACY = 16
    
    
    func getPhotos(bbox: [Double], completionHandler: (output: JSON) -> Void ) {
        
        Alamofire.request(.GET, FLICKR_URL, parameters: ["method": SEARCH_METHOD, "api_key": FLICKR_API_KEY,"privacy_filter":PRIVACY_FILTER, "format":FORMAT_TYPE, "bbox": bbox, "accuracy": ACCURACY ,"nojsoncallback": JSON_CALLBACK])
            .responseJSON { response in
                
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print("RESULT VALUE")
                print(response.result)   // result of response serialization
                
                if(response.data != nil){
                    
                    var innerJson: JSON = JSON( data: response.data! )
                    
                    print("JSON")
                    print(innerJson)
                    
                    let farm:String = innerJson["photos"]["photo"][2]["farm"].stringValue
                    let server:String = innerJson["photos"]["photo"][2]["server"].stringValue
                    let photoID:String = innerJson["photos"]["photo"][2]["id"].stringValue
                    let secret:String = innerJson["photos"]["photo"][2]["secret"].stringValue
                    
                    let imageString:String = "http://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_n.jpg/"
                    print(imageString)

                    
                    completionHandler(output: innerJson)
                    
                    
                    
                }
        }
        
    }
    
}