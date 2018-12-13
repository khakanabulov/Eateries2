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
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    var restaurantA: RestaurantAfisha?
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        guard let svc = segue.source as? RateViewController else {return}
        guard let rating = svc.restRating else {return}
        rateButton.setImage(UIImage(named: rating), for: .normal)
    }
    
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
        
        let buttons = [rateButton, mapButton]
        for button in buttons {
            guard let button = button else {break}
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
        }
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
                cell.keyLabel.text = "Тип"
                cell.valueLabel.text = restaurantA!.type
            case 2:
                cell.keyLabel.text = "Адрес"
                cell.valueLabel.text = restaurantA!.location
            case 3:
                cell.keyLabel.text = "Я там был?"
                cell.valueLabel.text = "Нет"
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
        if segue.identifier == "afishaSegueToRate" {
            if (restaurantA != nil) {
                let dvc = segue.destination as! RateViewController
                dvc.restaurantA = self.restaurantA
            }
        }
    }
}
