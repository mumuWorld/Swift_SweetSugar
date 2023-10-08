//
//  SomeAnyTest.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/9/21.
//  Copyright © 2023 Mumu. All rights reserved.
//

import Foundation

// https://swiftsenpai.com/swift/understanding-some-and-any/

fileprivate protocol Vehicle: Equatable {

    var name: String { get }

    associatedtype FuelType
    func fillGasTank(with fuel: FuelType)
}

fileprivate struct Car: Vehicle {

    let name = "car"

    func fillGasTank(with fuel: Gasoline) {
        print("Fill \(name) with \(fuel.name)")
    }
}

fileprivate struct Bus: Vehicle {

    let name = "bus"

    func fillGasTank(with fuel: Diesel) {
        print("Fill \(name) with \(fuel.name)")
    }
}

fileprivate struct Gasoline {
    let name = "gasoline"
}

fileprivate struct Diesel {
    let name = "diesel"
}


fileprivate class testSomeAny {
    // The following 3 function signatures are identical.

    func wash<T: Vehicle>(_ vehicle: T) {
        // Wash the given vehicle
    }

    func wash2<T>(_ vehicle: T) where T: Vehicle {
        // Wash the given vehicle
    }

    func wash3(_ vehicle: some Vehicle)  {
        // Wash the given vehicle
    }
    
    
    func testSome() {
        // 关于some 关键字在 Swift 5.1 中引入，它与协议一起使用，创建了一个不透明的类型，表示符合特定协议的东西，
        // 当在函数的参数位置使用时，它意味着函数接受符合特定协议的具体类型。
        // 不透明类型的基础类型必须为变量的作用域固定。
        //1 禁止赋值实现相同 Vehicle 协议的 Bus对象
        var myCar: some Vehicle = Car()
//        myCar = Bus() // 🔴 Compile error: Cannot assign value of type 'Bus' to type 'some Vehicle'
        
        //2 禁止赋值 为实现相同协议的， 相同对象
        var myCar_car: some Vehicle = Car()
//        myCar_car = Car() // 🔴 Compile error: Cannot assign value of type 'Car' to type 'some Vehicle'

        var myCar1: some Vehicle = Car()
        var myCar2: some Vehicle = Car()
//        myCar2 = myCar1 // 🔴 Compile error: Cannot assign value of type 'some Vehicle' (type of 'myCar1') to type 'some Vehicle' (type of 'myCar2')

        //3 数组中使用
        // ✅ No compile error
        let vehicles: [some Vehicle] = [
            Car(),
            Car(),
            Car(),
        ]

        // 🔴 Compile error: Cannot convert value of type 'Bus' to expected element type 'Car'
//        let vehicles: [some Vehicle] = [
//            Car(),
//            Car(),
//            Bus(),
//        ]
        
        //4 函数的返回类型
        // ✅ No compile error
        func createSomeVehicle() -> some Vehicle {
            return Car()
        }


        // 🔴 Compile error: Function declares an opaque return type 'some Vehicle', but the return statements in its body do not have matching underlying types
//        func createSomeVehicle(isPublicTransport: Bool) -> some Vehicle {
//            if isPublicTransport {
//                return Bus()
//            } else {
//                return Car()
//            }
//        }
        
        
        // any关键字 any  关键字是在 Swift 5.6 中引入的，它用于创建存在类型，在 Swift 5.6 中，创建存在类型时  any  关键字不是强制的，但在 Swift 5.7 中，如果不这样做，就会得到编译错误。
//        let myCar: Vehicle = Car() // 🔴 Compile error in Swift 5.7: Use of protocol 'Vehicle' as a type must be written 'any Vehicle'
        let myCar_2: any Vehicle = Car() // ✅ No compile error in Swift 5.7
        
        // 🔴 Compile error in Swift 5.7: Use of protocol 'Vehicle' as a type must be written 'any Vehicle'
//        func wash(_ vehicle: Vehicle)  {
//            // Wash the given vehicle
//        }

        // ✅ No compile error in Swift 5.7
        func wash(_ vehicle: any Vehicle)  {
            // Wash the given vehicle
        }
        
        // ✅ No compile error when changing the underlying data type
        var myCar_any: any Vehicle = Car()
        myCar_any = Bus()
        myCar_any = Car()

        // ✅ No compile error when returning different kind of concrete type
        func createAnyVehicle(isPublicTransport: Bool) -> any Vehicle {
            if isPublicTransport {
                return Bus()
            } else {
                return Car()
            }
        }
        
        // 🔴 Compile error in Swift 5.6: protocol 'Vehicle' can only be used as a generic constraint because it has Self or associated type requirements
        // ✅ No compile error in Swift 5.7
        let vehicles_any: [any Vehicle] = [
            Car(),
            Car(),
            Bus(),
        ]
        
        // 不能用 == 操作两个存在类型(existential type)
        let myCar1_any = createAnyVehicle(isPublicTransport: false)
        let myCar2_any = createAnyVehicle(isPublicTransport: false)
//        let isSameVehicle = myCar1_any == myCar2_any // 🔴 Compile error: Binary operator '==' cannot be applied to two 'any Vehicle' operands


        let myCar1_any_1 = createSomeVehicle()
        let myCar2_any_2 = createSomeVehicle()
        let isSameVehicle = myCar1_any_1 == myCar2_any_2 // ✅ No compile error
        
        
    }
}
