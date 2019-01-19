//
//  OpenAPITypes.swift
//  JSONAPIOpenAPI
//
//  Created by Mathew Polzin on 1/13/19.
//

import AnyCodable

// MARK: Node (i.e. schema) Protocols

/// Anything conforming to `OpenAPINodeType` can provide an
/// OpenAPI schema representing itself.
public protocol OpenAPINodeType {
	static func openAPINode() throws -> JSONNode
}

/// Anything conforming to `RawOpenAPINodeType` can provide an
/// OpenAPI schema representing itself. This second protocol is
/// necessary so that one type can conditionally provide a
/// schema and then (under different conditions) provide a
/// different schema. The "different" conditions have to do
/// with Raw Representability, hence the name of this protocol.
public protocol RawOpenAPINodeType {
	static func openAPINode() throws -> JSONNode
}

/// Anything conforming to `AnyJSONCaseIterable` can provide a
/// list of its possible values.
public protocol AnyJSONCaseIterable {
	static var allCases: [Any] { get }
}

/// Anything conforming to `AnyJSONCaseIterable` can provide a
/// list of its possible values. This second protocol is
/// necessary so that one type can conditionally provide a
/// list of possible values and then (under different conditions)
/// provide a different list of possible values.
/// The "different" conditions have to do
/// with Optionality, hence the name of this protocol.
public protocol AnyWrappedJSONCaseIterable {
	static var allCases: [Any] { get }
}

public protocol SwiftTyped {
	associatedtype SwiftType: Codable, Equatable
}

public protocol OpenAPIFormat: SwiftTyped, Codable, Equatable {
	static var unspecified: Self { get }

	var jsonType: JSONType { get }
}

public protocol JSONNodeContext {
	var required: Bool { get }
}

public enum JSONType: String, Codable {
	case boolean = "boolean"
	case object = "object"
	case array = "array"
	case number = "number"
	case integer = "integer"
	case string = "string"
}

public enum JSONTypeFormat: Equatable {
	case boolean(BooleanFormat)
	case object(ObjectFormat)
	case array(ArrayFormat)
	case number(NumberFormat)
	case integer(IntegerFormat)
	case string(StringFormat)

	public enum BooleanFormat: String, Equatable, OpenAPIFormat {
		case generic = ""

		public typealias SwiftType = Bool

		public static var unspecified: BooleanFormat {
			return .generic
		}

		public var jsonType: JSONType {
			return .boolean
		}
	}

	public enum ObjectFormat: String, Equatable, OpenAPIFormat {
		case generic = ""

		public typealias SwiftType = AnyCodable

		public static var unspecified: ObjectFormat {
			return .generic
		}

		public var jsonType: JSONType {
			return .object
		}
	}

	public enum ArrayFormat: String, Equatable, OpenAPIFormat {
		case generic = ""

		public typealias SwiftType = [AnyCodable]

		public static var unspecified: ArrayFormat {
			return .generic
		}

		public var jsonType: JSONType {
			return .array
		}
	}

	public enum NumberFormat: String, Equatable, OpenAPIFormat {
		case generic = ""
		case float = "float"
		case double = "double"

		public typealias SwiftType = Double

		public static var unspecified: NumberFormat {
			return .generic
		}

		public var jsonType: JSONType {
			return .number
		}
	}

	public enum IntegerFormat: String, Equatable, OpenAPIFormat {
		case generic = ""
		case int32 = "int32"
		case int64 = "int64"

		public typealias SwiftType = Int

		public static var unspecified: IntegerFormat {
			return .generic
		}

		public var jsonType: JSONType {
			return .integer
		}
	}

	public enum StringFormat: String, Equatable, OpenAPIFormat {
		case generic = ""
		case byte = "byte"
		case binary = "binary"
		case date = "date"
		case dateTime = "date-time"
		case password = "password"

		public typealias SwiftType = String

		public static var unspecified: StringFormat {
			return .generic
		}

		public var jsonType: JSONType {
			return .string
		}
	}

	public var jsonType: JSONType {
		switch self {
		case .boolean:
			return .boolean
		case .object:
			return .object
		case .array:
			return .array
		case .number:
			return .number
		case .integer:
			return .integer
		case .string:
			return .string
		}
	}
}

/// A JSON Node is what OpenAPI calls a
/// "Schema Object"
public enum JSONNode {
	case boolean(Context<JSONTypeFormat.BooleanFormat>)
	indirect case object(Context<JSONTypeFormat.ObjectFormat>, ObjectContext)
	indirect case array(Context<JSONTypeFormat.ArrayFormat>, ArrayContext)
	case number(Context<JSONTypeFormat.NumberFormat>, NumericContext)
	case integer(Context<JSONTypeFormat.IntegerFormat>, NumericContext)
	case string(Context<JSONTypeFormat.StringFormat>, StringContext)
	indirect case allOf([JSONNode])
	indirect case oneOf([JSONNode])
	indirect case anyOf([JSONNode])
	indirect case not(JSONNode)

