//
//  EateriesTableViewController.swift
//  Eateries
//
//  Created by Хакан Абулов on 12/11/2018.
//  Copyright © 2018 Хакан Абулов. All rights reserved.
//
import UIKit
import CoreData

class EateriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var fetchResultsController: NSFetchedResultsController<Restaurant>! // нужен для получения данных(Хорошо работает с TableView)
    var restaurants: [Restaurant] = []
    var searchController: UISearchController! // объект, который будет заниматься поиском данных
    var filteredResultArray:[Restaurant] = [] // массив, в который будем помещать рестораные, которые соответсвуют методам поиска
    
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
    // метод фильтрующий наш массив restaurant в массив filteredResultArray
    func filterContentFor(searchText text: String) {
        filteredResultArray = restaurants.filter{ (restaurant) -> Bool in
            return (restaurant.name?.lowercased().contains(text.lowercased()))!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        searchController = UISearchController(searchResultsController: nil) // передаем nil, чтобы результаты выдавались на этом же контроллере
        searchController.searchResultsUpdater = self // назначаем контроллер, который будет обновлять результаты
        searchController.dimsBackgroundDuringPresentation = false // чтобы не затемнялся экран при поиске
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)  // цвет панели seatchBar
        searchController.searchBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) // цвет шрифта
        tableView.tableHeaderView = searchController.searchBar // в Header нашей таблицы передаем searchBar(поиск)
        definesPresentationContext = true // свойство отвечающее за то,чтобы наш searchBar не переходил на EateryDetailVC
        
        tableView.estimatedRowHeight = 85 // устанавливаем ожидаемую высоту ячейки
        tableView.rowHeight = UITableView.automaticDimension // устанавливаем автоматическое вычисление высоты
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil) // убираем имя на кнопке возвращения, чтобы оно не смещало название выбранного ресторана
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest() //создаем запрос
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true) // создаем дескриптор(фильтр) по имени по возрастанию(указание того как мы хотим видеть выходные данные)
        fetchRequest.sortDescriptors = [sortDescriptor] // передаем фильтр запросу
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext { // создаем контекст
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil) // инициализируем FetchResultController
            fetchResultsController.delegate = self // подписываемся под то, что будем реализовывать методы протокола NSFetchedResultsControllerDelegate
            do {
                try fetchResultsController.performFetch() // пытаемся получить данные, выполняет запрос на получение, пункт throws обязывает использовать try
                restaurants = fetchResultsController.fetchedObjects! // передаем в массив ресторанов то, что мы получили из запроса
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    //  как только отобразиться наш главный экран ViewDidLoad, вызывается этот метод и главный экран закроет наш PageViewController
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // вызываем PageViewController
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "pageViewController") as? PageViewController {
            present(pageViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Fetch Results Controller Delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) { //контроллер вызывается перед тем как наш TableView поменяет свой контент
        tableView.beginUpdates() // метод предупреждает TableView, что сейчас будут обновления
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        // прописали все случаи возможных изменений наших ресторанов
        //добавления
        //удаления
        //изменения
        // по дефолту обнови все
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { break }
            tableView.insertRows(at: [indexPath], with: .fade)
        case .delete:
            guard let indexPath = newIndexPath else { break }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update:
            guard let indexPath = newIndexPath else { break }
            tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            tableView.reloadData()
        }
        restaurants = controller.fetchedObjects as! [Restaurant] // обновляем массив ресторанов
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) { // предупредили TableView, что череда изменений закончилась
        tableView.endUpdates()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredResultArray.count
        } else {
            return restaurants.count
        }
    }
    
    // метод выбирающий какой массив выбирать (массив найденных или дефолтный)
    func restaurantToDesplayAt(indexPath: IndexPath) -> Restaurant{
        let restaurant: Restaurant
        // создаем условие того, чтобы когда у нас идет поиск в таблицу выводился filteredResultArray, а обычно restaurants
        if searchController.isActive && searchController.searchBar.text != "" {
            restaurant = filteredResultArray[indexPath.row]
        } else {
            restaurant = restaurants[indexPath.row]
        }
        return restaurant
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EateriesTableViewCell
        // создаем условие того, чтобы когда у нас идет поиск в таблицу выводился filteredResultArray, а обычно restaurants
        let restaurant = restaurantToDesplayAt(indexPath: indexPath)
        cell.thumbnailImageView.image = UIImage(data: restaurant.image! as Data)//UIImage(named: restaurants[indexPath.row].image)
        cell.thumbnailImageView.layer.cornerRadius = 32.5
        cell.thumbnailImageView.clipsToBounds = true
        cell.nameLabel.text = restaurant.name
        cell.locationLabel.text = restaurant.location
        cell.typeLabel.text = restaurant.type
        //        if self.restaurantIsVisited[indexPath.row] {
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }
        cell.accessoryType = restaurant.isVisited ? .checkmark : .none // Если ресторан посещали, добавляем в правой части галочку
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
        let share = UITableViewRowAction(style: .default, title: "Поделиться") { (action, indexPath) in // добавляем всплывашку "Поделиться"
            
            let defaultText = "Я сейчас в " + self.restaurants[indexPath.row].name!
            if let image = UIImage(data: self.restaurants[indexPath.row].image! as Data)//UIImage(named: self.restaurants[indexPath.row].image)
            {
                let activityController = UIActivityViewController(activityItems: [defaultText, image], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        }
        
        let delete = UITableViewRowAction(style: .default, title: "Удалить") { (action, indexPаth) in // добавляем всплывашку "Удалить"
            self.restaurants.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext { // создаем контекст
                let objectToDelete = self.fetchResultsController.object(at: indexPath) // выделяем объект для удаления
                context.delete(objectToDelete) // удаляем объект из контекста
                
                do {
                    try context.save()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
        share.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        delete.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return [delete, share]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination as! EateryDetailViewController
                dvc.restaurant = restaurantToDesplayAt(indexPath: indexPath)
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

extension EateriesTableViewController: UISearchResultsUpdating {
    // вызывается каждый раз при изменении строки запроса
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
        tableView.reloadData()
    }
}

// подписываемся на протокол, чтобы пофискить баг, когда при нажатии на поисковую строку и свайпе вниз,а затем вверх navigationBar не возвращается
extension EateriesTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            navigationController?.hidesBarsOnSwipe = false
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationController?.hidesBarsOnSwipe = true
    }
}
