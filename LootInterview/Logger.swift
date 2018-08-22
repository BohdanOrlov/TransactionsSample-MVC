//
//  Logger.swift
//  GreyHands
//
//  Created by Tom Angistalis on 15/11/2016.
//  Copyright © 2016 Sourcebits. All rights reserved.
//

import Foundation

public enum LogLevel: Int {
    case verbose = 0
    case debug = 1
    case info = 2
    case warning = 3
    case error = 4
}

public protocol Loggable {
    func log(level: LogLevel, _ message: @autoclosure () -> Any)
    func log(level: LogLevel, message: @autoclosure () -> Any)
}

public extension Loggable {
    func log(level: LogLevel, _ message: @autoclosure () -> Any) {
        log(level: level, message: message)
    }

    func log(level: LogLevel, message: @autoclosure () -> Any) {
        Logger.log(level: level, message: message)
    }
}

protocol LoggerType {
    func log(level: LogLevel, message: @autoclosure () -> Any)
}

final class Logger {
    public static var logger = Logger()

    /// Overrides shared instance, useful for testing
    static func setSharedInstance(logger: Logger) {
        self.logger = logger
    }

    private init() {
        setup()
    }

    func setup() {

    }

    public static func log(level: LogLevel = .verbose, message: @autoclosure () -> Any) {
        switch level {
        case .verbose:
            print(message)
        case .debug:
            print(message)
        case .info:
            print(message)
        case .warning:
            print(message)
        case .error:

            print(message)
        }
    }

    public static func verbose(_ message: @autoclosure () -> Any) {
        Logger.log(level: .verbose, message: message)
    }

    public static func debug(_ message: @autoclosure () -> Any) {
        Logger.log(level: .debug, message: message)
    }

    public static func info(_ message: @autoclosure () -> Any) {
        Logger.log(level: .info, message: message)
    }

    public static func warning(_ message: @autoclosure () -> Any) {
        Logger.log(level: .warning, message: message)
    }

    public static func error(_ message: @escaping @autoclosure () -> Any) {
        Logger.log(level: .error, message: message)
    }

}