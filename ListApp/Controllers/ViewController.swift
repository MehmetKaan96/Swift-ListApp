//
//  ViewController.swift
//  ListApp
//
//  Created by Mehmet on 26.07.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController{
    
    var alertController = UIAlertController()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var data = [NSManagedObject]()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        fetch()
    }
    @IBAction func addBarButton(_ sender: UIBarButtonItem){
        presentAddAlert()
    }
    
    func presentAddAlert(){
        
        presentAlert(title: "Yeni Eleman Ekle", message: nil, preferredStyle: UIAlertController.Style.alert, defaultButtonTitle: "Ekle", cancelButtonTitle: "Vazgeç", isTextFieldAvailable: true) { [self] _ in
            let textfield = self.alertController.textFields?.first?.text
            if textfield != ""{
                
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                
                let managedObjectContext = appDelegate?.persistentContainer.viewContext
                
                let entity = NSEntityDescription.entity(forEntityName: "ListItem",
                                                        in: managedObjectContext!)
                
                let listItem = NSManagedObject(entity: entity!,
                                               insertInto: managedObjectContext)
                
                listItem.setValue(textfield, forKey: "title")
                
                try? managedObjectContext?.save()
                
                self.fetch()//fetch data from core data
            }else{
                self.presentWarningAlert()
            }
        }
    }
    
    func presentWarningAlert(){
        let alertController = UIAlertController(title: "Hata", message: "Listeye boş eleman ekleyemezsin!", preferredStyle: UIAlertController.Style.alert)
        present(alertController, animated: true)
        
        let okayButton = UIAlertAction(title: "Tamam", style: .cancel, handler: nil)
        alertController.addAction(okayButton)
        
        presentAlert(title: "Hata", message: "Listeye boş eleman ekleyemezsiniz.", preferredStyle: UIAlertController.Style.alert, cancelButtonTitle: "Tamam")
    }
    
    func presentAlert(title: String,
                      message: String?,
                      preferredStyle: UIAlertController.Style = .alert,
                      defaultButtonTitle: String? = nil,
                      cancelButtonTitle: String?,
                      isTextFieldAvailable:Bool = false,
                      defaultButtonHandler:((UIAlertAction)-> Void)? = nil
    ){
        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: preferredStyle)
        
        if (isTextFieldAvailable){
            alertController.addTextField()
        }
        
        if defaultButtonTitle != nil{
            let defaultButton = UIAlertAction(title: defaultButtonTitle, style: .default, handler: defaultButtonHandler)
            alertController.addAction(defaultButton)
        }
        
        let okayButton = UIAlertAction(title: cancelButtonTitle, style: .cancel)
        alertController.addAction(okayButton)
        
        
        
        present(alertController, animated: true)
    }
    
    @IBAction func didDeleteButtonTapped(_ sender: UIBarButtonItem){
        
        presentAlert(title: "Uyarı",
                     message: "Listedeki tüm ürünler silinecektir",
                     preferredStyle: UIAlertController.Style.alert,
                     defaultButtonTitle: "Tamam",
                     cancelButtonTitle: "Vazgeç",
                     isTextFieldAvailable: false) { _ in
            //self.data.removeAll()
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            
            let managedObjectContext = appDelegate?.persistentContainer.viewContext
            
            self.deleteData()
            
            self.tableView.reloadData()
        }
    }
    
    func deleteData(){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedObjectContext = appDelegate?.persistentContainer.viewContext
        
        for object in data{
            managedObjectContext?.delete(object)
        }
        
        try! managedObjectContext?.save()
        
    }
    
    func fetch(){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedObjectContext = appDelegate?.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ListItem")
        
        data = try! managedObjectContext!.fetch(fetchRequest)
        
        tableView.reloadData()
    }
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell",for: indexPath)
        let listItem = data[indexPath.row]
        
        cell.textLabel?.text = listItem.value(forKey: "title") as? String
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: UIContextualAction.Style.normal,
                                              title: "Sil") { [self] _, _, _ in
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            
            let managedObjectContext = appDelegate?.persistentContainer.viewContext
            
            managedObjectContext?.delete(self.data[indexPath.row])
            try? managedObjectContext?.save()
            self.fetch()
        }
        deleteAction.backgroundColor = UIColor.systemRed
        
        let editAction = UIContextualAction(style: .normal, title: "Düzenle") { _, _, _ in
            self.presentAlert(title: "Düzenle", message: nil, preferredStyle: UIAlertController.Style.alert, defaultButtonTitle: "Ekle", cancelButtonTitle: "Vazgeç", isTextFieldAvailable: true) { _ in
                let textfield = self.alertController.textFields?.first?.text
                if textfield != ""{
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    
                    let managedObjectContext = appDelegate?.persistentContainer.viewContext
                    
                    self.data[indexPath.row].setValue(textfield, forKey: "title")
                    
                    if managedObjectContext!.hasChanges{
                        try? managedObjectContext?.save()
                    }
                    self.tableView.reloadData()
                }else{
                    self.presentWarningAlert()
                }
            }
        }
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction,editAction])
        
        return config
    }
    
}
