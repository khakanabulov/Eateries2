//
//  RestaurantAfisha.swift
//  Eateries
//
//  Created by Хакан Абулов on 03/12/2018.
//  Copyright © 2018 Хакан Абулов. All rights reserved.
//

import Foundation
import Foundation
import UIKit

struct RestaurantAfisha {
    let name: String
    let location: String
    let subway: String
    let images: [[String: AnyObject]]
    let imageURL: String
    let phoneNumber: String
    var isFavorite: Bool
   // let imageView: UIImageView
    //let isVisited: Bool
}
//https://kudago.com/public-api/v1.2/places/?fields=id,categories,title&location=spb&categories=attract,cinema,museums&lon=37.6&lat=55.7&radius=900000&has_showings=movie&showing_since=1000000000&
extension RestaurantAfisha: JSONDecodable {
    // получаем значения из JSON
    init?(JSON: [String : AnyObject]) { // на вход получаем словарь
        guard let location = JSON["address"] as? String,
            let type = JSON["subway"] as? String,
            let name = JSON["title"] as? String,
            let images = JSON["images"] as? [[String: AnyObject]],
            let imageURL = images[0]["image"] as? String,
            let phoneNumber = JSON["phone"] as? String
            else {
                return nil
        }
        self.name = name
        self.location = location
        self.subway = "\(type)"
        self.images = images
        self.imageURL = imageURL
        self.phoneNumber = phoneNumber
        self.isFavorite = false
        //self.imageView.image.
    }
}
        

