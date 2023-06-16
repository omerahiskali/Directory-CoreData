//
//  ViewController.swift
//  CoreDataProject
//
//  Created by Ömer Faruk Küçükahıskalı on 18.01.2023.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate

class ViewController: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var kisilerListe = [Kisiler]()
    
    var kisilerAra = [Kisiler]()
    
    var aramaKontrol = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
            
        veriOku()
        
    }

    
    func veriOku(){        
        do{
            kisilerListe = try context.fetch(Kisiler.fetchRequest())
        }catch{
            print("Veri Okunurken Hata Oldu")
        }
    }
    
    func veriSil(indeks:Int){
        
        if kisilerListe.count > 0{
            let silinecekKisi = kisilerListe[indeks]
            
            context.delete(silinecekKisi)
            
            appDelegate.saveContext()
        }else{
            print("db Boş")
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if aramaKontrol == true{
            return kisilerAra.count
        }else{
            return kisilerListe.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if aramaKontrol == true{
            let gelenKisi = kisilerAra[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "hucre", for: indexPath) as! TableViewCell
            
            cell.etiket.text = gelenKisi.kisi_ad
            
            cell.selectionStyle = .none

            return cell
        }else{
            let gelenKisi = kisilerListe[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "hucre", for: indexPath) as! TableViewCell
            
            cell.etiket.text = gelenKisi.kisi_ad
            
            cell.selectionStyle = .none

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let silAction = UIContextualAction(style: .destructive, title: "Sil"){
            (contextualAction, view, boolValue) in
            
            self.veriSil(indeks: indexPath.row)
            self.viewDidLoad()
            self.tableView.reloadData()
        }
        
        let duzenleAction = UIContextualAction(style: .normal, title: "Düzenle"){
            (contextualAction, view, boolValue) in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let gidilecekVC = storyboard.instantiateViewController(withIdentifier: "duzenle") as! KisiDuzenleVC
            
            let gidenIndeks = indexPath.row
            gidilecekVC.gelenIndeks = gidenIndeks
            
            self.navigationController?.pushViewController(gidilecekVC, animated: false)
        }
        
        return UISwipeActionsConfiguration(actions: [silAction,duzenleAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gidilecekVC = storyboard.instantiateViewController(withIdentifier: "bilgiler") as! KisiBilgilerVC
        
        let gidenIndeks = indexPath.row
        gidilecekVC.gelenIndeks = gidenIndeks
        
        self.present(gidilecekVC, animated: true, completion: nil)
    }

}

extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            aramaKontrol = false
        }else{
            aramaKontrol = true
            kisilerAra = kisilerListe.filter({$0.kisi_ad!.lowercased().contains(searchText.lowercased())})
        }
        
        tableView.reloadData()
    }
}
