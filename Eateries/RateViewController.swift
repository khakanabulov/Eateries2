//
//  RateViewController.swift
//  Eateries
//
//  Created by Хакан Абулов on 16/11/2018.
//  Copyright © 2018 Хакан Абулов. All rights reserved.
//

import UIKit

class RateViewController: UIViewController {

    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var badButton: UIButton!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var brilliantButton: UIButton!
    var restRating: String?
    
    @IBAction func rateRestaurant(sender: UIButton) {
        switch sender.tag {
        case 0: restRating = "bad"
        case 1: restRating = "good"
        case 2: restRating = "brilliant"
        default: break
        }
        
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
