//
//  Poly.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/22/18.
//

import Result

/// Poly is a protocol to which types that
/// are polymorphic belong to. Specifically,
/// Poly1, Poly2, Poly3, etc. types conform
/// to the Poly protocol. These types allow
/// typesafe grouping of a number of
/// disparate types under one roof for
/// the purposes of JSON API compliant
/// encoding or decoding.
public protocol Poly: Codable, Equatable {}

// MARK: - Generic Decoding

private func decode<Entity: JSONAPI.EntityType>(_ type: Entity.Type, from container: SingleValueDecodingContainer) throws -> Result<Entity, EncodingError> {
	let ret: Result<Entity, EncodingError>
	do {
		ret = try .success(container.decode(Entity.self))
	} catch (let err as EncodingError) {
		ret = .failure(err)
	} catch (let err) {
		ret = .failure(EncodingError.invalidValue(Entity.Description.self,
												  .init(codingPath: container.codingPath,
														debugDescription: err.localizedDescription,
														underlyingError: err)))
	}
	return ret
}

// MARK: - 0 types
public protocol _Poly0: Poly { }
public struct Poly0: _Poly0 {

	public init() {}

	public init(from decoder: Decoder) throws {
	}

	public func encode(to encoder: Encoder) throws {
		throw JSONAPIEncodingError.illegalEncoding("Attempted to encode Include0, which should be represented by the absence of an 'included' entry altogether.")
	}
}

// MARK: - 1 type
public protocol _Poly1: _Poly0 {
	associatedtype A: EntityType
	var a: A? { get }

	init(_ a: A)
}
public enum Poly1<A: EntityType>: _Poly1 {
	case a(A)

	public var a: A? {
		guard case let .a(ret) = self else { return nil }
		return ret
	}

	public init(_ a: A) {
		self = .a(a)
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()

		self = .a(try container.decode(A.self))
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()

		switch self {
		case .a(let a):
			try container.encode(a)
		}
	}
}

extension Poly1: CustomStringConvertible {
	public var description: String {
		let str: String
		switch self {
		case .a(let a):
			str = String(describing: a)
		}
		return "Include(\(str))"
	}
}

// MARK: - 2 types
public protocol _Poly2: _Poly1 {
	associatedtype B: EntityType
	var b: B? { get }

	init(_ b: B)
}
public enum Poly2<A: EntityType, B: EntityType>: _Poly2 {
	case a(A)
	case b(B)

	public var a: A? {
		guard case let .a(ret) = self else { return nil }
		return ret
	}

	public init(_ a: A) {
		self = .a(a)
	}

	public var b: B? {
		guard case let .b(ret) = self else { return nil }
		return ret
	}

	public init(_ b: B) {
		self = .b(b)
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()

		let attempts = [
			try decode(A.self, from: container).map { Poly2.a($0) },
			try decode(B.self, from: container).map { Poly2.b($0) } ]

		let maybeVal: Poly2<A, B>? = attempts
			.compactMap { $0.value }
			.first

		guard let val = maybeVal else {
			throw EncodingError.invalidValue(Poly2<A, B>.self, .init(codingPath: decoder.codingPath, debugDescription: "Failed to find an include of the expected type. Attempts: \(attempts.map { $0.error }.compactMap { $0 })"))
		}

		self = val
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()

		switch self {
		case .a(let a):
			try container.encode(a)
		case .b(let b):
			try container.encode(b)
		}
	}
}

extension Poly2: CustomStringConvertible {
	public var description: String {
		let str: String
		switch self {
		case .a(let a):
			str = String(describing: a)
		case .b(let b):
			str = String(describing: b)
		}
		return "Include(\(str))"
	}
}

// MARK: - 3 types
public protocol _Poly3: _Poly2 {
	associatedtype C: EntityType
	var c: C? { get }

	init(_ c: C)
}
public enum Poly3<A: EntityType, B: EntityType, C: EntityType>: _Poly3 {
	case a(A)
	case b(B)
	case c(C)

	public var a: A? {
		guard case let .a(ret) = self else { return nil }
		return ret
	}

	public init(_ a: A) {
		self = .a(a)
	}

	public var b: B? {
		guard case let .b(ret) = self else { return nil }
		return ret
	}

	public init(_ b: B) {
		self = .b(b)
	}

	public var c: C? {
		guard case let .c(ret) = self else { return nil }
		return ret
	}

