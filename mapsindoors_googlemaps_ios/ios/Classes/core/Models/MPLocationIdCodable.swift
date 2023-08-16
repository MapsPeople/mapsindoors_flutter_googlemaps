//
//  MPLocationIdCodable.swift
//  mapsindoors_googlemaps_ios
//
//  Created by Tim Mikkelsen on 21/06/2023.
//

import MapsIndoors

public class MPLocationIdCodable: Codable {
    public var id: String
    
    public enum CodingKeys: String, CodingKey {
        case id
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
    }
}
