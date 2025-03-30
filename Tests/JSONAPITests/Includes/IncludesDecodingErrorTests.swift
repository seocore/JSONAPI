//
//  IncludesDecodingErrorTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/14/19.
//

import XCTest
import JSONAPIKit

final class IncludesDecodingErrorTests: XCTestCase {
    func test_unexpectedIncludeType() {
        XCTAssertThrowsError(try testDecoder.decode(Includes<Include2<TestEntity, TestEntity2>>.self, from: three_different_type_includes)) { (error: Error) -> Void in
            XCTAssertEqual(
                (error as? IncludesDecodingError)?.idx,
                2
            )

            XCTAssertEqual(
                (error as? IncludesDecodingError).map(String.init(describing:)),
                "Out of the 3 includes in the document, the 3rd one failed to parse: Found JSON:API type 'test_entity4' but expected one of 'test_entity1', 'test_entity2'"
            )
        }

        // now test that we get the same error with a different total include count from a different test stub
        XCTAssertThrowsError(try testDecoder.decode(Includes<Include2<TestEntity, TestEntity2>>.self, from: four_different_type_includes)) { (error2: Error) -> Void in
            XCTAssertEqual(
                (error2 as? IncludesDecodingError).map(String.init(describing:)),
                "Out of the 4 includes in the document, the 3rd one failed to parse: Found JSON:API type 'test_entity4' but expected one of 'test_entity1', 'test_entity2'"
            )
        }

        // and with six total includes
        XCTAssertThrowsError(try testDecoder.decode(Includes<Include2<TestEntity, TestEntity2>>.self, from: six_includes_one_bad_type)) { (error2: Error) -> Void in
            XCTAssertEqual(
                (error2 as? IncludesDecodingError).map(String.init(describing:)),
                "Out of the 6 includes in the document, the 5th one failed to parse: Found JSON:API type 'test_entity4' but expected one of 'test_entity1', 'test_entity2'"
            )
        }

        // and with a number of total includes between 10 and 19
        XCTAssertThrowsError(try testDecoder.decode(Includes<Include2<TestEntity, TestEntity2>>.self, from: eleven_includes_one_bad_type)) { (error2: Error) -> Void in
            XCTAssertEqual(
                (error2 as? IncludesDecodingError).map(String.init(describing:)),
                "Out of the 11 includes in the document, the 10th one failed to parse: Found JSON:API type 'test_entity4' but expected one of 'test_entity1', 'test_entity2'"
            )
        }

        // and finally with a larger number of total includes
        XCTAssertThrowsError(try testDecoder.decode(Includes<Include2<TestEntity, TestEntity2>>.self, from: twenty_two_includes_one_bad_type)) { (error2: Error) -> Void in
            XCTAssertEqual(
                (error2 as? IncludesDecodingError).map(String.init(describing:)),
                "Out of the 22 includes in the document, the 21st one failed to parse: Found JSON:API type 'test_entity4' but expected one of 'test_entity1', 'test_entity2'"
            )
        }
    }

    func test_missingProperty() {
        XCTAssertThrowsError(
            try testDecoder.decode(
                Includes<Include3<TestEntity, TestEntity2, TestEntity4>>.self,
                from: three_includes_one_missing_attributes
            )
        ) { (error: Error) -> Void in
            XCTAssertEqual(
                (error as? IncludesDecodingError).map(String.init(describing:)),
                "Out of the 3 includes in the document, the 3rd one failed to parse: 'foo' attribute is required and missing."
            )
        }
    }
}

// MARK: - Test Types
extension IncludesDecodingErrorTests {
    enum TestEntityType: ResourceObjectDescription {

        typealias Relationships = NoRelationships

        public static var jsonType: String { return "test_entity1" }

        public struct Attributes: JSONAPIKit.SparsableAttributes {
            let foo: Attribute<String>
            let bar: Attribute<Int>

            public enum CodingKeys: String, Equatable, CodingKey {
                case foo
                case bar
            }
        }
    }

    typealias TestEntity = BasicEntity<TestEntityType>

    enum TestEntityType2: ResourceObjectDescription {

        public static var jsonType: String { return "test_entity2" }

        public struct Relationships: JSONAPIKit.Relationships {
            let entity1: ToOneRelationship<TestEntity, NoIdMetadata, NoMetadata, NoLinks>
        }

        public struct Attributes: JSONAPIKit.SparsableAttributes {
            let foo: Attribute<String>
            let bar: Attribute<Int>

            public enum CodingKeys: String, Equatable, CodingKey {
                case foo
                case bar
            }
        }
    }

    typealias TestEntity2 = BasicEntity<TestEntityType2>

    enum TestEntityType4: ResourceObjectDescription {

        typealias Attributes = NoAttributes

        typealias Relationships = NoRelationships

        public static var jsonType: String { return "test_entity4" }
    }

    typealias TestEntity4 = BasicEntity<TestEntityType4>

    enum TestEntityType6: ResourceObjectDescription {

        typealias Attributes = NoAttributes

        public static var jsonType: String { return "test_entity6" }

        struct Relationships: JSONAPIKit.Relationships {
            let entity4: ToOneRelationship<TestEntity4, NoIdMetadata, NoMetadata, NoLinks>
        }
    }

    typealias TestEntity6 = BasicEntity<TestEntityType6>
}
