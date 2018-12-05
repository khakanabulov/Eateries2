//
//  AfishaViewController.swift
//  Eateries
//
//  Created by Хакан Абулов on 21/11/2018.
//  Copyright © 2018 Хакан Абулов. All rights reserved.
//

import UIKit
import WebKit

class AfishaViewController: UITableViewController {

    //@IBOutlet weak var AfishaTableView: UITableView!
    
    var restaurants: [RestaurantAfisha] = []
    lazy var weatherManager = RestaurantAPIManager(sessionConfiguration: .default)
    var id: Int = 0
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        getRestaurantData()
        }
    
    func allert(title: String, message: String, error: NSError) {
        let allertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        allertController.addAction(okAction)
        self.present(allertController, animated: true, completion: nil)
    }
    
    
    func getRestaurantData() { // fetch - получить
        weatherManager.fetchCurrentWeatherWith() { (result) in
            //self.toggleActivityIndicator(on: false)
            switch result {
            case .Success(let currentWeather):
                self.updateUIWith(currentWeather: currentWeather)
            case .Failure(let error as NSError):
                self.allert(title: "Unable to get data", message: error.localizedDescription, error: error)
            }
            
        }
    }
    
    // вызовем этот метод, когда у нас загружается приложение
    func updateUIWith(currentWeather: RestaurantAfisha) {
        restaurants.insert(currentWeather, at: id)
        id += 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
            return restaurants.count
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AfishaCell", for: indexPath) as! AfishaTableViewCell
        // создаем условие того, чтобы когда у нас идет поиск в таблицу выводился filteredResultArray, а обычно restaurants
        let restaurant = restaurants[indexPath.row]
        //cell.thumbnailImageView.image = UIImage(data: restaurant.image! as Data)//UIImage(named: restaurants[indexPath.row].image)
        //cell.thumbnailImageView.layer.cornerRadius = 32.5
        //cell.thumbnailImageView.clipsToBounds = true
        cell.nameLabel.text = restaurant.name
        cell.locationLabel.text = restaurant.location
        cell.typeLabel.text = restaurant.type
        //        if self.restaurantIsVisited[indexPath.row] {
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }
        //cell.accessoryType = restaurant.isVisited ? .checkmark : .none // Если ресторан посещали, добавляем в правой части галочку
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
    

    
//    var url = URL(string: "https://www.afisha.ru/msk/restaurants/luchshie-restorany-v-moskve/")
//    var webView: WKWebView!
//    var progressView: UIProgressView!
//
//    // удаляем обсервер, иначе все крашнется, если выйдем со страницы
//    deinit {
//        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        webView = WKWebView()
//        webView.navigationDelegate = self
//        view = webView // заменяем наш вью полностью вебвью
//
//        let request = URLRequest(url: url!) // создаем запрос по адресу
//        webView.load(request) // загружаем
//        webView.allowsBackForwardNavigationGestures = true // разрешаем использование жестов
//
//        progressView = UIProgressView(progressViewStyle: .default) // добавляем полосу загрузки
//        progressView.sizeToFit() // для того чтобы он занимал все место
//
//        let progressButton = UIBarButtonItem(customView: progressView) // размешаем наш progressButton вместо одной из кнопок табБара
//        let flexibleSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) // позволяет раскидывтаь элементы до тех пока позволяют рамки
//        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
//
//        toolbarItems = [progressButton, flexibleSpacer, refreshButton] // добавляем кнопки в массив
//        navigationController?.isToolbarHidden = false // чтобы тулбар точно был на экране
//
//        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil) // добавляем обзервер над прогрессом progressButton
//    }
//
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "estimatedProgress" { // если путь для отслеживания свойства = estimatedProgress
//            progressView.progress = Float(webView.estimatedProgress)
//        }
//    }
//
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        title = webView.title
//    }
//
//    /*
//     // MARK: - Navigation
//
//     // In a storyboard-based application, you will often want to do a little preparation before navigation
//     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//     // Get the new view controller using segue.destination.
//     // Pass the selected object to the new view controller.
//     }
//     */


