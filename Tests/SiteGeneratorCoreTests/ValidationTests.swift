import Testing
@testable import SiteGeneratorCore

@Suite struct ValidationTests {
    @Test func validSingleEdition() throws {
        let editions = [
            Edition(month: "2026-04", host: Host(name: "", link: ""), topic: "", roundup: "")
        ]
        try validateEditions(editions)
    }

    @Test func validMultipleEditionsReverseOrder() throws {
        let editions = [
            Edition(month: "2026-06", host: Host(name: "Alice", link: ""), topic: "Concurrency", roundup: ""),
            Edition(month: "2026-05", host: Host(name: "Bob", link: ""), topic: "Testing", roundup: ""),
            Edition(month: "2026-04", host: Host(name: "Carol", link: ""), topic: "SwiftUI", roundup: "https://example.com/roundup"),
        ]
        try validateEditions(editions)
    }

    @Test func invalidMonthFormat() {
        let editions = [
            Edition(month: "2026-4", host: Host(name: "", link: ""), topic: "", roundup: "")
        ]
        #expect(throws: ValidationError.invalidMonthFormat("2026-4")) {
            try validateEditions(editions)
        }
    }

    @Test func invalidMonthValue() {
        let editions = [
            Edition(month: "2026-13", host: Host(name: "", link: ""), topic: "", roundup: "")
        ]
        #expect(throws: ValidationError.invalidMonthFormat("2026-13")) {
            try validateEditions(editions)
        }
    }

    @Test func duplicateMonths() {
        let editions = [
            Edition(month: "2026-04", host: Host(name: "Alice", link: ""), topic: "", roundup: ""),
            Edition(month: "2026-04", host: Host(name: "Bob", link: ""), topic: "", roundup: ""),
        ]
        #expect(throws: ValidationError.duplicateMonth("2026-04")) {
            try validateEditions(editions)
        }
    }

    @Test func notReverseChronological() {
        let editions = [
            Edition(month: "2026-04", host: Host(name: "", link: ""), topic: "", roundup: ""),
            Edition(month: "2026-05", host: Host(name: "", link: ""), topic: "", roundup: ""),
        ]
        #expect(throws: ValidationError.notReverseChrono("2026-04", "2026-05")) {
            try validateEditions(editions)
        }
    }

    @Test func emptyEditionsListIsValid() throws {
        try validateEditions([])
    }
}
