//
//  DateHelper.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 04/05/2026.
//
import Foundation

class DateHelper {
    
    static func getTodayString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    private static func getMonthOffset(for sport: String) -> Int {
        switch sport.lowercased() {
        case "football":
            return 1
        case "basketball":
            return 3
        case "tennis", "cricket":
            return 12
        default:
            return 1
        }
    }
    
    static func getPastDateString(for sport: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        
        let offset = getMonthOffset(for: sport)
        
        let pastDate = Calendar.current.date(byAdding: .month, value: -offset, to: Date()) ?? Date()
        return formatter.string(from: pastDate)
    }
    
    static func getFutureDateString(for sport: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        
        let offset = getMonthOffset(for: sport)
        
        let futureDate = Calendar.current.date(byAdding: .month, value: offset, to: Date()) ?? Date()
        return formatter.string(from: futureDate)
    }
}
