//
//  MMLocationItem.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2022/1/21.
//  Copyright © 2022 Mumu. All rights reserved.
//

import Foundation
import CoreLocation

class MMLocationItem {
    var lat: Double = 0
    var lon: Double = 0
    
    var city: String = ""
    
    private let originalLocation: CLLocation
    
    var geoCoder: CLGeocoder?
    
    var hadReversed: Bool = false
    
    public var name: String?// eg. “西北旺东路233号”

    public var thoroughfare: String?  // “西北旺东路”

    public var subThoroughfare: String?  // ”233号“

    public var locality: String?  // city, 北京市

    public var subLocality: String?  // 海淀区

    public var administrativeArea: String?  // state, eg. CA

    public var subAdministrativeArea: String?  // county, eg. Santa Clara

    public var postalCode: String?  // zip code, eg. 95014

    public var isoCountryCode: String?  // eg. US。CN

    public var country: String?  // ”中国“
    
//    open var areasOfInterest: [String] // [西北旺]
    
    init(location: CLLocation) {
        originalLocation = location
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
    }
    
    func reverseLocation(complete: @escaping (Bool, MMLocationItem?) -> Void) {
        guard !hadReversed else {
            complete(true, self)
            return
        }
        geoCoder = CLGeocoder()
        geoCoder?.reverseGeocodeLocation(originalLocation) {[weak self] placeMarks, error in
            guard let self = self else {
                complete(false, nil)
                return
            }
            if let marks = placeMarks {
                self.handleMarks(marks: marks, complete: complete)
            } else {
                mm_printLog(error)
                complete(false, self)
            }
        }
    }
    
    func handleMarks(marks: [CLPlacemark], complete: @escaping (Bool, MMLocationItem) -> Void) {
        geoCoder = nil
        guard let mark = marks.first else {
            complete(false, self)
            return
        }
        hadReversed = true
        name = mark.name
        thoroughfare = mark.thoroughfare
        subThoroughfare = mark.subThoroughfare
        locality = mark.locality
        subLocality = mark.subLocality
        administrativeArea = mark.administrativeArea
        subAdministrativeArea = mark.subAdministrativeArea
        postalCode = mark.postalCode
        isoCountryCode = mark.isoCountryCode
        country = mark.country
        //FormattedAddressLines = mark.addressDictionary["FormattedAddressLines"]
        //中国北京市海淀区西北旺东路233号
        mm_printLog("反地理编码结束")
        complete(true, self)
    }
}
