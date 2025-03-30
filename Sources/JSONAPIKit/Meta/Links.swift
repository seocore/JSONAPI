//
//  Links.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/24/18.
//

/// A Links structure should contain nothing but `JSONAPIKit.Link` properties.
public protocol Links: Codable, Equatable {}

/// Use NoLinks where no links should belong to a JSON API component
public struct NoLinks: Links, CustomStringConvertible {
    public static var none: NoLinks { return NoLinks() }
    public init() {}
    
    public var description: String { return "No Links" }
}

public protocol JSONAPIURL: Codable, Equatable {}

public struct Link<URL: JSONAPIKit.JSONAPIURL, Meta: JSONAPIKit.Meta>: Equatable, Codable {
    public let url: URL
    public let meta: Meta
    
    public init(url: URL, meta: Meta) {
        self.url = url
        self.meta = meta
    }
}

extension Link where Meta == NoMetadata {
    public init(url: URL) {
        self.init(url: url, meta: .none)
    }
}

public extension Link {
    private enum CodingKeys: String, CodingKey {
        case href
        case meta
    }
    
    init(from decoder: Decoder) throws {
        guard Meta.self == NoMetadata.self,
            let noMeta = NoMetadata() as? Meta else {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                meta = try container.decode(Meta.self, forKey: .meta)
                url = try container.decode(URL.self, forKey: .href)
                return
        }
        let container = try decoder.singleValueContainer()
        url = try container.decode(URL.self)
        meta = noMeta
    }
    
    func encode(to encoder: Encoder) throws {
        guard Meta.self == NoMetadata.self else {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(url, forKey: .href)
            try container.encode(meta, forKey: .meta)
            return
        }
        var container = encoder.singleValueContainer()
        
        try container.encode(url)
    }
}
