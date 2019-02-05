//
//  SecondViewController.swift
//  alcholecalendar
//
//  Created by Kan Nakamura on 2019/02/02.
//  Copyright © 2019 Kan Nakamura. All rights reserved.
//

import UIKit
import RealmSwift

class SecondViewController: UIViewController{

    @IBOutlet weak var warning: UILabel!
    @IBOutlet weak var day: UIDatePicker!
    @IBOutlet weak var CupOfBeer: UITextField!
    @IBOutlet weak var CupOfHighball: UITextField!
    @IBOutlet weak var CupOfWine: UITextField!
    @IBOutlet weak var CupOfCocktail: UITextField!
    var whichisswitch = false
    @IBAction func HungoverSwitch(_ sender: UISwitch) {
        if sender.isOn == true {
            whichisswitch = true
            print(sender.isOn)
        } else {
            whichisswitch = false
        }
    }
    
    //textfieldを数字にする
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let ts = [CupOfBeer, CupOfHighball, CupOfWine, CupOfCocktail]
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
    
    @IBAction func Done(_ sender: Any) {
        if CupOfBeer.text != "" || CupOfHighball.text != "" || CupOfWine.text != "" || CupOfCocktail.text != ""{
        //UIDatePickerからDateを取得する
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let drunkday = formatter.string(from: day.date)
        
        //データ型の変換
        let beernumber = CupOfBeer.text
        let beernum = Int(beernumber!)!
        let highballnumber = CupOfHighball.text
        let highballnum = Int(highballnumber!)!
        let winenumber = CupOfWine.text
        let winenum = Int(winenumber!)!
        let cocktailnumber = CupOfCocktail.text
        let cocktailnum = Int(cocktailnumber!)!
        
        //データ書き込み
        print("データ書き込み開始")
        let realm = try! Realm()
        try! realm.write{
            //日付表示の内容とスケジュール入力の内容が書き込まれる。
            let Events = [Event(value: ["date": drunkday, "beer": beernum, "highball": highballnum, "wine": winenum, "cocktail": cocktailnum, "hungover": whichisswitch])]
            realm.add(Events)
            print("データ書き込み中")
        }
        print("データ書き込み完了")
        
    }else{
    warning.text = "数字を入力してください"
    }
        }

}

