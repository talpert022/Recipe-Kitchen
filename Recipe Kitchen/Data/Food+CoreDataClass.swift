//
//  Food+CoreDataClass.swift
//  
//
//  Created by Tommy Alpert on 9/6/20.
//
//

import Foundation
import CoreData


public class Food: NSManagedObject {
    
    var location : Location {
        get { return Location.init(rawValue: Int(locationEnum)) ?? .none}
        set { locationEnum = Int16(newValue.rawValue)}
    }
    
    
    
    var expirationString : String {
        if expirationDate == nil {
            return "\(daysBetween(entered: enteredDate, expire: Date())) days in"
        } else {
            let daysTilExpired = daysBetween(entered: Date(), expire: expirationDate!)
            if daysTilExpired > 4 {
                return "\(daysBetween(entered: enteredDate, expire: Date())) days in"
            }
            else if daysTilExpired <= 4 && daysTilExpired > 1 {
                return "Expires in \(daysTilExpired) days"
            } else if daysTilExpired == 1 {
                return "Expires in 1 day"
            }
            else if daysTilExpired == 0 {
                return "Expiring Today!!"
            }
            else {
                return "Expired \(abs(Int32(daysTilExpired))) days ago"
            }
        }
    }
    
    func daysBetween(entered: Date, expire: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: entered, to: expire).day!
    }
    
    var expirationStatus : expirationStatus {
        if expirationDate == nil {
            return .good
        } else {
            let daysTilExpired = daysBetween(entered: Date(), expire: expirationDate!)
            if daysTilExpired > 4 {
                return .good
            }
            if 4 >= daysTilExpired && daysTilExpired >= 0 {
                return .expiring
            }
            else {
                return .expired
            }
        }
    }
    
    var daysTilExpiration : Int? {
        if expirationDate == nil {
            return nil
        } else {
            return daysBetween(entered: Date(), expire: expirationDate!)
        }
    }
}

enum expirationStatus: Int {
    case good
    case expiring
    case expired
}


enum Location: Int {
    case none
    case fridge
    case freezer
    case dry_pantry
    case spice_rack
}

extension Location: CaseIterable {
    var label : String {
        switch self {
        case .none:
            return "All Items"
        case .fridge:
            return "Fridge"
        case .freezer:
            return "Freezer"
        case .dry_pantry:
            return "Pantry"
        case .spice_rack:
            return "Spice Rack"
        }
    }
}
