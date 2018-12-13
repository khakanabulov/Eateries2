//
//  RestaurantAPIManager.swift
//  Eateries
//
//  Created by Хакан Абулов on 03/12/2018.
//  Copyright © 2018 Хакан Абулов. All rights reserved.
//

import Foundation



final class RestaurantAPIManager: APIManager {
    var sessionConfiguration: URLSessionConfiguration
    
    lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    }()
    
    enum PlacesType: FinalURLPoint {
        case Restaurant()
        
        var baseURL: URL {
            return URL(string: "https://kudago.com")!
        }
        
        var path: String {
            switch self {
            case .Restaurant():
                return "/places/?fields=id,categories,title&location=spb&categories=attract,cinema,museums&lon=37.6&lat=55.7&radius=900000&has_showings=movie&showing_since=1000000000&"
                //return "/public-api/v1.2/places/?fields=id,categories,title&location=msk&categories=restaurant"
            }
        }
        
        var request: URLRequest {
            //let url = URL(string: path , relativeTo: baseURL) // строка path relativeTo(относительно) baseURL ПОЧЕМУ ТО НЕ РАБОТАЕТ 404
            let url = URL(string: "https://kudago.com/public-api/v1.4/places/?fields=id,address,title&location=msk&categories=restaurants") // 400
            // print(url)
            return URLRequest(url: url!)
        }
        
        
    }
    
    
    init(sessionConfiguration:URLSessionConfiguration) {
        self.sessionConfiguration = sessionConfiguration
    }
    // создаем, т.к. в большинстве случаев у нас конфигурация - дефолтная
    convenience init() { // convenience - означает "удобный инициализатор" (нужно для того, чтобы можно было вызывать другие init внутри тела)
        self.init(sessionConfiguration: .default)
    }
    
    // метод возвращающий текущую погоду
    func fetchRestaurantWith(completionHandler: @escaping (APIResult<[RestaurantAfisha]>) -> Void) {
        let request = PlacesType.Restaurant().request
        
        fetch(request: request, parse: { (json) -> [RestaurantAfisha]? in
            if let dictionary = json["results"] as? [[String: AnyObject]] {
                var restauratArray: [RestaurantAfisha] = []
                print(dictionary)
                var id = 0
                for restaurant in dictionary {
                    restauratArray.insert(RestaurantAfisha(JSON: restaurant)!, at: id)
                    id += 1
                }
                return restauratArray
            } else {
                print("DER'MO")
                return nil
            }
            
        }, completionHandler: completionHandler)
    }
    
}
