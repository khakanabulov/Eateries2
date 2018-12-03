//
//  ErrorManager.swift
//  Eateries
//
//  Created by Хакан Абулов on 03/12/2018.
//  Copyright © 2018 Хакан Абулов. All rights reserved.
//

import Foundation
// добавляем SWI, чтобы не произошло наложение имен, если такое имя может оказаться также в другой библиотеке
public let SWINetworkingErrorDomain = "ru.swiftbook.WeatherApp.NetworkingError"
public let MissingHTTPResponseError = 100 // отсутсвует HTTP ответ, код ошибки - 100
public let UnexpectedResponseError = 200 // ошибка при parse JSON, код ошибки - 200
