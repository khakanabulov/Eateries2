//
//  APIManager.swift
//  Eateries
//
//  Created by Хакан Абулов on 03/12/2018.
//  Copyright © 2018 Хакан Абулов. All rights reserved.
//

import Foundation

typealias JSONTask = URLSessionDataTask // переиминовали URLSessionDataTask в JSONTask
typealias JSONCompletionHandler = ([String: AnyObject]?, HTTPURLResponse?, Error?) -> Void // переименовали [String: AnyObject]?, HTTPURLResponse?, Error?) -> Void в JSONCompletionHandler

// протокол нужен для parse: (json) -> RestaurantAfisha
protocol JSONDecodable {
    init?(JSON: [String: AnyObject]) // init с возможностью провалиться(вернуть nil)
}

// Разобьем наш веб-адрес на baseURL и ту часть, которую мы добавляем к нему, затем мы здесь же запишем свойство "запрос"
// обеспечим себе простое формирование веб-адреса
protocol FinalURLPoint {
    var baseURL: URL { get }
    var path: String { get }
    var request: URLRequest { get }
}

enum APIResult<T> {
    case Success(T) // когда Success, передаем значения
    case Failure(Error) // показываем ошибку
}

protocol APIManager {
    var sessionConfiguration: URLSessionConfiguration { get } // указали конфигурации в сессии
    var session: URLSession { get } // создаем сессию на основе конфигураций выше
    
    // функция, которая получает данные , которая возвращает URLSessionDataTask(JSONTask)
    func JSONTaskWith(request: URLRequest, completionHandler:  @escaping JSONCompletionHandler) -> JSONTask
    func fetch<T: JSONDecodable>(request: URLRequest, parse: @escaping ([String: AnyObject]) -> T?, completionHandler: @escaping (APIResult<T>) -> Void)
    /* У нас есть 2 метода, которые позволяют получить данные
     1) Мы вызываем метод fetch и внутри этого метода мы используем JSONTaskWith(request: ...)
     Передаваемый в fetch - request передаем в JSONTaskWith(request: ...), затем там срабатывает completionHandler по заверщению которого мы получаем [String: AnyObject]?(JSON формат), HTTPURLResponse?, Error?)
     2) Затем мы пытаемся преобразовать полученные данные([String: AnyObject]) в формат T   (parse: ([String: AnyObject]?) -> T) (T у нас RestaurantAfisha)
     3) Затем, если у нас все срабатывает, срабатывает completionHandler: (APIResuls<T>) -> Void, который передает либо текущий экземпляр нашего RestaurantAfisha, либо какую-либо ошибку
     */
}


//// completionHandler -- ОБРАБОТЧИК ЗАВЕРШЕНИЯ
//// из-за расширения протокола, при подписывании под протокол получаем дефолтную реализацию, которая сделана уже в расширении
extension APIManager {
    
    func JSONTaskWith(request: URLRequest, completionHandler: @escaping JSONCompletionHandler) -> JSONTask { // использую @escaping по совету XCODE ОСТОРОЖНЕЕ
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            // проверяем пришел ли нам правильный ответ в формате HTTP
            guard let HTTPResponse = response as? HTTPURLResponse else {
                // domain - категория ошибки
                // code - код ошибки
                // userInfo - пояснение, что за ошибка для пользователя
                let userInfo = [
                    NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")
                ]
                let error = NSError(domain: NetworkingErrorDomain, code: 100, userInfo: userInfo)
                
                completionHandler(nil, nil, error) // вызываем closure с данной ошибкой
                return
            }
            // рассматриваем вариант, когда ответ пришел, но данные = nil
            if data == nil {
                if let error = error {
                    completionHandler(nil, HTTPResponse, error)
                }
            } else {
                switch HTTPResponse.statusCode {
                // если статус = 200, то все в порядке
                case 200:
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] // создаем объект json, как тип [String: AnyObject]
                        completionHandler(json, HTTPResponse, nil)
                    } catch let error as NSError {
                        completionHandler(nil, HTTPResponse, error)
                    }
                default:
                    print("У нас HTTP ответ со статус кодом - \(HTTPResponse.statusCode) != 200")
                }
            }
        }
        return dataTask
    }
    
    func fetch<T>(request: URLRequest, parse: @escaping ([String: AnyObject]) -> T?, completionHandler: @escaping (APIResult<T>) -> Void) {
        
        let dataTask = JSONTaskWith(request: request) { (json, response, error) in
            DispatchQueue.main.async(execute: { // переносим всю работу из фонового режима в главный поток
                // проверяем, получился ли у нас JSON, либо у нас nil
                guard let json = json else {
                    if let error = error { // если json = nil, проверяем наличие ошибки
                        completionHandler(.Failure(error)) // если ошибка есть, то ее мы и вызываем
                    }
                    return
                }
                //print(1)
                if let value = parse(json) { // смотрим, получилось ли у нас получить тип опционального T, через parse(json)
                   // print(2)
                    completionHandler(.Success(value))
                } else {
                    let error = NSError(domain: NetworkingErrorDomain, code: 200, userInfo: nil)
                    completionHandler(.Failure(error))
                }
            })
            
        }
        dataTask.resume() // запускаем функцию
    }
}
