import Foundation

public struct Host: Codable, Sendable {
    public var name: String
    public var link: String

    public init(name: String, link: String) {
        self.name = name
        self.link = link
    }
}

public struct Edition: Codable, Sendable {
    public var month: String
    public var host: Host
    public var topic: String
    public var status: Status
    public var roundup: String

    public enum Status: String, Codable, Sendable {
        case upcoming
        case open
        case published
    }

    public init(month: String, host: Host, topic: String, status: Status, roundup: String) {
        self.month = month
        self.host = host
        self.topic = topic
        self.status = status
        self.roundup = roundup
    }
}

public struct EditionsFile: Codable, Sendable {
    public var editions: [Edition]

    public init(editions: [Edition]) {
        self.editions = editions
    }
}

public enum ValidationError: Error, CustomStringConvertible, Equatable {
    case invalidMonthFormat(String)
    case duplicateMonth(String)
    case notReverseChrono(String, String)
    case publishedWithoutRoundup(String)

    public var description: String {
        switch self {
        case .invalidMonthFormat(let m):
            return "Invalid month format: '\(m)' (expected YYYY-MM)"
        case .duplicateMonth(let m):
            return "Duplicate month: '\(m)'"
        case .notReverseChrono(let a, let b):
            return "Not in reverse chronological order: '\(a)' appears before '\(b)'"
        case .publishedWithoutRoundup(let m):
            return "Edition \(m) has status 'published' but no roundup URL"
        }
    }
}

public func validateEditions(_ editions: [Edition]) throws {
    let monthPattern = /^\d{4}-(0[1-9]|1[0-2])$/
    var seen = Set<String>()

    for (i, edition) in editions.enumerated() {
        guard edition.month.wholeMatch(of: monthPattern) != nil else {
            throw ValidationError.invalidMonthFormat(edition.month)
        }

        guard !seen.contains(edition.month) else {
            throw ValidationError.duplicateMonth(edition.month)
        }
        seen.insert(edition.month)

        if i > 0 && edition.month >= editions[i - 1].month {
            throw ValidationError.notReverseChrono(editions[i - 1].month, edition.month)
        }

        if edition.status == .published && edition.roundup.isEmpty {
            throw ValidationError.publishedWithoutRoundup(edition.month)
        }
    }
}
