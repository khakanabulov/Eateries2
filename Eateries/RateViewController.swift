//
//  RateViewController.swift
//  Eateries
//
//  Created by Хакан Абулов on 16/11/2018.
//  Copyright © 2018 Хакан Абулов. All rights reserved.
//

import UIKit
import CoreData

class RateViewController: UIViewController {

    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var badButton: UIButton!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var brilliantButton: UIButton!
    var restRating: String?
    var restaurant: Restaurant?
    var restaurats: [Restaurant] = []
    var fetchResultsController: NSFetchedResultsController<Restaurant>!
    
    @IBAction func rateRestaurant(sender: UIButton) {
        switch sender.tag {
        case 0: restRating = "bad"
        case 1: restRating = "good"
        case 2: restRating = "brilliant"
        default: break
        }

        //restaurant!.rate = restRating
//        let context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.persistentContainer.viewContext
//        //context.delete(restaurant!)
//        let restarauntRefreshed = NSEntityDescription.insertNewObject(forEntityName: "Restaurant", into: context)
//        restarauntRefreshed.setValue(restaurant!.name, forKey: "name")
//        restarauntRefreshed.setValue(restaurant!.location, forKey: "location")
//        restarauntRefreshed.setValue(restaurant!.type, forKey: "type")
//        restarauntRefreshed.setValue(restaurant!.isVisited, forKey: "isVisited")
//        restarauntRefreshed.setValue(restaurant!.rate, forKey: "rate")
//        restarauntRefreshed.setValue(restaurant!.image, forKey: "image")
//        do {
//            // пытаемся сохранить контекст
//            try context.save()
//            print("Сохранение удалось")
//        } catch let error as NSError {
//            print("Не удалось сохранить данный \(error) \(error.userInfo)")
//        }
        
//        let context = (UIApplication.shared.delegate as! AppDelegate).coreDataStack.persistentContainer.viewContext
//        let entityDescription = NSEntityDescription.entity(forEntityName: "Restaurant", in: context)
//        //var sortDescription: [NSSortDescriptor]?
//        //let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
//        let request = NSFetchRequest<Restaurant>()
//        request.entity = entityDescription
//        let predicate = NSPredicate(format: "name == %@", restaurant!.name!)
//        request.predicate = predicate
//        fetchResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
////        request.sortDescriptors = [nameSortDescriptor]
//        print("do it")
//        do {
//            let objects = try context.execute(request)
//            try fetchResultsController.performFetch()
//            print(objects)
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
        
        
        
        performSegue(withIdentifier: "unwindSegueToDVC", sender: sender)
    }
    override func viewDidAppear(_ animated: Bool) {
//        UIView.animate(withDuration: 0.4) {
//            self.ratingStackView.transform = CGAffineTransform(scaleX: 1, y: 1) // увеличивает маштаб стэка до реального размера(до этого его попросту не было)(чтобы происходила анимация появления)
//        }
        let buttonArray = [badButton, goodButton, brilliantButton]
        for(index, button) in buttonArray.enumerated() {
            let delay = Double(index) * 0.2
            UIView.animate(withDuration: 0.6, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { //curveEaseInOut - для плавного замедления в начале и в конце
                button?.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        ratingStackView.transform = CGAffineTransform(scaleX: 0, y: 0) // при загрузке у нас не будет отображаться стэк(т.к. масштаб нулевой), чтобы происходила анимация появления
        
        
        badButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        goodButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        brilliantButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds // присваиваем границы блюр эффекта = границам контроллера
        blurEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]  //чтобы блюр эффект оставался при повороте жкрана
        self.view.insertSubview(blurEffectView, at: 1)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
