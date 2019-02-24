//
//  ThirdViewController.swift
//  alcholecalendar
//
//  Created by Kan Nakamura on 2019/02/02.
//  Copyright © 2019 Kan Nakamura. All rights reserved.
//

import UIKit
import RealmSwift

class ThirdViewController: UIViewController {

    @IBOutlet weak var Average: UILabel!
    @IBOutlet weak var CupOfLightHungover: UILabel!
    @IBOutlet weak var CupOfHungover: UILabel!
    
    //平均算出
    func GetCupOfAverage() -> String?{
        let realm = try! Realm()
        let results = realm.objects(Event.self).filter("beer > 0 || highball > 0 || wine > 0 || cocktail > 0 || sake > 0 || shochu > 0")
        if results.count > 1{
            var sum = 0
            for res in results{
                let alchole = res.beer + res.highball + res.wine + res.cocktail
                sum += alchole
            }
            return "\(sum / results.count)杯"
        }else{
            return "データ不足"
        }
    }
    
    
     //軽い二日酔いの杯数集計
    func GetCupOfLightHungover() -> String?{
        let realm = try! Realm()
        let results = realm.objects(Event.self).filter("lighthungover == true && (beer > 0 || highball > 0 || wine > 0 || cocktail > 0 || sake > 0 || shochu > 0)")
        if results.count > 1{
            var sum = 0
            for res in results{
                let alchole = res.beer + res.highball + res.wine + res.cocktail
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
        if results.count > 1{
        var sum = 0
        for res in results{
            let alchole = res.beer + res.highball + res.wine + res.cocktail
            sum += alchole
        }
        return "\(sum / results.count)杯"
        }else{
            return "二日酔い\nデータ不足"
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Average.text = GetCupOfAverage()
        CupOfLightHungover.text = GetCupOfLightHungover()
        CupOfHungover.text = GetCupOfHungover()
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
