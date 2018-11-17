//
//  EateriesTableViewController.swift
//  Eateries
//
//  Created by Хакан Абулов on 12/11/2018.
//  Copyright © 2018 Хакан Абулов. All rights reserved.
//

import UIKit
import CoreData

class EateriesTableViewController: UITableViewController {
    var fetchResultsController: NSFetchedResultsController<Restaurant>! // нужен для получения данных(Хорошо работает с TableView)
    var restaurants: [Restaurant] = []
    
//        Restaurant(name: "ФАРШ", type: "ресторан", location: "Москва", image: "FARSH.jpg", isVisited: false),
//        Restaurant(name: "Баскин Робинс", type: "ресторан-мороженное", location: "Москва", image: "BR.jpg", isVisited: false),
//        Restaurant(name: "Тануки", type: "Суши-ресторан", location: "Москва", image: "tanuki.jpg", isVisited: false),
//        Restaurant(name: "Дастархан", type: "ресторан", location: "Москва, ул. Новый Арбат, 13", image: "dastarhan.jpg", isVisited: false),
//        Restaurant(name: "Кафе Пушкинъ", type: "ресторан", location: "Москва", image: "indokitay.jpg", isVisited: false),
//        Restaurant(name: "X.O", type: "ресторан-клуб", location: "Москва", image: "x.o.jpg", isVisited: false),
//        Restaurant(name: "Балкан Гриль", type: "ресторан", location: "Москва", image: "balkan.jpg", isVisited: false),
//        Restaurant(name: "Respublica", type: "ресторан", location: "ул. 1-я Тверская-Ямская, 10, Москва", image: "respublika.jpg", isVisited: false),
//        Restaurant(name: "Прага", type: "ресторанный", location: "Москва", image: "praga.jpg", isVisited: false),
//        Restaurant(name: "Sixty", type: "ресторан", location: "Пресненская наб., 12, Москва", image: "sixty.jpg", isVisited: false),
//        Restaurant(name: "Вкусные истории", type: "ресторан-кондитерская", location: "Старокачаловская ул., 5, Москва", image: "istorii.jpg", isVisited: false),
//        Restaurant(name: "Валенок", type: "ресторан", location: "Цветной б-р, 5, Москва", image: "valenok.jpg", isVisited: false),
//        Restaurant(name: "Sempre Moscow", type: "ресторан", location: "ул. Большая Дмитровка, 22, Москва", image: "sempre.jpg", isVisited: false),
//        Restaurant(name: "Карлосон", type: "ресторан", location: "Овчинниковская наб., 20 стр1, Москва", image: "karlson.jpg", isVisited: false),
//        Restaurant(name: "Бочка", type: "ресторан", location:  "1905 Года ул., 2, Москва", image: "bochka.jpg", isVisited: false)]
    
    @IBAction func close(segue: UIStoryboardSegue) {}
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = true //возвращаем свойство навигэйшен контроллеру прятаться при скролле
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.estimatedRowHeight = 85 // устанавливаем ожидаемую высоту ячейки
        tableView.rowHeight = UITableView.automaticDimension // устанавливаем автоматическое вычисление высоты
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil) // убираем имя на кнопке возвращения, чтобы оно не смещало название выбранного ресторана
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest() //создаем запрос
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true) // создаем дескриптор(фильтр) по имени по возрастанию
        fetchRequest.sortDescriptors = [sortDescriptor] // передаем фильтр запросу
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext { // создаем контекст
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            do {
                try fetchResultsController.performFetch() // выполняет запрос на выбору, пункт throws обязывает использовать try
                restaurants = fetchResultsController.fetchedObjects! // передаем в массив ресторанов то, что мы получили из запроса
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurants.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EateriesTableViewCell
        cell.thumbnailImageView.image = UIImage(data: restaurants[indexPath.row].image! as Data)//UIImage(named: restaurants[indexPath.row].image)
        cell.thumbnailImageView.layer.cornerRadius = 32.5
        cell.thumbnailImageView.clipsToBounds = true
        cell.nameLabel.text = restaurants[indexPath.row].name
        cell.locationLabel.text = restaurants[indexPath.row].location
        cell.typeLabel.text = restaurants[indexPath.row].type
//        if self.restaurantIsVisited[indexPath.row] {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        cell.accessoryType = self.restaurants[indexPath.row].isVisited ? .checkmark : .none // Если ресторан посещали, добавляем в правой части галочку
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
  
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let ac = UIAlertController(title: nil, message: "Выберете действие", preferredStyle: .actionSheet)
//        //let closser = UIAlertController(title: "Ошибка", message: "В данный момент звонок недоступен", preferredStyle: .alert)
//        let call = UIAlertAction(title: "Позвонить +7(347)111-111\(indexPath.row)", style: .default) {
//            (action: UIAlertAction) -> Void in
//            let alertC = UIAlertController(title: nil, message: "Вызов не может быть совершен", preferredStyle: .alert)
//            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alertC.addAction(ok)
//            self.present(alertC, animated: true, completion: nil)
//        }
//        let isVisitedTitle = self.restaurantIsVisited[indexPath.row] ? "Я не был здесь" : "Я был здесь"
//        let isVisited = UIAlertAction(title: isVisitedTitle, style: .default)
//        { (action: UIAlertAction) -> Void in
//            let cell = tableView.cellForRow(at: indexPath)
//            self.restaurantIsVisited[indexPath.row] = !self.restaurantIsVisited[indexPath.row]
//            cell?.accessoryType = self.restaurantIsVisited[indexPath.row] ? .checkmark : .none
//        }
//        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
//        ac.addAction(call)
//        ac.addAction(isVisited)
//        ac.addAction(cancel)
//        present(ac, animated: true, completion: nil)
//        tableView.deselectRow(at: indexPath, animated: true)
//    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? { //добавление всплывашек справа от ячейки
        let share = UITableViewRowAction(style: .default, title: "Поделиться") { (action, indexPath) in
            
            let defaultText = "Я сейчас в " + self.restaurants[indexPath.row].name!
            if let image = UIImage(data: self.restaurants[indexPath.row].image! as Data)//UIImage(named: self.restaurants[indexPath.row].image)
            {
                let activityController = UIActivityViewController(activityItems: [defaultText, image], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        }
        
        let delete = UITableViewRowAction(style: .default, title: "Удалить") { (action, indexPаth) in
            self.restaurants.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        share.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        delete.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return [delete, share]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination as! EateryDetailViewController
                dvc.restaurant = self.restaurants[indexPath.row]
            }
        }
    }
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            self.restaurantImages.remove(at: indexPath.row)
//            self.restaurantNames.remove(at: indexPath.row)
//            self.restaurantIsVisited.remove(at: indexPath.row)
//        }
//
//        tableView.deleteRows(at: [indexPath], with: .fade)
//    }
    
    
    
}
