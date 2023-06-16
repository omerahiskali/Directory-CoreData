//
//  KisiBilgilerVC.swift
//  CoreDataProject
//
//  Created by Ömer Faruk Küçükahıskalı on 18.01.2023.
//

import UIKit

class KisiBilgilerVC: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext

    @IBOutlet weak var kisiAdEtiket: UILabel!
    
    @IBOutlet weak var kisiTelEtiket: UILabel!
    
    @IBOutlet weak var kisiEpEtiket: UILabel!
    
    @IBOutlet weak var kisiDtEtiket: UILabel!
    
    var gelenIndeks:Int?
    
    var kisilerListe = [Kisiler]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do{
            kisilerListe = try context.fetch(Kisiler.fetchRequest())
        }catch{
            print("Veri Okunurken Hata Oldu")
        }
        
        let gelenKisi = kisilerListe[gelenIndeks!]
        
        kisiAdEtiket.text =  gelenKisi.kisi_ad
        kisiTelEtiket.text = gelenKisi.kisi_tel
        kisiEpEtiket.text = gelenKisi.kisi_eposta
        kisiDtEtiket.text = gelenKisi.kisi_dt
    }
    
}
