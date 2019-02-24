//
//  FirstViewController.swift
//  alcholecalendar
//
//  Created by Kan Nakamura on 2019/02/02.
//  Copyright © 2019 Kan Nakamura. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import RealmSwift


class FirstViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance, UITableViewDelegate, UITableViewDataSource  {

    
    @IBOutlet weak var TableView: UITableView!
   
    //日付表示
    @IBOutlet weak var showdate: UILabel!
    @IBOutlet weak var showhungover: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //編集から値が入った時に、ViewControllerを更新する
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendar.reloadData()
        print("viewWillAppear")
    }
    
    //削除ボタンアウトレット
    @IBOutlet weak var deletebutton: UIButton!
    //編集ボタンアウトレット
    @IBOutlet weak var editbutton: UIButton!
    //カレンダーのアウトレット
    @IBOutlet weak var calendar: FSCalendar!
    
    //オプショナルデータ型selectedDateの定義。初期値はnil
    var selectedDate: Date?
    
    //削除ボタンのアクション作成
    @IBAction func tapDeleteButtonAction(_ sender: Any) {
        //selectedDateがnilではない場合
        if let date = selectedDate{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let drunkday = formatter.string(from: date)
            print(drunkday)
            //イベント削除
            print("データ削除")
            let realm = try! Realm()
            let events = realm.objects(Event.self).filter("date == %@", drunkday)
            print(events)
            events.forEach{(event)in
                try! realm.write(){
                    realm.delete(event)
                }
            }
            //カレンダーの更新
            calendar.reloadData()
            
            //textfieldの初期化
            showhungover.text = ""
            //テーブルビューの初期化
            KindOfDrinks = []
            TableView.reloadData()
     }
    }
    
    //編集アクション
    @IBAction func EditButton(_ sender: Any) {
        //PerformSegueの設定
        performSegue(withIdentifier: "toEditViewController",sender: nil)
    }
    
    //Segue準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toEditViewController") {
            if let date = selectedDate{
                print("編集する日\(date)")
            let EVC: EditViewController = (segue.destination as? EditViewController)!
            // ViewControllerのtextVC2にメッセージを設定
            EVC.EDITDATE = date
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    //空配列
    var KindOfDrinks = [String](){
        didSet{
            TableView.reloadData()
        }
    }
    //タップしたときの動作
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        
        //編集ボタンと削除ボタンを動作可能にする
        editbutton.isEnabled = true
        deletebutton.isEnabled = true
        
        //日程の表示
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        //タップしたDateの値取得
        let da = formatter.string(from: date)
        showdate.text = da
        
        //タップしたDateのスケジュール取得
        let realm = try! Realm()
        let result = realm.objects(Event.self).filter("date = '\(da)'")
        
        
        //全ての値を空白にする
        showhungover.text = ""
        //日付のeventにデータがあるとき
        if result.count > 0{
        //event の全てが0という場合でないとき
        for ev in result {
            //何かが0以上の場合
            if ev.beer > 0 || ev.highball > 0 || ev.wine > 0 || ev.cocktail > 0{
                //配列に代入
                if ev.beer>0{
                    
                }
                
                KindOfDrinks = [
                    String("ビール　　× \(ev.beer)杯"),
                    String("ハイボール　　× \(ev.highball)杯"),
                    String("ワイン　　× \(ev.wine)杯"),
                    String("チューハイ　　× \(ev.cocktail)杯"),
                    String("日本酒　　× \(ev.sake)合"),
                    String("焼酎　　× \(ev.shochu)杯")
                ]
                print("タップ動作の際の配列の数\(KindOfDrinks.count)")
                //その中でも二日酔いの状態の条件わけ
                if ev.hungover == true{
                    showhungover.text = "二日酔い飲み"
                    showhungover.textColor = UIColor.red
                }else if ev.lighthungover == true{
                    showhungover.text = "軽く二日酔い飲み"
                    showhungover.textColor = UIColor.orange
                }else{
                    showhungover.text = "適正飲酒"
                    showhungover.textColor = UIColor(red: 252/255, green: 220/255, blue: 33/255, alpha: 1)
                }
            }
        
        }
        print(KindOfDrinks)
        }else{
            //日付のeventにデータがないとき
            KindOfDrinks = []
            print("タップ動作の際の配列の数\(KindOfDrinks.count)")
            print(KindOfDrinks)
        }
        
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        //Realmよりデータ取得
        let realm = try! Realm()
        let drinkdays = realm.objects(Event.self).filter("beer > 0 || highball > 0 || wine > 0 || cocktail > 0")
        let lighthungoverdays = realm.objects(Event.self).filter("lighthungover == true && (beer > 0 || highball > 0 || wine > 0 || cocktail > 0)")
        let hungoverdays = realm.objects(Event.self).filter("hungover == true && (beer > 0 || highball > 0 || wine > 0 || cocktail > 0)")
        //空配列準備
        var drinkDays = [String]()
        var lighthungoverDays = [String]()
        var hungoverDays = [String]()
        
        //取得したdrinkdaysを配列に入れる
        for drinkday in drinkdays{
            drinkDays.append(drinkday.date)
        }
        //取得したlighthungoverdaysを配列に入れる
        for lighthungoverday in lighthungoverdays{
            lighthungoverDays.append(lighthungoverday.date)
        }
        //取得したhungoverdaysを配列に入れる
        for hungoverday in hungoverdays{
            hungoverDays.append(hungoverday.date)
        }
        
        // cellのデザインを変更
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let dataString = formatter.string(from: date)
        
        //色分け
        if hungoverDays.contains(dataString){
            return UIColor.red
        }else if lighthungoverDays.contains(dataString){
            return UIColor.orange
        }else if drinkDays.contains(dataString){
            return UIColor(red: 252/255, green: 220/255, blue: 33/255, alpha: 1)
        }else{
            return nil
        }
    }
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print("TableView関数の配列の数\(KindOfDrinks.count)")
        return KindOfDrinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if selectedDate != nil{
            
            cell.textLabel?.text = KindOfDrinks[indexPath.row]
            
            return cell
        }else{
            cell.textLabel?.text = ""
            return cell
        }
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
