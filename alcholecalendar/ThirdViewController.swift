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

    @IBOutlet weak var CupOfHungover: UILabel!
    @IBAction func button(_ sender: Any) {
        let realm = try! Realm()
        let results = realm.objects(Event.self).filter("hungover == true")
        
        var sum = 0
        for res in results{
            let alchole = res.beer + res.highball + res.wine + res.cocktail
            sum += alchole
        }
        CupOfHungover.text = "あなたは\(sum / results.count)杯飲むと二日酔いになるでしょう"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
