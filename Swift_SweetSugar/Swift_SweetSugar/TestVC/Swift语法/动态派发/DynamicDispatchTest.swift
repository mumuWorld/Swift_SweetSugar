//
//  DynamicDispatchTest.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/9/21.
//  Copyright © 2023 Mumu. All rights reserved.
//

import Foundation

fileprivate struct Gasoline: Fuel {
    
    let name = "gasoline"
    
    static func purchase() -> Gasoline {
        print("Purchase gasoline from gas station.")
        return Gasoline()
    }
}

fileprivate struct Diesel: Fuel {
    
    let name = "diesel"
    
    static func purchase() -> Diesel {
        print("Purchase diesel from gas station.")
        return Diesel()
    }
}
fileprivate protocol Fuel {
   
    // Constrain `FuelType` to always equal to the type that conforms to the `Fuel` protocol
    associatedtype FuelType where FuelType == Self

    static func purchase() -> FuelType
}

fileprivate protocol Vehicle {

    associatedtype FuelType: Fuel
    
    var name: String { get }

    func startEngin()
    func fillGasTank(with fuel: FuelType)
}

fileprivate struct Car: Vehicle {

    let name: String

    func startEngin() {
        print("\(name) enjin started!")
    }

    func fillGasTank(with fuel: Gasoline) {
        print("Fill \(name) with \(fuel.name)")
    }
}

fileprivate struct Bus: Vehicle {

    let name: String

    func startEngin() {
        print("\(name) enjin started!")
    }

    func fillGasTank(with fuel: Diesel) {
        print("Fill \(name) with \(fuel.name)")
    }

}

class DynamicDispatchTest {
    func test1() {
        // Heterogeneous array with `Car` and `Bus` elements
        // 🔴 Compile error: Protocol ‘Vehicle’ can only be used as a generic constraint because it has Self or associated type requirements
        let vehicles: [any Vehicle] = [
            Car(name: "Car_1"),
            Car(name: "Car_2"),
            Bus(name: "Bus_1"),
            Car(name: "Car_3"),
        ]

        func startAllEngin(for vehicles: [any Vehicle]) {
            for vehicle in vehicles {
                vehicle.startEngin()
            }
        }

        // Execution
        startAllEngin(for: vehicles)
        
        func fillAllGasTank(for vehicles: [any Vehicle]) {

            for vehicle in vehicles {
                // Pass in `any Vehicle` to convert it to `some Vehicle`
                fillGasTank(for: vehicle)
            }
        }

        // Create a function that accept `some Vehicle` (opaque type)
        func fillGasTank(for vehicle: some Vehicle) {

            let fuel = type(of: vehicle).FuelType.purchase()
            vehicle.fillGasTank(with: fuel)
        }
        
//        func fillAllGasTank(for vehicles: [any Vehicle]) {
//
//            for vehicle in vehicles {
//
//                // Get the instance of `Fuel` concrete type based on the vehicle's fuel type
//                let fuel = type(of: vehicle).FuelType.purchase()
//                // 🤔 What to pass in here?
//                vehicle.fillGasTank(with: fuel)
//            }
//        }
    }
}
