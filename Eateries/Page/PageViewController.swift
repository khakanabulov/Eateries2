//
//  PageViewController.swift
//  Eateries
//
//  Created by Хакан Абулов on 20/11/2018.
//  Copyright © 2018 Хакан Абулов. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var headersArray = ["Записывайте", "Находите"]
    var subheadersArray = ["Создайте свой список любимых ресторанов", "Найдите и отметьте на карте ваши любимые рестораны"]
    var imagesArray = ["food", "iphoneMap"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = (self as UIPageViewControllerDataSource)
        //загрузили первый ContentViewController
        if let firstVC = displayViewController(AtIndex: 0) {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // проверяем переходной индекс и подставляем значения в наш contentVC
    func displayViewController(AtIndex index: Int) -> ContentViewController? {
        guard index >= 0 else { return nil }
        guard index < headersArray.count else { return nil }
        // получаем ContentViewController с помощью Storyboard Identifier
        guard let contentVC = storyboard?.instantiateViewController(withIdentifier: "contentViewController") as? ContentViewController else { return nil }
        contentVC.imageFile = imagesArray[index]
        contentVC.header = headersArray[index]
        contentVC.subheader =  subheadersArray[index]
        contentVC.index = index
        return contentVC;
    }
    
    func nextVC(AtIndex index: Int) {
        if let contentVC = displayViewController(AtIndex: index + 1) { // пробуем получить наш contentVC
            setViewControllers([contentVC], direction: .forward, animated: true, completion: nil) // отображаем нужный contentVC
        }
    }
    
}

// т.к. наш PageViewController должен позволять перемещаться вперед и назад по нашим ViewController, нужно подписаться на UIPageViewControllerDataSource
extension PageViewController: UIPageViewControllerDataSource {
    // методы говорят о том, как должны меняться индексы ContentViewController, когда мы листаем вперед и назад
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index // получили индекс данного VC
        index -= 1
        return displayViewController(AtIndex: index)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ContentViewController).index // получили индекс данного VC
        index += 1
        return displayViewController(AtIndex: index)
    }
    
// создам свой кастомный(черная полоска снизу не очень)
//    // возвращаем количество слайдов, которые у нас есть (все это нужно для отображения бара переключателя снизу)
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return headersArray.count
//    }
//
//    // возвращаем индекс конкретного контентВС на котором сейчас находимся
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        let contentVC = storyboard?.instantiateViewController(withIdentifier: "contentViewController") as? ContentViewController
//        return contentVC!.index
//    }
    
}