	public init(_ c: C) {
		self = .c(c)
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()

		let attempts = [
			try decode(A.self, from: container).map { Poly3.a($0) },
			try decode(B.self, from: container).map { Poly3.b($0) },
			try decode(C.self, from: container).map { Poly3.c($0) }]

		let maybeVal: Poly3<A, B, C>? = attempts
			.compactMap { $0.value }
			.first

		guard let val = maybeVal else {
			throw EncodingError.invalidValue(Poly3<A, B, C>.self, .init(codingPath: decoder.codingPath, debugDescription: "Failed to find an include of the expected type. Attempts: \(attempts.map { $0.error }.compactMap { $0 })"))
		}

		self = val
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()

		switch self {
		case .a(let a):
			try container.encode(a)
		case .b(let b):
			try container.encode(b)
		case .c(let c):
			try container.encode(c)
		}
	}
}

extension Poly3: CustomStringConvertible {
	public var description: String {
		let str: String
		switch self {
		case .a(let a):
			str = String(describing: a)
		case .b(let b):
			str = String(describing: b)
		case .c(let c):
			str = String(describing: c)
		}
		return "Include(\(str))"
	}
}

// MARK: - 4 types
public protocol _Poly4: _Poly3 {
	associatedtype D: EntityType
	var d: D? { get }

	init(_ d: D)
}
public enum Poly4<A: EntityType, B: EntityType, C: EntityType, D: EntityType>: _Poly4 {
	case a(A)
	case b(B)
	case c(C)
	case d(D)

	public var a: A? {
		guard case let .a(ret) = self else { return nil }
		return ret
	}

	public init(_ a: A) {
		self = .a(a)
	}

	public var b: B? {
		guard case let .b(ret) = self else { return nil }
		return ret
	}

	public init(_ b: B) {
		self = .b(b)
	}

	public var c: C? {
		guard case let .c(ret) = self else { return nil }
		return ret
	}

	public init(_ c: C) {
		self = .c(c)
	}

	public var d: D? {
		guard case let .d(ret) = self else { return nil }
		return ret
	}

	public init(_ d: D) {
		self = .d(d)
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()

		let attempts = [
			try decode(A.self, from: container).map { Poly4.a($0) },
			try decode(B.self, from: container).map { Poly4.b($0) },
			try decode(C.self, from: container).map { Poly4.c($0) },
			try decode(D.self, from: container).map { Poly4.d($0) }]

		let maybeVal: Poly4<A, B, C, D>? = attempts
			.compactMap { $0.value }
			.first

		guard let val = maybeVal else {
			throw EncodingError.invalidValue(Poly4<A, B, C, D>.self, .init(codingPath: decoder.codingPath, debugDescription: "Failed to find an include of the expected type. Attempts: \(attempts.map { $0.error }.compactMap { $0 })"))
		}

		self = val
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()

		switch self {
		case .a(let a):
			try container.encode(a)
		case .b(let b):
			try container.encode(b)
		case .c(let c):
			try container.encode(c)
		case .d(let d):
			try container.encode(d)
		}
	}
}

extension Poly4: CustomStringConvertible {
	public var description: String {
		let str: String
		switch self {
		case .a(let a):
			str = String(describing: a)
		case .b(let b):
			str = String(describing: b)
		case .c(let c):
			str = String(describing: c)
		case .d(let d):
			str = String(describing: d)
		}
		return "Include(\(str))"
	}
}

// MARK: - 5 types
public protocol _Poly5: _Poly4 {
	associatedtype E: EntityType
	var e: E? { get }

	init(_ e: E)
}
public enum Poly5<A: EntityType, B: EntityType, C: EntityType, D: EntityType, E: EntityType>: _Poly5 {
	case a(A)
	case b(B)
	case c(C)
	case d(D)
	case e(E)

	public var a: A? {
		guard case let .a(ret) = self else { return nil }
		return ret
	}

	public init(_ a: A) {
		self = .a(a)
	}

	public var b: B? {
		guard case let .b(ret) = self else { return nil }
		return ret
	}

	public init(_ b: B) {
		self = .b(b)
	}

	public var c: C? {
		guard case let .c(ret) = self else { return nil }
		return ret
	}

	public init(_ c: C) {
		self = .c(c)
	}

	public var d: D? {
		guard case let .d(ret) = self else { return nil }
		return ret
	}

	public init(_ d: D) {
		self = .d(d)
	}

	public var e: E? {
		guard case let .e(ret) = self else { return nil }
		return ret
	}

