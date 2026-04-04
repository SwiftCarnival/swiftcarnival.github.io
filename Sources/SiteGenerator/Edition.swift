import Foundation

struct Host: Codable {
    var name: String
    var link: String
}

struct Edition: Codable {
    var month: String
    var host: Host
    var topic: String
    var status: Status
    var roundup: String

    enum Status: String, Codable {
        case upcoming
        case open
        case published
    }
}

struct EditionsFile: Codable {
    var editions: [Edition]
}

enum ValidationError: Error, CustomStringConvertible {
    case invalidMonthFormat(String)
    case duplicateMonth(String)
    case notReverseChrono(String, String)
    case publishedWithoutRoundup(String)

    var description: String {
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

func validateEditions(_ editions: [Edition]) throws {
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
