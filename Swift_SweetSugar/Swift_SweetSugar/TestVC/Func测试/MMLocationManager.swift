//
//  MMLocationManager.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2022/1/21.
//  Copyright © 2022 Mumu. All rights reserved.
//

import Foundation
import CoreLocation

class MMLocationManager: NSObject {
    
    enum Status {
        case waiting
        case checkAuthorization
        case locationing
    }
    
    enum InvokeType {
        case onceLocation
        case updateLocation
        case requestAuthorization
    }
    
    enum ResultType {
        case noAuthor
        case unable
        case success
        case failed
    }
    
    static let shared: MMLocationManager = MMLocationManager()
    
    private var status: Status = .waiting
    
    var invokeType: InvokeType = .onceLocation
    
    var completionQueue: [(_ type: ResultType, _ item: MMLocationItem?) -> Void] = []
    
    var curLocation: [MMLocationItem] = []
    
    private lazy var manager: CLLocationManager = {
        let item = CLLocationManager()
        item.delegate = self
        return item
    }()
    
    func startOnceLocation(callBack: @escaping (_ type: ResultType, _ item: MMLocationItem?) -> Void) {
        invokeType = .onceLocation
        completionQueue.append(callBack)
        guard status == .waiting else { return }
        _startLocation()
    }
    
    func _startLocation() {
        guard requestAuthorization(), status != .locationing else { return }
        status = .locationing
        if invokeType == .onceLocation {
            mm_printLog("开始定位")
            manager.requestLocation()
        }
    }
    
    @discardableResult
    func requestAuthorization() -> Bool {
        if manager.mm_locationEnable {
            return true
        } else if manager.mm_authorStatus == .notDetermined {
            guard status != .checkAuthorization else { return false }
            status = .checkAuthorization
            manager.requestWhenInUseAuthorization()
            return false
        } else if manager.mm_authorStatus == .denied { //拒绝
            callFinished(type: .noAuthor)
            return false
        } else if manager.mm_authorStatus == .restricted { //受限制,非用户操作
            callFinished(type: .unable)
            return false
        }
        return false
    }
    
    func callFinished(type: ResultType) {
        let location = curLocation.last
        let tmpBack = completionQueue
        completionQueue.removeAll()
        DispatchQueue.main.async {
            tmpBack.forEach { complete in
                complete(type, location)
            }
            self.status = .waiting
        }
    }
}

extension CLLocationManager {
    var mm_authorStatus: CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return authorizationStatus
        } else {
            return CLLocationManager.authorizationStatus()
        }
    }
    
    var mm_locationEnable: Bool {
        return mm_authorStatus == .authorizedWhenInUse || mm_authorStatus == .authorizedAlways
    }
}

extension MMLocationManager: CLLocationManagerDelegate {
    /// iOS 14之前
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        _startLocation()
    }
    
    /// iOS 14以后，首次申请会立即调用
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        mm_printLog("权限改变")
        _startLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        callFinished(type: .failed)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        mm_printLog(locations)
        let item = MMLocationItem(location: locations[0])
        curLocation.append(item)
        callFinished(type: .success)
    }
}
