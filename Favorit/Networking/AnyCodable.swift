//
//  AnyCodable.swift
//  Favorit
//
//  Created by Amber Katyal on 28/11/23.
//

import Foundation

public struct AnyCodable: Decodable, Hashable {
    static public func == (lhs: AnyCodable, rhs: AnyCodable) -> Bool {
        return lhs.integer == rhs.integer ||
        lhs.string == rhs.string ||
        lhs.bool == rhs.bool ||
        lhs.float == rhs.float
    }
    
    public func hash(into hasher: inout Hasher) {
        if let integer {
            hasher.combine(integer)
        } else if let float {
            hasher.combine(float)
        } else if let string {
            hasher.combine(string)
        } else if let bool {
            hasher.combine(bool)
        }
    }
    
    public var value: Any
    
    public struct CodingKeys: CodingKey {
        public var stringValue: String
        public var intValue: Int?
        
        public init?(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }
        public init?(stringValue: String) { self.stringValue = stringValue }
    }
    
    public init(value: Any) {
        self.value = value
    }
    
    public init?(value: Any?) {
        guard let value else {
            return nil
        }
        self.value = value
    }
    
    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            var result = [String: Any]()
            try container.allKeys.forEach { (key) throws in
                result[key.stringValue] = try container.decode(AnyCodable.self, forKey: key).value
            }
            value = result
        } else if var container = try? decoder.unkeyedContainer() {
            var result = [Any]()
            while !container.isAtEnd {
                result.append(try container.decode(AnyCodable.self).value)
            }
            value = result
        } else if let container = try? decoder.singleValueContainer() {
            if let intVal = try? container.decode(Int.self) {
                value = intVal
            } else if let doubleVal = try? container.decode(Double.self) {
                value = doubleVal
            } else if let boolVal = try? container.decode(Bool.self) {
                value = boolVal
            } else if let stringVal = try? container.decode(String.self) {
                value = stringVal
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "the container contains nothing serialisable")
            }
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Could not serialise"))
        }
    }
    
    public var string: String? {
        value as? String
    }
    
    public var integer: Int? {
        value as? Int
    }
    
    public var float: Float? {
        value as? Float
    }
    
    public var bool : Bool? {
        value as? Bool
    }
}

extension AnyCodable: Encodable {
    public func encode(to encoder: Encoder) throws {
        if let array = value as? [Any] {
            var container = encoder.unkeyedContainer()
            for value in array {
                let decodable = AnyCodable(value: value)
                try container.encode(decodable)
            }
        } else if let dictionary = value as? [String: Any] {
            var container = encoder.container(keyedBy: CodingKeys.self)
            for (key, value) in dictionary {
                let codingKey = CodingKeys(stringValue: key)!
                let decodable = AnyCodable(value: value)
                try container.encode(decodable, forKey: codingKey)
            }
        } else {
            var container = encoder.singleValueContainer()
            if let intVal = value as? Int {
                try container.encode(intVal)
            } else if let doubleVal = value as? Double {
                try container.encode(doubleVal)
            } else if let boolVal = value as? Bool {
                try container.encode(boolVal)
            } else if let stringVal = value as? String {
                try container.encode(stringVal)
            } else {
                throw EncodingError.invalidValue(value, EncodingError.Context.init(codingPath: [], debugDescription: "The value is not encodable"))
            }
            
        }
    }
}
