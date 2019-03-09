//
//  ThirdViewController.swift
//  alcholecalendar
//
//  Created by Kan Nakamura on 2019/02/02.
//  Copyright © 2019 Kan Nakamura. All rights reserved.
//

import UIKit
import RealmSwift
import Charts

extension Calendar{
    func startOfWeek(for date:Date) -> Date {
        let comps = self.dateComponents([.weekOfYear, .yearForWeekOfYear], from: date)
        return self.date(from: comps)!
    }
}

class ThirdViewController: UIViewController {

    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var chart: CombinedChartView!
    @IBOutlet weak var CupOfLightHungover: UILabel!
    @IBOutlet weak var CupOfHungover: UILabel!
    
    //線グラフチャート
    var lineDataSet: LineChartDataSet!

     //軽い二日酔いの杯数集計
    func GetCupOfLightHungover() -> String?{
        let realm = try! Realm()
        let results = realm.objects(Event.self).filter("lighthungover == true && (beer > 0 || highball > 0 || wine > 0 || cocktail > 0 || sake > 0 || shochu > 0)")
        print("軽い二日酔いResultの数\(results.count)")
        print("軽い二日酔いResult\(results)")
        if results.count > 1{
            var sum = 0
            for res in results{
                let alchole = res.beer + res.highball + res.wine + res.cocktail + res.sake + res.shochu
                sum += alchole
            }
            return "\(sum / results.count)杯"
        }else{
            return "二日酔い\nデータ不足"
        }
    }
    
    //二日酔いの杯数集計
    func GetCupOfHungover() -> String?{
        let realm = try! Realm()
        let results = realm.objects(Event.self).filter("hungover == true && (beer > 0 || highball > 0 || wine > 0 || cocktail > 0 || sake > 0 || shochu > 0)")
        print("二日酔いResultの数\(results.count)")
        print("二日酔いResult\(results)")
        if results.count > 1{
        var sum = 0
        for res in results{
            let alchole = res.beer + res.highball + res.wine + res.cocktail + res.sake + res.shochu
            sum += alchole
        }
        return "\(sum / results.count)杯"
        }else{
            return "二日酔い\nデータ不足"
        }
    }
    
    //編集から値が入った時に、ViewControllerを更新する
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //二日酔いの値を入れる
        CupOfLightHungover.text = GetCupOfLightHungover()
        CupOfHungover.text = GetCupOfHungover()
        
        //combinedDataを結合グラフに設定する
        let combinedData = CombinedChartData()
        //結合グラフに線グラフのデータ読み出し
        //generateLineData()は以下で表示している関数
        combinedData.lineData = generateLineData()
        
        //chartのデータにcombinedDataを挿入する
        chart.data = combinedData
        
