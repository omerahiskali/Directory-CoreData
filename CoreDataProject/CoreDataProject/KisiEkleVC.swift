//
//  KisiEkleVC.swift
//  CoreDataProject
//
//  Created by Ömer Faruk Küçükahıskalı on 18.01.2023.
//

import UIKit

class KisiEkleVC: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext

    @IBOutlet weak var kisiAdTF: UITextField!
    
    @IBOutlet weak var kisiTelTF: UITextField!
    
    @IBOutlet weak var kisiEpostaTF: UITextField!
    
    @IBOutlet weak var kisiDtTF: UITextField!
    
    var datePicker:UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kisiTelTF.delegate = self
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.preferredDatePickerStyle = .wheels
        
        kisiDtTF.inputView = datePicker
        
        datePicker?.addTarget(self, action: #selector(self.showDate(datePicker:)), for: .valueChanged)
        
        let dokunmaAlgilama = UITapGestureRecognizer(target: self, action: #selector(self.dokunAlgilaMetod))
        view.addGestureRecognizer(dokunmaAlgilama)
    }
    

    func veriEkle(ad:String,tel:String,eposta:String,dt:String){
        let kisi = Kisiler(context: context)
        
        kisi.kisi_ad = ad
        kisi.kisi_tel = tel
        kisi.kisi_eposta = eposta
        kisi.kisi_dt = dt
        
        appDelegate.saveContext()
    }
    
    func numberFormatter(mask:String,tel:String)->String{
        let number = tel.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result:String = ""
        var indeks = number.startIndex
        
        for character in mask where indeks < number.endIndex{
            if character == "X"{
                result.append(number[indeks])
                indeks = number.index(after: indeks)
            }else{
                result.append(character)
            }
        }
        return result
    }
    
    @objc func showDate(datePicker:UIDatePicker){ // çalışacak fonksiyon
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy" // tarih formatını ayarlama (internette formatlar var)
        let alinanTarih = dateFormatter.string(from: datePicker.date) // date'i stringe çevirdik
        
        kisiDtTF.text = alinanTarih // textfielda yazdır
    }
    
    @objc func dokunAlgilaMetod(){
        view.endEditing(true)
    }
    
    @IBAction func kaydetButon(_ sender: Any) {
        
        
        if kisiAdTF.text == "" || kisiTelTF.text == ""{
            let alertController = UIAlertController(title: "Hata", message: "İsim veya Telefon Numarası Boş Bırakılamaz", preferredStyle: .alert)
            let alertTamam = UIAlertAction(title: "Tamam", style: .cancel)
            alertController.addAction(alertTamam)
            self.present(alertController,animated: true)
        }else{
            if kisiTelTF.text?.count != 18{
                let alertController = UIAlertController(title: "Hata", message: "Telefon Numarası Eksik", preferredStyle: .alert)
                let alertTamam = UIAlertAction(title: "Tamam", style: .cancel)
                alertController.addAction(alertTamam)
                self.present(alertController,animated: true)
            }else{
                if let ad = kisiAdTF.text, let tel = kisiTelTF.text, let eposta = kisiEpostaTF.text, let dt = kisiDtTF.text{
                    veriEkle(ad: ad, tel: tel, eposta: eposta, dt: dt)
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let KisilerVC = storyboard.instantiateViewController(withIdentifier: "kisiler")
                    self.navigationController?.pushViewController(KisilerVC, animated: false)
                }else{
                    print("Kaydet Kısmı Hata")
                }
            }
                
        }
        
 
        
    }
    
    
    
}

extension KisiEkleVC:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = kisiTelTF.text else {return false}
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        kisiTelTF.text = numberFormatter(mask: "+XX (XXX) XXX-XXXX", tel: newString)
        return false
    }
}
