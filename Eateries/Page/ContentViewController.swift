//
//  ContentViewController.swift
//  Eateries
//
//  Created by Хакан Абулов on 20/11/2018.
//  Copyright © 2018 Хакан Абулов. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subheaderLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageButton: UIButton!
    
    @IBAction func pageButtonPressed(_ sender: UIButton) {
        switch index {
        case 0:
            let pageVC = parent as! PageViewController // добираемя до нашего PageVC через свойство parent, чтобы вызвать следующий ContentVC
            pageVC.nextVC(AtIndex: index) // вызываем следующий ContentVC
        case 1:
            // сохраняем данные о том, что пользователь уже видел пояснение
            let userDefaults = UserDefaults.standard //получили доступ к хранилищу, можем хранить конкретные значения для конкретных ключей
            userDefaults.set(true, forKey: "wasIntroWatch")
            userDefaults.synchronize() // пишем, чтобы наши данные точно записались
            dismiss(animated: true, completion: nil) // заставляем наш ContentVC исчезнуть
        default:
            break;
        }
    }
    
    var header = ""
    var subheader = ""
    var imageFile = ""
    var index = 0 // будет индексом для PageViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageButton.layer.cornerRadius = 15
        pageButton.clipsToBounds = true
        pageButton.layer.borderWidth = 2
        pageButton.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        pageButton.layer.borderColor = (#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)).cgColor
        
        switch index {
        case 0:
            pageButton.setTitle("Дальше", for: .normal)
        case 1:
            pageButton.setTitle("Открыть", for: .normal)
        default:
            break
        }
        headerLabel.text = header
        subheaderLabel.text = subheader
        imageView.image = UIImage(named: imageFile)
        pageControl.numberOfPages = 2
        pageControl.currentPage = index
    }
    
    
    
}
