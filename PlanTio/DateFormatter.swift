//
//  DateFormatter.swift
//  PlanTio
//
//  Created by Lucas Santos on 29/04/24.
//

import Foundation


let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
}()
