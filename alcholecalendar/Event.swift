//
//  Event.swift
//  alcholecalendar
//
//  Created by Kan Nakamura on 2019/02/02.
//  Copyright © 2019 Kan Nakamura. All rights reserved.
//
import Foundation
import RealmSwift

class Event: Object {
    
    @objc dynamic var date: String = ""
    @objc dynamic var editdate: String = ""
    @objc dynamic var beer: Int = 0
    @objc dynamic var highball: Int = 0
    @objc dynamic var wine: Int = 0
    @objc dynamic var cocktail: Int = 0
    @objc dynamic var hungover: Bool = false
    
    
}
