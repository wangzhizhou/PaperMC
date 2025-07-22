//
//  ISO8601DateTranscoder.swift
//
//
//  Created by joker on 2024/1/14.
//

import Foundation
import OpenAPIRuntime

public struct ISO8601DateTranscoder: DateTranscoder {
    
    public init() {}
    
    private let useStrictDataFormatter = false
    
    private var iso8601DateFormatter: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .gmt
        formatter.formatOptions = [
            .withDashSeparatorInDate,
            .withInternetDateTime,
            .withColonSeparatorInTime,
            .withFractionalSeconds,
            .withTimeZone,
        ]
        return formatter
    }
    
    /// Creates and returns an ISO 8601 formatted string representation of the specified date.
    public func encode(_ date: Date) throws -> String {
        return useStrictDataFormatter ? iso8601DateFormatter.string(from: date) : TimestampParser.format(date)
    }
    
    /// Creates and returns a date object from the specified ISO 8601 formatted string representation.
    public func decode(_ dateString: String) throws -> Date {
        guard let date = useStrictDataFormatter ? iso8601DateFormatter.date(from: dateString) : TimestampParser.parse(dateString)
        else {
            print(dateString)
            throw DecodingError.dataCorrupted(
                .init(codingPath: [], debugDescription: "Expected date string to be ISO8601-formatted.")
            )
        }
        return date
    }
}
