//
//  Extensions.swift
//  PlanTio
//
//  Created by Ricardo Almeida Venieris on 10/05/24.
//

import Foundation
import UIKit

extension Date{
    static func getDaysUntil(date endDate: Date, startDate: Date, weekdays:[Int]) -> [Date]{
        var currentDate = startDate
        var dates: [Date] = []
        
        while currentDate < endDate{
            let weekday = Calendar.current.component(.weekday, from: currentDate)
            if weekdays.contains(weekday) {
                dates.append(currentDate)
            }
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return dates
    }
    
    static func weekTimes(for date: Date, weekdays:[Int] = [1,2,3,4,5,6,7], adding timeInterval: TimeInterval = 5)->[Date] {
         
        Date.getDaysUntil(date: Calendar.current.date(byAdding: .weekday, value: 1, to: Date())!,
                          startDate: date,
                          weekdays: [1,2,3,4,5,6,7])
        .map {$0.addingTimeInterval(timeInterval)}
    }
}

extension UIImage {
    var data:Data? { self.jpegData(compressionQuality: 0.8) }
}
