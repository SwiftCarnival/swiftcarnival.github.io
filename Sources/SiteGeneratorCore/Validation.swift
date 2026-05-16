public enum ValidationError: Error, CustomStringConvertible, Equatable {
    case invalidMonthFormat(String)
    case duplicateMonth(String)
    case notReverseChrono(String, String)

    public var description: String {
        switch self {
        case .invalidMonthFormat(let m):
            return "Invalid month format: '\(m)' (expected YYYY-MM)"
        case .duplicateMonth(let m):
            return "Duplicate month: '\(m)'"
        case .notReverseChrono(let a, let b):
            return "Not in reverse chronological order: '\(a)' appears before '\(b)'"
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
    }
}
