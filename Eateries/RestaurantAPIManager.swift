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
        case Restaurant() // узнаем текущий прогноз погоды
        
        var baseURL: URL {
            return URL(string: "https://kudago.com")!
        }
        
        var path: String {
            // в зависимости от того, какой прогноз погоды мы хотим знать, у нас будет свой адрес
            switch self {
            case .Restaurant():
                return "/public-api/v1.2/places/?fields=id,categories,title&location=msk&categories=restaurant"
            }
        }
        
        var request: URLRequest {
            let url = URL(string: path , relativeTo: baseURL) // строка path relativeTo(относительно) baseURL
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
    func fetchCurrentWeatherWith(completionHandler: @escaping (APIResult<RestaurantAfisha>) -> Void) {
        let request = PlacesType.Restaurant().request
        
        fetch(request: request, parse: { (json) -> RestaurantAfisha? in
            if let dictionary = json["restaurant"] as? [String: AnyObject] {
                return RestaurantAfisha(JSON: dictionary)
            } else {
                return nil
            }
            
        }, completionHandler: completionHandler)
    }
    
}