        //chartを出力
        self.view.addSubview(chart)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("ViewController/viewDidAppear/画面が表示された直後")
        print("土曜日\(SATURDAY)")
        if MONDAY > 150 || TUESDAY > 150 || WEDNESDAY > 150 || THURSDAY > 150 || FRIDAY > 150 || SATURDAY >  150{
            comment.text = "１週間に飲めるアルコール量150g\n超えたにゃ! 今週はもう控えめにゃ!!"
            comment.textColor = UIColor.red
        }else{
            comment.text = "１週間でアルコールを150g以上\n飲んでたら飲みすぎにゃ"
            comment.textColor = UIColor.black
        }

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    var MONDAY:Double = 0
    var TUESDAY:Double = 0
    var WEDNESDAY:Double = 0
    var THURSDAY:Double = 0
    var FRIDAY:Double = 0
    var SATURDAY:Double = 0
    func generateLineData() -> LineChartData
    {
        //で今週の取得
        let date = Date()
        let calendar = Calendar.current
        //今週初めを取得
        let Sunday = calendar.startOfWeek(for: date)
        //それぞれ次の日を取得
        let Monday = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: Sunday))
        let Tuesday = calendar.date(byAdding: .day, value: 2, to: calendar.startOfDay(for: Sunday))
        let Wednesday = calendar.date(byAdding: .day, value: 3, to: calendar.startOfDay(for: Sunday))
        let Thursday = calendar.date(byAdding: .day, value: 4, to: calendar.startOfDay(for: Sunday))
        let Friday = calendar.date(byAdding: .day, value: 5, to: calendar.startOfDay(for: Sunday))
        let Saturday = calendar.date(byAdding: .day, value: 6, to: calendar.startOfDay(for: Sunday))
        
        //データフォーマットでデータを変える
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let sunday = formatter.string(from: Sunday)
        let monday = formatter.string(from: Monday!)
        let tuesday = formatter.string(from: Tuesday!)
        let wednesday = formatter.string(from: Wednesday!)
        let thursday = formatter.string(from: Thursday!)
        let friday = formatter.string(from: Friday!)
        let saturday = formatter.string(from: Saturday!)
        
        print("thisweekday\(sunday)")
        
        //Realmよりデータの取得
        let realm = try! Realm()
        let EventOfSunday = realm.objects(Event.self).filter("date = '\(sunday)'")
        //空のインスタンスに曜日ごとのアルコール量を入れていく
        var sundayammount:Double! = 0
        for eventofsunday in EventOfSunday{
            sundayammount = Double(eventofsunday.beer * 350) * 0.05
            print(sundayammount)
        }
        let EventOfMonday = realm.objects(Event.self).filter("date = '\(monday)'")
        //空のインスタンスに曜日ごとのアルコール量を入れていく
        var mondayammount:Double! = 0
        for eventofmonday in EventOfMonday{
            mondayammount = Double(eventofmonday.beer * 350) * 0.05 + Double(eventofmonday.highball * 350) * 0.07 + Double(eventofmonday.wine * 200) * 0.14 + Double(eventofmonday.cocktail * 350) * 0.05 + Double(eventofmonday.sake * 180) * 0.15 + Double(eventofmonday.shochu * 90) * 0.20
        }
        let EventOfTuesday = realm.objects(Event.self).filter("date = '\(tuesday)'")
        //空のインスタンスに曜日ごとのアルコール量を入れていく
        var tuesdayammount:Double! = 0
        for eventoftuesday in EventOfTuesday{
            tuesdayammount = Double(eventoftuesday.beer * 350) * 0.05 + Double(eventoftuesday.highball * 350) * 0.07 + Double(eventoftuesday.wine * 200) * 0.14 + Double(eventoftuesday.cocktail * 350) * 0.05 + Double(eventoftuesday.sake * 180) * 0.15 + Double(eventoftuesday.shochu * 90) * 0.20
        }
        let EventOfWednesday = realm.objects(Event.self).filter("date = '\(wednesday)'")
        //空のインスタンスに曜日ごとのアルコール量を入れていく
        var wednesdayammount:Double! = 0
        for eventofwednesday in EventOfWednesday{
            wednesdayammount = Double(eventofwednesday.beer * 350) * 0.05 + Double(eventofwednesday.highball * 350) * 0.07 + Double(eventofwednesday.wine * 200) * 0.14 + Double(eventofwednesday.cocktail * 350) * 0.05 + Double(eventofwednesday.sake * 180) * 0.15 + Double(eventofwednesday.shochu * 90) * 0.20
        }
        let EventOfThursday = realm.objects(Event.self).filter("date = '\(thursday)'")
        //空のインスタンスに曜日ごとのアルコール量を入れていく
        var thursdayammount:Double! = 0
        for eventofthursday in EventOfThursday{
            thursdayammount = Double(eventofthursday.beer * 350) * 0.05 + Double(eventofthursday.highball * 350) * 0.07 + Double(eventofthursday.wine * 200) * 0.14 + Double(eventofthursday.cocktail * 350) * 0.05 + Double(eventofthursday.sake * 180) * 0.15 + Double(eventofthursday.shochu * 90) * 0.20
        }
        let EventOfFriday = realm.objects(Event.self).filter("date = '\(friday)'")
        //空のインスタンスに曜日ごとのアルコール量を入れていく
        var fridayammount:Double! = 0
        for eventoffriday in EventOfFriday{
            fridayammount = Double(eventoffriday.beer * 350) * 0.05 + Double(eventoffriday.highball * 350) * 0.07 + Double(eventoffriday.wine * 200) * 0.14 + Double(eventoffriday.cocktail * 350) * 0.05 + Double(eventoffriday.sake * 180) * 0.15 + Double(eventoffriday.shochu * 90) * 0.20
        }
        let EventOfSaturday = realm.objects(Event.self).filter("date = '\(saturday)'")
        //空のインスタンスに曜日ごとのアルコール量を入れていく
        var saturdayammount:Double! = 0
        for eventofsaturday in EventOfSaturday{
            saturdayammount = Double(eventofsaturday.beer * 350) * 0.05 + Double(eventofsaturday.highball * 350) * 0.07 + Double(eventofsaturday.wine * 200) * 0.14 + Double(eventofsaturday.cocktail * 350) * 0.05 + Double(eventofsaturday.sake * 180) * 0.15 + Double(eventofsaturday.shochu * 90) * 0.20
        }
        //それぞれの曜日の累計を算出
        MONDAY = sundayammount + mondayammount
        TUESDAY = MONDAY + tuesdayammount
        WEDNESDAY = TUESDAY + wednesdayammount
        THURSDAY = WEDNESDAY + thursdayammount
        FRIDAY = THURSDAY + fridayammount
        SATURDAY = FRIDAY + saturdayammount
        
        //リストを作り、グラフのデータを追加する方法（GitHubにあったCombinedChartViewとかMPAndroidChartのwikiを参考にしている
        //データを入れていく、多重配列ではないため別々にデータは追加していく
        let values: [Double] = [sundayammount, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY]
        
        //DataSetを行うために必要なEntryの変数を作る　データによって入れるデータが違うため複数のentriesが必要になる？
        var dataentries: [ChartDataEntry] = Array()
        for (i, value) in values.enumerated(){
            let entries = ChartDataEntry(x: Double(i), y: value) // X軸データは、0,1,2,...
            dataentries.append(entries)
        }
        
        //x軸ラベルを下にする
        chart.xAxis.labelPosition = .bottom
        // 横に赤いボーダーラインを描く
        let ll = ChartLimitLine(limit: 150)
        chart.leftAxis.addLimitLine(ll)
        //右のy軸を消す
        chart.rightAxis.enabled = false
        
        //データを送るためのDataSet変数をリストで作る
        var linedata:  [LineChartDataSet] = Array()
        
        //リストにデータを入れるためにデータを成形している
        //データの数値と名前を決める
        lineDataSet = LineChartDataSet(values: dataentries, label: "アルコール累計(g)")
        lineDataSet.drawIconsEnabled = false
        //グラフの線の色とマルの色を変えている
        lineDataSet.colors = [NSUIColor(red: 57/255, green: 181/255, blue: 74/255, alpha: 1)]
        lineDataSet.circleColors = [NSUIColor(red: 57/255, green: 181/255, blue: 74/255, alpha: 1)]
        //上で作ったデータをリストにappendで入れる
        linedata.append(lineDataSet)
        // X軸のラベルを設定
        let xaxis = XAxis()
        xaxis.valueFormatter = BarChartFormatter()
        chart.xAxis.valueFormatter = xaxis.valueFormatter
        
        //データを返す。
        return LineChartData(dataSets: linedata)
    }
    
    
    //x軸のラベル変更
    public class BarChartFormatter: NSObject, IAxisValueFormatter{
        // x軸のラベル
        var months: [String]! = ["日", "月", "火", "水", "木", "金", "土"]
        
        // デリゲート。TableViewのcellForRowAtで、indexで渡されたセルをレンダリングするのに似てる。
        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            // 0 -> Jan, 1 -> Feb...
            return months[Int(value)]
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
