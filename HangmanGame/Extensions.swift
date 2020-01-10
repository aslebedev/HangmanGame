//
//  Extensions.swift
//  HangmanGame
//
//  Created by alexander on 10.01.2020.
//  Copyright © 2020 alexander. All rights reserved.
//

import Foundation

//  MARK: Replace symbol in specific position
extension String {
    mutating func replace(_ index: Int, _ newChar: Character) {
        var chars = Array(self)
        chars[index] = newChar
        self = String(chars)
    }
}
