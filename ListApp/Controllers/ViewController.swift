//
//  ViewController.swift
//  ListApp
//
//  Created by Mehmet on 26.07.2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var alertController = UIAlertController()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var data = [String]()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell",for: indexPath)
        
        cell.textLabel?.text = data[indexPath.row]
        
        return cell
        
    }
    
    @IBAction func addBarButton(_ sender: UIBarButtonItem){
        presentAddAlert()
    }
    
    func presentAddAlert(){
        
        presentAlert(title: "Yeni Eleman Ekle", message: nil, preferredStyle: UIAlertController.Style.alert, defaultButtonTitle: "Ekle", cancelButtonTitle: "Vazgeç", isTextFieldAvailable: true) { _ in
            let textfield = self.alertController.textFields?.first?.text
            if textfield != ""{
                self.data.append((textfield)!)
                self.tableView.reloadData()
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
            self.data.removeAll()
            self.tableView.reloadData()
        }
    }
    
}

