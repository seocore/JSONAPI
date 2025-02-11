//
//  SparseFieldset.swift
//  
//
//  Created by Mathew Polzin on 8/4/19.
//

/// A SparseFieldset represents an `Encodable` subset of the fields
/// a `ResourceObject` would normally encode. Currently, you can
/// only apply sparse fieldset's to `ResourceObject.Attributes`.
public struct SparseFieldset<
    Description: JSONAPIKit.ResourceObjectDescription,
    MetaType: JSONAPIKit.Meta,
    LinksType: JSONAPIKit.Links,
    EntityRawIdType: JSONAPIKit.MaybeRawId
>: EncodablePrimaryResource where Description.Attributes: SparsableAttributes {

    /// The `ResourceObject` type this `SparseFieldset` is capable of modifying.
    public typealias Resource = JSONAPIKit.ResourceObject<Description, MetaType, LinksType, EntityRawIdType>

    public let resourceObject: Resource
    public let fields: [Description.Attributes.CodingKeys]

    public init(_ resourceObject: Resource, fields: [Description.Attributes.CodingKeys]) {
        self.resourceObject = resourceObject
        self.fields = fields
    }

    public func encode(to encoder: Encoder) throws {
        let sparseEncoder = SparseFieldEncoder(wrapping: encoder,
                                               encoding: fields)

        try resourceObject.encode(to: sparseEncoder)
    }
}

public extension ResourceObject where Description.Attributes: SparsableAttributes {

    /// The `SparseFieldset` type for this `ResourceObject`
    typealias SparseType = SparseFieldset<Description, MetaType, LinksType, EntityRawIdType>

    /// Get a Sparse Fieldset of this `ResourceObject` that can be encoded
    /// as a `SparsePrimaryResource`.
    func sparse(with fields: [Description.Attributes.CodingKeys]) -> SparseType {
        return SparseFieldset(self, fields: fields)
    }
}
