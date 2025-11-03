//
//  SizeType.swift
//  AppleContainerDesktop
//
//  Created by Itsuki on 2025/11/03.
//

import Foundation

enum SizeType: String, CaseIterable, Identifiable, Hashable {
    case Bytes
    case KB
    case MB
    case GB
    case TB
    case PB
    
    var id: String {
        return self.rawValue
    }
    
    var suffix: String {
        switch self {
            
        case .Bytes:
            ""
        case .KB:
            "K"
        case .MB:
            "M"
        case .GB:
            "G"
        case .TB:
            "T"
        case .PB:
            "P"
        }
    }
}
