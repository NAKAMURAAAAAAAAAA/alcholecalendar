//
//  EditViewController.swift
//  alcholecalendar
//
//  Created by Kan Nakamura on 2019/02/23.
//  Copyright © 2019 Kan Nakamura. All rights reserved.
//

import UIKit
import RealmSwift

class EditViewController: UIViewController {


    @IBOutlet weak var CupOfBeer: UITextField!
    @IBOutlet weak var CupOfHighball: UITextField!
    @IBOutlet weak var CupOfWine: UITextField!
    @IBOutlet weak var CupOfCocktail: UITextField!
    @IBOutlet weak var editdate: UIDatePicker!
    @IBAction func add(_ sender: Any) {
        //UIDatePickerからDateを取得する
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let drunkday = formatter.string(from: editdate.date)
        
        //データ型の変換
        let beernumber = CupOfBeer.text!
        let beernum = Int(beernumber) ?? 0
        let highballnumber = CupOfHighball.text!
        let highballnum = Int(highballnumber) ?? 0
        let winenumber = CupOfWine.text!
        let winenum = Int(winenumber) ?? 0
        let cocktailnumber = CupOfCocktail.text!
        let cocktailnum = Int(cocktailnumber) ?? 0
        print(drunkday)
        
        //既存のdrunkdayのデータを削除する
        print("データ書き込み開始")
        let realm = try! Realm()
        let events = realm.objects(Event.self).filter("date == %@", drunkday)
        events.forEach{(event)in
            try! realm.write(){
                realm.delete(event)
            }
        }
        
        //Realmデータ書き込み
        try! realm.write(){
            //日付表示の内容とスケジュール入力の内容が書き込まれる。
            let Events = [Event(value: ["date": drunkday, "beer": beernum, "highball": highballnum, "wine": winenum, "cocktail": cocktailnum])]
            realm.add(Events)
            print("データ書き込み中")
            print(Events)
        }
        print("データ書き込み完了")
        
    }
        
        
    
    var EDITDATE:Date?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editdate.date = EDITDATE!
        // Do any additional setup after loading the view.
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