	public init(_ e: E) {
		self = .e(e)
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()

		let attempts = [
			try decode(A.self, from: container).map { Poly5.a($0) },
			try decode(B.self, from: container).map { Poly5.b($0) },
			try decode(C.self, from: container).map { Poly5.c($0) },
			try decode(D.self, from: container).map { Poly5.d($0) },
			try decode(E.self, from: container).map { Poly5.e($0) }]

		let maybeVal: Poly5<A, B, C, D, E>? = attempts
			.compactMap { $0.value }
			.first

		guard let val = maybeVal else {
			throw EncodingError.invalidValue(Poly5<A, B, C, D, E>.self, .init(codingPath: decoder.codingPath, debugDescription: "Failed to find an include of the expected type. Attempts: \(attempts.map { $0.error }.compactMap { $0 })"))
		}

		self = val
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()

		switch self {
		case .a(let a):
			try container.encode(a)
		case .b(let b):
			try container.encode(b)
		case .c(let c):
			try container.encode(c)
		case .d(let d):
			try container.encode(d)
		case .e(let e):
			try container.encode(e)
		}
	}
}

extension Poly5: CustomStringConvertible {
	public var description: String {
		let str: String
		switch self {
		case .a(let a):
			str = String(describing: a)
		case .b(let b):
			str = String(describing: b)
		case .c(let c):
			str = String(describing: c)
		case .d(let d):
			str = String(describing: d)
		case .e(let e):
			str = String(describing: e)
		}
		return "Include(\(str))"
	}
}

// MARK: - 6 types
public protocol _Poly6: _Poly5 {
	associatedtype F: EntityType
	var f: F? { get }

	init(_ f: F)
}
public enum Poly6<A: EntityType, B: EntityType, C: EntityType, D: EntityType, E: EntityType, F: EntityType>: _Poly6 {
	case a(A)
	case b(B)
	case c(C)
	case d(D)
	case e(E)
	case f(F)

	public var a: A? {
		guard case let .a(ret) = self else { return nil }
		return ret
	}

	public init(_ a: A) {
		self = .a(a)
	}

	public var b: B? {
		guard case let .b(ret) = self else { return nil }
		return ret
	}

	public init(_ b: B) {
		self = .b(b)
	}

	public var c: C? {
		guard case let .c(ret) = self else { return nil }
		return ret
	}

	public init(_ c: C) {
		self = .c(c)
	}

	public var d: D? {
		guard case let .d(ret) = self else { return nil }
		return ret
	}

	public init(_ d: D) {
		self = .d(d)
	}

	public var e: E? {
		guard case let .e(ret) = self else { return nil }
		return ret
	}

	public init(_ e: E) {
		self = .e(e)
	}

	public var f: F? {
		guard case let .f(ret) = self else { return nil }
		return ret
	}

	public init(_ f: F) {
		self = .f(f)
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()

		let attempts = [
			try decode(A.self, from: container).map { Poly6.a($0) },
			try decode(B.self, from: container).map { Poly6.b($0) },
			try decode(C.self, from: container).map { Poly6.c($0) },
			try decode(D.self, from: container).map { Poly6.d($0) },
			try decode(E.self, from: container).map { Poly6.e($0) },
			try decode(F.self, from: container).map { Poly6.f($0) }]

		let maybeVal: Poly6<A, B, C, D, E, F>? = attempts
			.compactMap { $0.value }
			.first

		guard let val = maybeVal else {
			throw EncodingError.invalidValue(Poly6<A, B, C, D, E, F>.self, .init(codingPath: decoder.codingPath, debugDescription: "Failed to find an include of the expected type. Attempts: \(attempts.map { $0.error }.compactMap { $0 })"))
		}

		self = val
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()

		switch self {
		case .a(let a):
			try container.encode(a)
		case .b(let b):
			try container.encode(b)
		case .c(let c):
			try container.encode(c)
		case .d(let d):
			try container.encode(d)
		case .e(let e):
			try container.encode(e)
		case .f(let f):
			try container.encode(f)
		}
	}
}

extension Poly6: CustomStringConvertible {
	public var description: String {
		let str: String
		switch self {
		case .a(let a):
			str = String(describing: a)
		case .b(let b):
			str = String(describing: b)
		case .c(let c):
			str = String(describing: c)
		case .d(let d):
			str = String(describing: d)
		case .e(let e):
			str = String(describing: e)
		case .f(let f):
			str = String(describing: f)
		}
		return "Include(\(str))"
	}
}
