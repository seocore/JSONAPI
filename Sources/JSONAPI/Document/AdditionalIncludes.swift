//
//  AdditionalIncludes.swift
//  JSONAPI
//
//  Created by Dmitry Neveshkin on 18.12.2024.
//

import Poly

// MARK: - 15 includes
public typealias Include16 = Poly16
extension Includes where I: _Poly16 {
    public subscript(_ lookup: I.P.Type) -> [I.P] {
        return values.compactMap(\.p)
    }
}

// MARK: - 15 types
extension Poly16: EncodablePrimaryResource, OptionalEncodablePrimaryResource
where
A: EncodablePolyWrapped,
B: EncodablePolyWrapped,
C: EncodablePolyWrapped,
D: EncodablePolyWrapped,
E: EncodablePolyWrapped,
F: EncodablePolyWrapped,
G: EncodablePolyWrapped,
H: EncodablePolyWrapped,
I: EncodablePolyWrapped,
J: EncodablePolyWrapped,
K: EncodablePolyWrapped,
L: EncodablePolyWrapped,
M: EncodablePolyWrapped,
N: EncodablePolyWrapped,
O: EncodablePolyWrapped,
P: EncodablePolyWrapped
{}

extension Poly16: CodablePrimaryResource, OptionalCodablePrimaryResource
where
A: CodablePolyWrapped,
B: CodablePolyWrapped,
C: CodablePolyWrapped,
D: CodablePolyWrapped,
E: CodablePolyWrapped,
F: CodablePolyWrapped,
G: CodablePolyWrapped,
H: CodablePolyWrapped,
I: CodablePolyWrapped,
J: CodablePolyWrapped,
K: CodablePolyWrapped,
L: CodablePolyWrapped,
M: CodablePolyWrapped,
N: CodablePolyWrapped,
O: CodablePolyWrapped,
P: CodablePolyWrapped
{}
