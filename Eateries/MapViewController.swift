//
//  MapViewController.swift
//  Eateries
//
//  Created by Хакан Абулов on 16/11/2018.
//  Copyright © 2018 Хакан Абулов. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var restaurant: Restaurant!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let geocoder = CLGeocoder() //  из текстового формата адреса преобразовывает в широту и долготу(и наоборот умеет)
        geocoder.geocodeAddressString(restaurant.location!) { (placemarks, error) in // placemarks -  массив возможных адресов
            guard error == nil else {return}
            guard let placemarks = placemarks else {return}
            let placemark = placemarks.first! // берем первый адрес из массива
            
            let annotation = MKPointAnnotation() // создаем точку аннотации
            annotation.title = self.restaurant.name // даем ей имя
            annotation.subtitle = self.restaurant.type // даем тип
            guard let location = placemark.location else {return} // проверяем можем ли мы получить место(в качестве широты и долготы)
            annotation.coordinate = location.coordinate // присваиваем координатам аннотации координаты места(то что выше)
            self.mapView.showAnnotations([annotation], animated: true) // показываем аннотации на карте
            self.mapView.selectAnnotation(annotation, animated: true) // сразу раскрывает аннотацию(не нужно на нее нажимать)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? { //создаем аннотацию(маленькое табло с информацией), поверх иголки(pin) (заменяем(как мне кажется) дефолтный красный круг)
        guard !(annotation is MKUserLocation) else {return nil} //проверили, что это не наше текущее мепстоположение
        let annotationIdentifier = "restAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView // переиспользуем аннотацию, так же как и ячейки
        // если вызыывать не as MKPinAnnotationView, a as MKAnnotationView получим аннотацию без иголки(pin)

        if (annotationView == nil) { // если не получилось через переиспользование создать аннотацию, создаем новую
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true // позволяем отображать дополнительную информацию аннотации
        }
        let rigthImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) // создаем рамку для ImageView, который поместим в annotationView
        rigthImage.image = UIImage(data: restaurant.image! as Data)//UIImage(named: restaurant.image) // помещаем картинку в рамку
        annotationView?.rightCalloutAccessoryView = rigthImage // помещаем кратинку с рамкой в правую часть annotationView
        annotationView?.pinTintColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1) //изменяем цвет иголочки
        return annotationView
    }
    
}
