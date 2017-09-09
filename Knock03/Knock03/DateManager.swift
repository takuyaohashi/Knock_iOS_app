//
//  DateManager.swift
//  Knock03
//
//  Created by Takuya OHASHI on 2017/07/27.
//  Copyright © 2017年 Takuya OHASHI. All rights reserved.
//

import Foundation

class DateManager {
    let cal = Calendar(identifier: .japanese)
    
    static var today : String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM"

        return formatter.string(from: now)
    }

    func firstDayOfMonth() -> Date? {
        let components = cal.dateComponents([.year, .month], from: Date())
        return cal.date(from: components)
    }

    func numOfWeek(_ date: Date) {
        return range(of: .weekOfMonth, in: .month, for: date)?.count
    }
}
