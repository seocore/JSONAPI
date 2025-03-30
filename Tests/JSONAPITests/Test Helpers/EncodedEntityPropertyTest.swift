//
//  EncodedEntityPropertyTest.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 12/21/18.
//

import Foundation
import XCTest
import JSONAPIKit
import JSONAPIKitTesting

func testEncoded<E: ResourceObjectType>(entity: E) {
	let encodedEntityData = encoded(value: entity)
	let jsonObject = try! JSONSerialization.jsonObject(with: encodedEntityData, options: [])
	let jsonDict = jsonObject as? [String: Any]

	XCTAssertNotNil(jsonDict)

	let jsonId = jsonDict?["id"]

	if E.EntityRawIdType.self == Unidentified.self {
		XCTAssertNil(jsonId)
	} else {
		XCTAssertNotNil(jsonId)
	}

	let jsonType = jsonDict?["type"] as? String

	XCTAssertEqual(jsonType, E.jsonType)

	let jsonAttributes = jsonDict?["attributes"] as? [String: Any]

	if E.Attributes.self == NoAttributes.self {
		XCTAssertNil(jsonAttributes)
	} else {
		XCTAssertNotNil(jsonAttributes)
	}

	let jsonRelationships = jsonDict?["relationships"] as? [String: Any]

	if E.Relationships.self == NoRelationships.self {
		XCTAssertNil(jsonRelationships)
	} else {
		XCTAssertNotNil(jsonRelationships)
	}

	let jsonMeta = jsonDict?["meta"] as? [String: Any]

	if E.Meta.self == NoMetadata.self {
		XCTAssertNil(jsonMeta)
	} else {
		XCTAssertNotNil(jsonMeta)
	}

	let jsonLinks = jsonDict?["links"] as? [String: Any]

	if E.Links.self == NoLinks.self {
		XCTAssertNil(jsonLinks)
	} else {
		XCTAssertNotNil(jsonLinks)
	}
}
