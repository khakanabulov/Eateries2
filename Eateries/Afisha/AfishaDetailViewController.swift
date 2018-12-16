//
//  EateryDetailViewController.swift
//  Eateries
//
//  Created by Хакан Абулов on 15/11/2018.
//  Copyright © 2018 Хакан Абулов. All rights reserved.
//

import UIKit

class AfishaDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
            print(self.favoriteButton.imageView?.image)
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
        }
        
    }
    
    var restaurantA: RestaurantAfisha?
    
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
