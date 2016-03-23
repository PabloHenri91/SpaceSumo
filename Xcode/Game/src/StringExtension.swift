//
//  StringExtension.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 3/21/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//


extension String {
    
    /// Truncates the string to length number of characters and
    /// appends optional trailing string if longer
    func truncate(length: Int, trailing: String? = nil) -> String {
        if self.characters.count > length {
            
            return self.substringToIndex(self.startIndex.advancedBy(length)) + (trailing ?? "")
            
        } else {
            return self
        }
    }
}