	public struct Context<Format: OpenAPIFormat>: JSONNodeContext, Equatable {
		public let format: Format
		public let required: Bool
		public let nullable: Bool

		/// The OpenAPI spec calls this "enum"
		/// If not specified, it is assumed that any
		/// value of the given format is allowed.
		public let allowedValues: [Format.SwiftType]?

		public init(format: Format,
					required: Bool,
					nullable: Bool = false,
					allowedValues: [Format.SwiftType]? = nil) {
			self.format = format
			self.required = required
			self.nullable = nullable
			self.allowedValues = allowedValues
		}

		/// Return the optional version of this Context
		public func optionalContext() -> Context {
			return .init(format: format,
						 required: false,
						 nullable: nullable,
						 allowedValues: allowedValues)
		}

		/// Return the required version of this context
		public func requiredContext() -> Context {
			return .init(format: format,
						 required: true,
						 nullable: nullable,
						 allowedValues: allowedValues)
		}

		/// Return the nullable version of this context
		public func nullableContext() -> Context {
			return .init(format: format,
						 required: required,
						 nullable: true,
						 allowedValues: allowedValues)
		}

		/// Return this context with the given list of possible values
		public func with(allowedValues: [Format.SwiftType]?) -> Context {
			return .init(format: format,
						 required: required,
						 nullable: nullable,
						 allowedValues: allowedValues)
		}
	}

	public struct NumericContext {
		/// A numeric instance is valid only if division by this keyword's value results in an integer. Defaults to nil.
		public let multipleOf: Double?
		public let maximum: Double?
		public let exclusiveMaximum: Double?
		public let minimum: Double?
		public let exclusiveMinimum: Double?

		public init(multipleOf: Double? = nil,
					maximum: Double? = nil,
					exclusiveMaximum: Double? = nil,
					minimum: Double? = nil,
					exclusiveMinimum: Double? = nil) {
			self.multipleOf = multipleOf
			self.maximum = maximum
			self.exclusiveMaximum = exclusiveMaximum
			self.minimum = minimum
			self.exclusiveMinimum = exclusiveMinimum
		}
	}

	public struct StringContext {
		public let maxLength: Int?
		public let minLength: Int

		/// Regular expression
		public let pattern: String?

		public init(maxLength: Int? = nil,
					minLength: Int = 0,
					pattern: String? = nil) {
			self.maxLength = maxLength
			self.minLength = minLength
			self.pattern = pattern
		}
	}

	public struct ArrayContext {
		/// A JSON Type Node that describes
		/// the type of each element in the array.
		public let items: JSONNode

		/// Maximum number of items in array.
		public let maxItems: Int?

		/// Minimum number of items in array.
		/// Defaults to 0.
		public let minItems: Int

		/// Setting to true indicates all
		/// elements of the array are expected
		/// to be unique. Defaults to false.
		public let uniqueItems: Bool

		public init(items: JSONNode,
					maxItems: Int? = nil,
					minItems: Int = 0,
					uniqueItems: Bool = false) {
			self.items = items
			self.maxItems = maxItems
			self.minItems = minItems
			self.uniqueItems = uniqueItems
		}
	}

	public struct ObjectContext {
		public let maxProperties: Int?
		public let minProperties: Int
		public let properties: [String: JSONNode]
		public let additionalProperties: [String: JSONNode]?

		/*
		// NOTE that an object's required properties
		// array is determined by looking at its properties'
		// required Bool.
		public let required: [String]
		*/

		public init(properties: [String: JSONNode],
					additionalProperties: [String: JSONNode]? = nil,
					maxProperties: Int? = nil,
					minProperties: Int = 0) {
			self.properties = properties
			self.additionalProperties = additionalProperties
			self.maxProperties = maxProperties
			self.minProperties = minProperties
		}
	}

	public var jsonTypeFormat: JSONTypeFormat? {
		switch self {
		case .boolean(let context):
			return .boolean(context.format)
		case .object(let context, _):
			return .object(context.format)
		case .array(let context, _):
			return .array(context.format)
		case .number(let context, _):
			return .number(context.format)
		case .integer(let context, _):
			return .integer(context.format)
		case .string(let context, _):
			return .string(context.format)
		case .allOf, .oneOf, .anyOf, .not:
			return nil
		}
	}

	public var required: Bool {
		switch self {
		case .boolean(let contextA as JSONNodeContext),
			 .object(let contextA as JSONNodeContext, _),
			 .array(let contextA as JSONNodeContext, _),
			 .number(let contextA as JSONNodeContext, _),
			 .integer(let contextA as JSONNodeContext, _),
			 .string(let contextA as JSONNodeContext, _):
			return contextA.required
		case .allOf, .oneOf, .anyOf, .not:
			return true
		}
	}

