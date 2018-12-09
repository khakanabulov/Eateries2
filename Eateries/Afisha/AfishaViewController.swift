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

    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        tableView.beginUpdates()
        tableView.reloadData()
        tableView.endUpdates()
    }
    //@IBOutlet weak var AfishaTableView: UITableView!
    
    var restaurants: [RestaurantAfisha] = [RestaurantAfisha(name: "name", location: "location", type: "type")]
    lazy var restaurantManager = RestaurantAPIManager(sessionConfiguration: .default)
    var id: Int = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 85 // устанавливаем ожидаемую высоту ячейки
        tableView.rowHeight = UITableView.automaticDimension // устанавливаем автоматическое вычисление высоты
        
        tableView.delegate = self
        tableView.dataSource = self
        // DispatchQueue.main.async(execute: {
            getRestaurantData()
        //})
        }
    
    func allert(title: String, message: String, error: NSError) {
        let allertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        allertController.addAction(okAction)
        self.present(allertController, animated: true, completion: nil)
    }
    
    
    func getRestaurantData() { // fetch - получить
        restaurantManager.fetchRestaurantWith() { (result) in
            //self.toggleActivityIndicator(on: false)
            print("result: \(result)")
            switch result {
            case .Success(let restaurant):
                self.updateUIWith(restaurant: restaurant)
            case .Failure(let error as NSError):
                self.allert(title: "Unable to get data", message: error.localizedDescription, error: error)
            }
            
        }
    }
    
    // вызовем этот метод, когда у нас загружается приложение
    func updateUIWith(restaurant: RestaurantAfisha) {
        restaurants.insert(restaurant, at: id)
        print(restaurants)
        id += 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(restaurants.count)
            return restaurants.count
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("vizvals9")
        let cell = tableView.dequeueReusableCell(withIdentifier: "AfishaCell", for: indexPath) as! AfishaTableViewCell
        // создаем условие того, чтобы когда у нас идет поиск в таблицу выводился filteredResultArray, а обычно restaurants
        let restaurant = restaurants[indexPath.row]
        print("cellForRowAt")
        print(restaurant)
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


