//
//  SparseEncoder.swift
//  
//
//  Created by Mathew Polzin on 8/4/19.
//

public class SparseFieldEncoder<SparseKey: CodingKey & Equatable>: Encoder {
    private let wrappedEncoder: Encoder
    private let allowedKeys: [SparseKey]

    public var codingPath: [CodingKey] {
        return wrappedEncoder.codingPath
    }

    public var userInfo: [CodingUserInfoKey : Any] {
        return wrappedEncoder.userInfo
    }

    public init(wrapping encoder: Encoder, encoding allowedKeys: [SparseKey]) {
        wrappedEncoder = encoder
        self.allowedKeys = allowedKeys
    }

    public func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        let container = SparseFieldKeyedEncodingContainer(wrapping: wrappedEncoder.container(keyedBy: type),
                                                          encoding: allowedKeys)
        return KeyedEncodingContainer(container)
    }

    public func unkeyedContainer() -> UnkeyedEncodingContainer {
        return wrappedEncoder.unkeyedContainer()
    }

    public func singleValueContainer() -> SingleValueEncodingContainer {
        return wrappedEncoder.singleValueContainer()
    }
}

public struct SparseFieldKeyedEncodingContainer<Key, SparseKey>: KeyedEncodingContainerProtocol where SparseKey: CodingKey, SparseKey: Equatable, Key: CodingKey {
    private var wrappedContainer: KeyedEncodingContainer<Key>
    private let allowedKeys: [SparseKey]

    public var codingPath: [CodingKey] {
        return wrappedContainer.codingPath
    }

    public init(wrapping container: KeyedEncodingContainer<Key>, encoding allowedKeys: [SparseKey]) {
        wrappedContainer = container
        self.allowedKeys = allowedKeys
    }

    private func shouldAllow(key: Key) -> Bool {
        if let key = key as? SparseKey {
            return allowedKeys.contains(key)
        }
        return true
    }

    public mutating func encodeNil(forKey key: Key) throws {
        guard shouldAllow(key: key) else { return }

        try wrappedContainer.encodeNil(forKey: key)
    }

    public mutating func encode(_ value: Bool, forKey key: Key) throws {
        guard shouldAllow(key: key) else { return }

        try wrappedContainer.encode(value, forKey: key)
    }

    public mutating func encode(_ value: String, forKey key: Key) throws {
        guard shouldAllow(key: key) else { return }

        try wrappedContainer.encode(value, forKey: key)
    }

    public mutating func encode(_ value: Double, forKey key: Key) throws {
        guard shouldAllow(key: key) else { return }

        try wrappedContainer.encode(value, forKey: key)
    }

    public mutating func encode(_ value: Float, forKey key: Key) throws {
        guard shouldAllow(key: key) else { return }

        try wrappedContainer.encode(value, forKey: key)
    }

    public mutating func encode(_ value: Int, forKey key: Key) throws {
        guard shouldAllow(key: key) else { return }

        try wrappedContainer.encode(value, forKey: key)
    }

    public mutating func encode(_ value: Int8, forKey key: Key) throws {
        guard shouldAllow(key: key) else { return }

        try wrappedContainer.encode(value, forKey: key)
    }

    public mutating func encode(_ value: Int16, forKey key: Key) throws {
        guard shouldAllow(key: key) else { return }

        try wrappedContainer.encode(value, forKey: key)
    }

    public mutating func encode(_ value: Int32, forKey key: Key) throws {
        guard shouldAllow(key: key) else { return }

        try wrappedContainer.encode(value, forKey: key)
    }

    public mutating func encode(_ value: Int64, forKey key: Key) throws {
        guard shouldAllow(key: key) else { return }

        try wrappedContainer.encode(value, forKey: key)
    }

    public mutating func encode(_ value: UInt, forKey key: Key) throws {
        guard shouldAllow(key: key) else { return }

        try wrappedContainer.encode(value, forKey: key)
    }

    public mutating func encode(_ value: UInt8, forKey key: Key) throws {
        guard shouldAllow(key: key) else { return }

        try wrappedContainer.encode(value, forKey: key)
    }

    public mutating func encode(_ value: UInt16, forKey key: Key) throws {
        guard shouldAllow(key: key) else { return }

        try wrappedContainer.encode(value, forKey: key)
    }

    public mutating func encode(_ value: UInt32, forKey key: Key) throws {
        guard shouldAllow(key: key) else { return }

        try wrappedContainer.encode(value, forKey: key)
    }

    public mutating func encode(_ value: UInt64, forKey key: Key) throws {
        guard shouldAllow(key: key) else { return }

        try wrappedContainer.encode(value, forKey: key)
    }

    public mutating func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
        guard shouldAllow(key: key) else { return }

        try wrappedContainer.encode(value, forKey: key)
    }

    public mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type,
                                                    forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        guard shouldAllow(key: key) else {
            return KeyedEncodingContainer(
                SparseFieldKeyedEncodingContainer<NestedKey, SparseKey>(wrapping: wrappedContainer.nestedContainer(keyedBy: keyType,
                                                                                                                   forKey: key),
                                                                        encoding: [])
            )
        }

        return KeyedEncodingContainer(
            SparseFieldKeyedEncodingContainer<NestedKey, SparseKey>(wrapping: wrappedContainer.nestedContainer(keyedBy: keyType,
                                                                                                               forKey: key),
                                                                    encoding: allowedKeys)
        )
    }

    public mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        guard shouldAllow(key: key) else {
            // TODO: Seems like this might not work as expected... maybe need an empty unkeyed container
            return wrappedContainer.nestedUnkeyedContainer(forKey: key)
        }

        return wrappedContainer.nestedUnkeyedContainer(forKey: key)
    }

    public mutating func superEncoder() -> Encoder {
        return wrappedContainer.superEncoder()
    }

    public mutating func superEncoder(forKey key: Key) -> Encoder {
        guard shouldAllow(key: key) else {
            return SparseFieldEncoder(wrapping: wrappedContainer.superEncoder(forKey: key), encoding: [SparseKey]())
        }

        return SparseFieldEncoder(wrapping: wrappedContainer.superEncoder(forKey: key), encoding: allowedKeys)
    }
}
