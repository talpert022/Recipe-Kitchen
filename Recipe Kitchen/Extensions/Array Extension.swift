//
//  Array Extension.swift
//  Recipe Kitchen
//
//  Created by Tommy Alpert on 11/26/21.
//  Copyright © 2021 Tommy Alpert. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    func uniqued() -> Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
