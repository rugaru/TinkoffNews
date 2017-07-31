//
//  DateExtension.swift
//  TinkoffNews
//
//  Created by Alina Usmanova on 30.07.17.
//  Copyright © 2017 Alina Usmanova. All rights reserved.
//

import Foundation

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: self)
    }
}
