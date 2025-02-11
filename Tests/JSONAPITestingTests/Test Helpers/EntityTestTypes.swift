//
//  EntityTestTypes.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/15/18.
//

import JSONAPIKit

public typealias Entity<Description: JSONAPIKit.ResourceObjectDescription, Meta: JSONAPIKit.Meta, Links: JSONAPIKit.Links> = JSONAPIKit.ResourceObject<Description, Meta, Links, String>

public typealias BasicEntity<Description: JSONAPIKit.ResourceObjectDescription> = Entity<Description, NoMetadata, NoLinks>

public typealias NewEntity<Description: JSONAPIKit.ResourceObjectDescription, Meta: JSONAPIKit.Meta, Links: JSONAPIKit.Links> = JSONAPIKit.ResourceObject<Description, Meta, Links, Unidentified>

extension String: JSONAPIKit.JSONAPIURL {}
