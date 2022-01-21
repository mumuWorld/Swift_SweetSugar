//
//  MMLocationItem.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2022/1/21.
//  Copyright © 2022 Mumu. All rights reserved.
//

import Foundation
import CoreLocation

struct MMLocationItem {
    var lat: Double = 0
    var lon: Double = 0
    
    var city: String = ""
    
    let originalLocation: CLLocation
    
    init(location: CLLocation) {
        originalLocation = location
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
    }
}
