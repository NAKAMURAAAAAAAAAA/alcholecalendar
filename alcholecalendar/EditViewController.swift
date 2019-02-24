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
    //データ取得
    @IBOutlet weak var editdate: UIDatePicker!
    @IBOutlet weak var CupOfBeer: UITextField!
    @IBOutlet weak var CupOfHighball: UITextField!
    @IBOutlet weak var CupOfWine: UITextField!
    @IBOutlet weak var CupOfCocktail: UITextField!
    @IBOutlet weak var CupOfSake: UITextField!
    @IBOutlet weak var CupOfShochu: UITextField!
    
    //状態ボタン
    @IBOutlet weak var GoodDrinkButton: UIButton!
    @IBOutlet weak var LightHungoverButton: UIButton!
    @IBOutlet weak var HungoverButton: UIButton!
    
    let doneimage:UIImage = UIImage(named:"yes")!
    let undoneimage:UIImage = UIImage(named:"no")!
    var status:Int = 0
    
    //状態のボタンアクション
    @IBAction func TapGoodDrinkButton(_ sender: Any) {
        GoodDrinkButton.setImage(doneimage, for: .normal)
        LightHungoverButton.setImage(undoneimage, for: .normal)
        HungoverButton.setImage(undoneimage, for: .normal)
        status = 1
        print(status)
    }
    @IBAction func TapLightHungoverButton(_ sender: Any) {
        GoodDrinkButton.setImage(undoneimage, for: .normal)
        LightHungoverButton.setImage(doneimage, for: .normal)
        HungoverButton.setImage(undoneimage, for: .normal)
        status = 2
        print(status)
    }
    @IBAction func TapHungoverButton(_ sender: Any) {
        GoodDrinkButton.setImage(undoneimage, for: .normal)
        LightHungoverButton.setImage(undoneimage, for: .normal)
        HungoverButton.setImage(doneimage, for: .normal)
        status = 3
        print(status)
    }
    
    //sefue用意
    var EDITDATE:Date?
    //textfieldを数字にする
    override func viewDidLoad() {
        super.viewDidLoad()
        editdate.date = EDITDATE!
        // Do any additional setup after loading the view, typically from a nib.
        let ts = [CupOfBeer, CupOfHighball, CupOfWine, CupOfCocktail, CupOfSake, CupOfShochu]
        for t in ts{
            t?.keyboardType = UIKeyboardType.numberPad
        }
        //Doneボタン
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.commitButtonTapped))
        kbToolBar.items = [spacer, commitButton]
        for t in ts{
            t?.inputAccessoryView = kbToolBar
        }
    }
    
    @objc func commitButtonTapped() {
        self.view.endEditing(true)
    }
    //ここまでtextfieldを数字にする
    
    //状態の場合分け
    var WhichIsLightHungover = false
    var WhichIsHungover = false
    //「追加ボタン」のアクション
    @IBAction func Done(_ sender: Any) {
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
        let sakenumber = CupOfSake.text!
        let sakenum = Int(sakenumber) ?? 0
        let shochunumber = CupOfShochu.text!
        let shochunum = Int(shochunumber) ?? 0
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
        
        //状態ボタンの場合分け
        if status == 2{
            WhichIsLightHungover = true
        }else if status == 3{
            WhichIsHungover = true
        }
        
        //Realmデータ書き込み
        try! realm.write(){
            //日付表示の内容とスケジュール入力の内容が書き込まれる。
            let Events = [Event(value: ["date": drunkday, "beer": beernum, "highball": highballnum, "wine": winenum, "cocktail": cocktailnum, "sake": sakenum, "shochu": shochunum, "hungover": WhichIsHungover, "lighthungover": WhichIsLightHungover])]
            realm.add(Events)
            print("データ書き込み中")
            print("編集されたEvents登録\(Events)")
        }
        print("データ書き込み完了")
        
    }
    
    //タブバー表示のため
    @IBAction func tapAdd(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func goback(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
