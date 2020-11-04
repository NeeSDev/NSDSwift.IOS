//
//  ExtensionProtocol.swift
//  Swift.IOS.Example
//
//  Created by NeeSDev Macbook Pro on 2019/9/20.
//  Copyright © 2019 NeeSDev. All rights reserved.
//

//MARK:- =========================== NSD 命名空间（伪） ===========================
/// A proxy which hosts reactive extensions of `Base`.
public struct NeeSDevExtension<ExtendedType> {
    /// The `Base` instance the extensions would be invoked with.
    public private(set) var type: ExtendedType
    
    /// Construct a proxy
    ///
    /// - parameters:
    ///   - base: The object to be proxied.
    public init(_ type: ExtendedType) {
        self.type = type
    }
}

public protocol NeeSDevExtended {
    /// Type being extended.
    associatedtype ExtendedType

    /// Static Alamofire extension point.
    static var nsd: NeeSDevExtension<ExtendedType>.Type { get set }
    /// Instance Alamofire extension point.
    var nsd: NeeSDevExtension<ExtendedType> { get set }
}

public extension NeeSDevExtended {
    /// A proxy which hosts reactive extensions for `self`.
    var nsd: NeeSDevExtension<Self> {
        get { NeeSDevExtension(self) }
        set {}
    }
    
    /// A proxy which hosts static reactive extensions for the type of `self`.
    static var nsd: NeeSDevExtension<Self>.Type {
        get { NeeSDevExtension<Self>.self }
        set {}
    }
}

