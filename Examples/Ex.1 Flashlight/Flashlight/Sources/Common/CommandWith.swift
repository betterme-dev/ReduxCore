//
//  Command.swift
//  Flashlight
//
//  Created by Maksym Husar  on 06.08.2021.
//

import Foundation

/// Command is a developer friendly wrapper around a closure
/// Every command always have Void result type, which do it less composable, but also more focused
public final class CommandWith<T> {
    // Block of `context` defined variables. Allows Command to be debugged
    public let id: String
    private let file: StaticString
    private let function: StaticString
    private let line: Int
    private let column: Int
    private let action: (T) -> Void // underlying closure
    
    public init(
        id: String = UUID().uuidString,
        file: StaticString = #file,
        function: StaticString = #function,
        line: Int = #line,
        column: Int = #column,
        action: @escaping (T) -> Void
    ) {
        self.id = id
        self.file = file
        self.function = function
        self.line = line
        self.column = column
        self.action = action
    }
    
    public func perform(with value: T) {
        action(value)
    }
    
    /// Placeholder for do nothing command
    public static var nop: CommandWith<T> {
        CommandWith<T>(id: "nop") { _ in }
    }
    
    /// Support for Xcode quick look feature.
    @objc
    public func debugQuickLookObject() -> AnyObject? {
        """
            type: \(String(describing: type(of: self)))
            id: \(id)
            file: \(file)
            function: \(function)
            line: \(line)
            """ as NSString
    }
}

/// Less code = less errors
public typealias Command = CommandWith<Void>

/// Also pure simplification
public extension CommandWith where T == Void {
    func perform() {
        perform(with: ())
    }
}

/// Allows commands to be compared and stored in sets and dicts.
/// Uses `ObjectIdentifier` to distinguish between commands
extension CommandWith: Hashable {
    public static func == (left: CommandWith, right: CommandWith) -> Bool {
        left.id == right.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public extension CommandWith {
    /// Allows to pin some value to some command
    /// Creates command with id  = UUID().uuidString
    func bind(to value: T) -> Command {
        bind(to: value, id: UUID().uuidString)
    }
    
    // Splitted in 2 functions(not 1 with a default value of id) to have a possibility to use pipes
    func bind(to value: T, id: String) -> Command {
        Command(id: id) { [action] in action(value) }
    }
}

public extension CommandWith {
    /// Creates command with id  = UUID().uuidString
    func map<U>(transform: @escaping (U) -> T) -> CommandWith<U> {
        map(transform: transform, id: UUID().uuidString)
    }
    
    /// Splitted in 2 functions(not 1 with a default value of id) to have a possibility to use pipes
    func map<U>(transform: @escaping (U) -> T, id: String) -> CommandWith<U> {
        CommandWith<U>(id: id) { [action] u in action(transform(u)) }
    }
}

public extension CommandWith {
    /// Returns a new command which performs an action on a given queue asynchronously.
    func dispatched(on queue: DispatchQueue) -> CommandWith {
        CommandWith { [action] value in
            queue.async {
                action(value)
            }
        }
    }
    
    /// Returns a new command which performs an action
    /// synchronously if the *perform* method is called on the main thread, or
    /// asynchronously if the *perform* method is called not on the main thread.
    func dispatchedOnMain() -> CommandWith {
        CommandWith { [action] value in
            if Thread.isMainThread {
                action(value)
            } else {
                DispatchQueue.main.async {
                    action(value)
                }
            }
        }
    }
}

public extension CommandWith {
    /// Creates a new command which performs 2 commands: current command at first and *another* command, passed as parameter.
    func then(_ another: CommandWith, id: String) -> CommandWith {
        CommandWith(id: id) { [action, another = another.action] value in
            action(value)
            another(value)
        }
    }
    
    /// Splitted into 2 functions (not 1 with a default value of id) to have a possibility to use **pipes**
    func then(_ another: CommandWith) -> CommandWith {
        then(another, id: UUID().uuidString)
    }
}

extension CommandWith: Codable {
    public convenience init(from decoder: Decoder) throws {
        self.init { _ in }
    }
    
    public func encode(to encoder: Encoder) throws {}
}
