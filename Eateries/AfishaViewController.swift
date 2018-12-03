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

    @IBOutlet weak var AfishaTableView: UITableView!
    
    var restaurants: [Restaurant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
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

}
