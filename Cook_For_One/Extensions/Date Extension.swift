//
//  Date Extension.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 12/20/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//

import Foundation

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
