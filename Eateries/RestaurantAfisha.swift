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
    let type: String
    //let isVisited: Bool
}

extension RestaurantAfisha: JSONDecodable {
    // получаем значения из JSON
    init?(JSON: [String : AnyObject]) { // на вход получаем словарь
        guard let name = JSON["title"] as? String,
            let location = JSON["address"] as? String,
            let type = JSON["slug"] as? String
//            let pressure = JSON["pressure"] as? Double,
//            let iconString = JSON["icon"] as? String
            else {
                return nil
        }
        self.name = name
        self.location = location
        self.type = type
    }
}
        
//        self.temperature = (temperature - 32) * 5/9 // переводим Фаренгейты в градусы по Цельсию
//        self.apparentTemperature = (apparentTemperature - 32) * 5/9
//        self.humidity = humidity * 100
//        self.pressure = pressure / 1.3333
//        self.icon = icon


//extension CurrentWeather {
//    var pressureString: String {
//        return "\(Int(pressure)) mm"
//    }
//    var temperatureString: String {
//        return "\(Int(temperature))˚C"
//    }
//    var apparentTemperatureString: String {
//        return "Fell's like \(Int(apparentTemperature))˚C"
//    }
//    var humidityString: String {
//        return "\(Int(humidity))%"
//    }
//}
