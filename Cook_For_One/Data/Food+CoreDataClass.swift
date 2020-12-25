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
            return "\(daysBetween(entered: enteredDate!, expire: Date())) days in"
        } else {
            let daysTilExpired = daysBetween(entered: Date(), expire: expirationDate!)
            if daysTilExpired > 4 {
                return "\(daysBetween(entered: enteredDate!, expire: Date())) days in"
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
        let enteredDay = entered.get(.day)
        let expireDay =  expire.get(.day)
        return expireDay - enteredDay
    }
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
                return "Dry Pantry"
            case .spice_rack:
                return "Spice Rack"
            }
        }
    }
