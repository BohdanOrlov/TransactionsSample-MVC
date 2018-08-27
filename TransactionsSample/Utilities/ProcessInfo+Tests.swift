//
//  ProcessInfo+Tests.swift
//  Xapo
//
//  Created by Thomas Angistalis on 23/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import Foundation

// Extend ProcessInfo to handle launch environment keys
extension ProcessInfo {
    
    public enum LaunchArtguments: String {
        case uiTesting = "UITesting"
        case unitTesting = "isRunningUnitTests"
    }
    
    var isRunningUITests: Bool {
        return self.environment[LaunchArtguments.uiTesting.rawValue] == "YES"
    }
    
    var isRunningTests: Bool {
        return self.environment[LaunchArtguments.unitTesting.rawValue] == "YES"
    }
}
