//
//  ClassExtensions.swift
//  playground
//
//  Created by Jelle Alten on 10-11-16.
//  Copyright © 2016 Wonder Workshop. All rights reserved.
//

import Foundation

public extension NSObject {
    public class var nameOfClass: String {
        return String(describing: self)
    }
}
