//
//  String+Extension.swift
//  
//
//  Created by Andriy Gordiyenko on 8/5/23.
//

import Foundation

extension String {
    func toAppealReleaseInt() -> Int {
        var sum = 0
        let components = self.components(separatedBy: ".")
        for i in 0..<components.count {
            if let num = Int(components[i]) {
                let power = 9 - (i * 3)
                let resultDec = pow(10, power)
                let resultNSDec = NSDecimalNumber(decimal: resultDec)
                let resultInt = Int(truncating: resultNSDec)
                sum += num * resultInt
            }
        }
        return sum
    }
}
