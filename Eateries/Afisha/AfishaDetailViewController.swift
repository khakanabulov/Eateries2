//
//  EateryDetailViewController.swift
//  Eateries
//
//  Created by Хакан Абулов on 15/11/2018.
//  Copyright © 2018 Хакан Абулов. All rights reserved.
//

import UIKit
import CoreData

class AfishaDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var fetchResultsController: NSFetchedResultsController<Restaurant>!
    var restaurantObjects: [Restaurant] = []
    var restaurantA: RestaurantAfisha?

    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        if (!restaurantA!.isFavorite) {
            restaurantA?.isFavorite = true
          let image = UIImage(named: "starY.png")
//            favoriteButton.setImage(image, for: .selected)
            self.favoriteButton.setImage(image, for: .normal)
            //print(self.favoriteButton.imageView?.image)
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext // инициализируем(добираемся до) контекст(а)
            {
                let restaurant = Restaurant(context: context)
                restaurant.name = restaurantA!.name
                restaurant.type = restaurantA!.subway
                restaurant.location = restaurantA!.location
                let imageUI = UIImageView()
                let url = URL(string: restaurantA!.imageURL)
                imageUI.af_setImage(withURL: url!)
                restaurant.image = imageUI.image!.pngData()
                restaurant.phone = restaurantA!.phoneNumber
                restaurant.isFavorite = true
                do {
                    // пытаемся сохранить контекст
                    try context.save()
                    print("Сохранение удалось")
                } catch let error as NSError {
                    print("Не удалось сохранить данный \(error) \(error.userInfo)")
                }
            }
        } else {
            let image = UIImage(named: "starN.png")
            self.favoriteButton.setImage(image, for: .normal)
            fetchFavorite()
            var indexR: Int = 0
            var objectToDelete: Restaurant
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext { // создаем контекст
                for restaurantObject in self.restaurantObjects {
                    if (restaurantObject.name == self.restaurantA!.name) {
                        objectToDelete = restaurantObject
                        print("ObjToDel: \(objectToDelete)")
                        indexR = self.restaurantObjects.firstIndex(of: restaurantObject)!
                    } else {
                        print("Error")
                    }
                }
                //let restaurant =  restaurantAfisha as Restaurant
                //let objectToDelete = self.fetchResultsController.object(at: <#T##IndexPath#>)// выделяем объект для удаления
                
                objectToDelete = self.restaurantObjects[indexR]
                print(objectToDelete)
                context.delete(objectToDelete) // удаляем объект из контекста
                do {
                    try context.save()
                    self.restaurantA!.isFavorite = false
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    //    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
    //        guard let svc = segue.source as? RateViewController else {return}
    //        guard let rating = svc.restRating else {return}
    //        rateButton.setImage(UIImage(named: rating), for: .normal)
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        //        print(navigationController?.isViewLoaded)
        //navigationController?.isViewLoaded
        //        if (!(navigationController?.isBeingPresented)!) {
        //            navigationController?.loadView()
        //        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttons = [mapButton, favoriteButton]
        for button in buttons {
            guard let button = button else {break}
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
        }
        if ((restaurantA?.isFavorite)!) {
        let imageY = UIImage(named: "starY")
            favoriteButton.setImage(imageY, for: .normal)
        } else {
        let imageN = UIImage(named: "starN")
        favoriteButton.setImage(imageN, for: .normal)
        }
        //cell.thumbnailImageView!.af_setImage(withURL: url)
        let url = URL(string: (restaurantA?.imageURL)!)
        imageView.af_setImage(withURL: url!)
        tableView.estimatedRowHeight = 38
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero) // убирает деления под ячейкам(где их нет)
        if (restaurantA != nil) {
            title = restaurantA!.name
        }
    }
    
    func fetchFavorite() {
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest() //создаем запрос
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true) // создаем дескриптор(фильтр) по имени по возрастанию(указание того как мы хотим видеть выходные данные)
        fetchRequest.sortDescriptors = [sortDescriptor] // передаем фильтр запросу
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext { // создаем контекст
            self.fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil) // инициализируем FetchResultController
            self.fetchResultsController.delegate = self as? NSFetchedResultsControllerDelegate // подписываемся под то, что будем реализовывать методы протокола NSFetchedResultsControllerDelegate
            do {
                try self.fetchResultsController.performFetch() // пытаемся получить данные, выполняет запрос на получение, пункт throws обязывает использовать try
                restaurantObjects = self.fetchResultsController.fetchedObjects!
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EateryDetailTableViewCell
        if (restaurantA != nil) {
            switch indexPath.row {
            case 0:
                cell.keyLabel.text = "Название"
                cell.valueLabel.text = restaurantA!.name
            case 1:
                cell.keyLabel.text = "Метро"
                cell.valueLabel.text = restaurantA!.subway
            case 2:
                cell.keyLabel.text = "Адрес"
                cell.valueLabel.text = restaurantA!.location
            case 3:
                cell.keyLabel.text = "Телефон"
                cell.valueLabel.text = restaurantA!.phoneNumber
            default:
                break
            }
        }
        
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "afishaMapSegue" {
            if (restaurantA != nil) {
                let dvc = segue.destination as! MapViewController
                dvc.restaurantA = self.restaurantA
            }
        }
    }
}
