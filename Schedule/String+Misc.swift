//
//  String+Misc.swift
//  Schedule
//
//  Created by Rafaela Galdino on 09/07/20.
//  Copyright © 2020 Rafaela Galdino. All rights reserved.
//

import Foundation

public enum StringMaskr {
    case none
    case phone

    public func mask() -> String {
        switch self {
        case .phone: return "(XX) XXXXX-XXXX"
        default: return ""
        }
    }

    public var maxLength: Int? {
        switch self {
        case .phone: return 15
        default: return nil
        }
    }
}