	/// Return the optional version of this JSONNode
	public func optionalNode() -> JSONNode {
		switch self {
		case .boolean(let context):
			return .boolean(context.optionalContext())
		case .object(let contextA, let contextB):
			return .object(contextA.optionalContext(), contextB)
		case .array(let contextA, let contextB):
			return .array(contextA.optionalContext(), contextB)
		case .number(let context, let contextB):
			return .number(context.optionalContext(), contextB)
		case .integer(let context, let contextB):
			return .integer(context.optionalContext(), contextB)
		case .string(let context, let contextB):
			return .string(context.optionalContext(), contextB)
		case .allOf, .oneOf, .anyOf, .not:
			return self
		}
	}

	/// Return the required version of this JSONNode
	public func requiredNode() -> JSONNode {
		switch self {
		case .boolean(let context):
			return .boolean(context.requiredContext())
		case .object(let contextA, let contextB):
			return .object(contextA.requiredContext(), contextB)
		case .array(let contextA, let contextB):
			return .array(contextA.requiredContext(), contextB)
		case .number(let context, let contextB):
			return .number(context.requiredContext(), contextB)
		case .integer(let context, let contextB):
			return .integer(context.requiredContext(), contextB)
		case .string(let context, let contextB):
			return .string(context.requiredContext(), contextB)
		case .allOf, .oneOf, .anyOf, .not:
			return self
		}
	}

	/// Return the nullable version of this JSONNode
	public func nullableNode() -> JSONNode {
		switch self {
		case .boolean(let context):
			return .boolean(context.nullableContext())
		case .object(let contextA, let contextB):
			return .object(contextA.nullableContext(), contextB)
		case .array(let contextA, let contextB):
			return .array(contextA.nullableContext(), contextB)
		case .number(let context, let contextB):
			return .number(context.nullableContext(), contextB)
		case .integer(let context, let contextB):
			return .integer(context.nullableContext(), contextB)
		case .string(let context, let contextB):
			return .string(context.nullableContext(), contextB)
		case .allOf, .oneOf, .anyOf, .not:
			return self
		}
	}

	public func with<T>(allowedValues: [T]) throws -> JSONNode where T: RawRepresentable, T.RawValue == String {
		return try with(allowedValues: allowedValues.map { $0.rawValue })
	}

	public func with(allowedValues: [JSONTypeFormat.BooleanFormat.SwiftType]) throws -> JSONNode {
		guard case let .boolean(contextA) = self else {
			throw AllowedValueError(expectation: jsonTypeFormat?.jsonType, receivedType: JSONTypeFormat.BooleanFormat.SwiftType.self)
		}
		return .boolean(contextA.with(allowedValues: allowedValues))
	}

	public func with(allowedValues: [JSONTypeFormat.ObjectFormat.SwiftType]) throws -> JSONNode {
		guard case let .object(contextA, contextB) = self else {
			throw AllowedValueError(expectation: jsonTypeFormat?.jsonType, receivedType: JSONTypeFormat.ObjectFormat.SwiftType.self)
		}
		return .object(contextA.with(allowedValues: allowedValues), contextB)
	}

	public func with(allowedValues: [JSONTypeFormat.ArrayFormat.SwiftType]) throws -> JSONNode {
		guard case let .array(contextA, contextB) = self else {
			throw AllowedValueError(expectation: jsonTypeFormat?.jsonType, receivedType: JSONTypeFormat.ArrayFormat.SwiftType.self)
		}
		return .array(contextA.with(allowedValues: allowedValues), contextB)
	}

	public func with(allowedValues: [JSONTypeFormat.NumberFormat.SwiftType]) throws -> JSONNode {
		guard case let .number(contextA, contextB) = self else {
			throw AllowedValueError(expectation: jsonTypeFormat?.jsonType, receivedType: JSONTypeFormat.NumberFormat.SwiftType.self)
		}
		return .number(contextA.with(allowedValues: allowedValues), contextB)
	}

	public func with(allowedValues: [JSONTypeFormat.IntegerFormat.SwiftType]) throws -> JSONNode {
		guard case let .integer(contextA, contextB) = self else {
			throw AllowedValueError(expectation: jsonTypeFormat?.jsonType, receivedType: JSONTypeFormat.IntegerFormat.SwiftType.self)
		}
		return .integer(contextA.with(allowedValues: allowedValues), contextB)
	}

	public func with(allowedValues: [JSONTypeFormat.StringFormat.SwiftType]) throws -> JSONNode {
		guard case let .string(contextA, contextB) = self else {
			throw AllowedValueError(expectation: jsonTypeFormat?.jsonType, receivedType: JSONTypeFormat.StringFormat.SwiftType.self)
		}
		return .string(contextA.with(allowedValues: allowedValues), contextB)
	}
}

public struct AllowedValueError: Swift.Error, CustomStringConvertible {
	public let expectation: JSONType?
	public let receivedType: Any.Type

	public init(expectation: JSONType?, receivedType: Any.Type) {
		self.expectation = expectation
		self.receivedType = receivedType
	}

	public var description: String {
		return "Expected type compatible with JSON Type \(String(describing: expectation)) but found \(receivedType)"
	}
}
