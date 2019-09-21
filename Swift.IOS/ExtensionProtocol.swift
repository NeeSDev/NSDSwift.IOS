//
//  ExtensionProtocol.swift
//  Swift.IOS.Example
//
//  Created by NeeSDev Macbook Pro on 2019/9/20.
//  Copyright © 2019 NeeSDev. All rights reserved.
//
import UIKit

//MARK:- =========================== NSD 命名空间（伪） ===========================
/// A proxy which hosts reactive extensions of `Base`.
public class NSD<Base> {
    /// The `Base` instance the extensions would be invoked with.
    public let baseObj: Base
    
    /// Construct a proxy
    ///
    /// - parameters:
    ///   - base: The object to be proxied.
    public init(_ value: Base) {
        self.baseObj = value
    }
}

public protocol HDWExtensionsProvider {}

extension HDWExtensionsProvider {
    /// A proxy which hosts reactive extensions for `self`.
    public var nsd: NSD<Self> {
        return NSD(self)
    }
    
    /// A proxy which hosts static reactive extensions for the type of `self`.
    public static var nsd: NSD<Self>.Type {
        return NSD<Self>.self
    }
}

extension NSObject: HDWExtensionsProvider {}

//MARK:- =========================== enum 拓展协议 ===========================
protocol EnumerateValues {
    static var values: [Self] {get}
}



