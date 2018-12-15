//
//  NewEateryTableViewController.swift
//  Eateries
//
//  Created by Хакан Абулов on 16/11/2018.
//  Copyright © 2018 Хакан Абулов. All rights reserved.
//

import UIKit

class NewEateryTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // подписываемся под два протокола, чтобы стать делегатом и реализовать метод imagePickerController
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    

    

    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if nameTextField.text == "" || adressTextField.text == "" || typeTextField.text == "" || phoneTextField.text == "" {
            let alert = UIAlertController(title: "Не все поля заполнены", message: "Заполните все поля", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext // инициализируем(добираемся до) контекст(а)
            {
                let restaurant = Restaurant(context: context) // создали экземляр ресторана помещенный в контекст
                restaurant.name = nameTextField.text
                restaurant.location = adressTextField.text
                restaurant.type = typeTextField.text
                restaurant.phone = phoneTextField.text
                if let image = imageView.image {
                    restaurant.image = image.pngData() // преобразовываем PNG в Binary Data
                // сохранили изменения в контексте, но еще не сохранили сам контекст
                }
                do {
                    // пытаемся сохранить контекст
                    try context.save()
                    print("Сохранение удалось")
                } catch let error as NSError {
                    print("Не удалось сохранить данный \(error) \(error.userInfo)")
                }
            }
            
            
            performSegue(withIdentifier: "unwindSegueFromNewEatery", sender: self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect.zero) // убирает деления под ячейкам(где их нет)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage // используем editedImage, чтобы передовалось разрешенное к редактированию(imagePicker.allowsEditing = true) фото
        imageView.contentMode = .scaleAspectFill // устанавливаем режим отображения
        imageView.clipsToBounds = true // разрешаем обрезать все, что выходит за рамки
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            // создаем alert
            let alertController = UIAlertController(title: "Источник фотографии", message: nil, preferredStyle: .actionSheet)
            // создаем действия
            let cameraAction = UIAlertAction(title: "Камера", style: .default) { (action) in
                self.chooseImagePickerAction(source: .camera) // вызываем как камеру (.SourceType = .camera)
            }
            
            let photoLibAction = UIAlertAction(title: "Библиотека", style:  .default) { (action) in
                self.chooseImagePickerAction(source: .photoLibrary) // вызываем как библиотеку (.SourceType = .photoLibrary)
            }
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil)
            // добавляем действия
            alertController.addAction(cameraAction)
            alertController.addAction(photoLibAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil) //  отображааем alert
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func chooseImagePickerAction(source: UIImagePickerController.SourceType) {
        if (UIImagePickerController.isSourceTypeAvailable(source)) { // проверяем доступен ли нам соотвествующий PickerController(камера или библиотека)
            let imagePicker = UIImagePickerController() //создаем ImagePicker
            imagePicker.delegate = self
            imagePicker.allowsEditing = true // позволяем редактировать выбранную фотографию(обрезать и т.д.)
            imagePicker.sourceType = source // в этой строке попадаем либо на камеру, либо на библиотеку
            self.present(imagePicker, animated: true, completion: nil) // отображаем  PickerController
            
        }
    }

        /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
