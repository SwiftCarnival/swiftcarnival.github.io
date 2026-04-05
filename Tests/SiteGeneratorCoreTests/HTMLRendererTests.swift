import Testing
@testable import SiteGeneratorCore

@Suite struct FeaturedHTMLTests {
    @Test func featuredWithHost() {
        let edition = Edition(month: "2026-05", host: Host(name: "Alice", link: "https://alice.dev"), topic: "Concurrency", status: .open, roundup: "")
        let html = renderFeaturedHTML(edition)
        #expect(html.contains("May 2026"))
        #expect(html.contains("<a href=\"https://alice.dev\">Alice</a>"))
        #expect(html.contains("Concurrency"))
        #expect(html.contains("badge-open"))
    }

    @Test func featuredWithEmptyHost() {
        let edition = Edition(month: "2026-04", host: Host(name: "", link: ""), topic: "", status: .upcoming, roundup: "")
        let html = renderFeaturedHTML(edition)
        #expect(html.contains("TBD"))
        #expect(!html.contains("<a href"))
    }
}

@Suite struct TableHTMLTests {
    @Test func tableContainsAllEditions() {
        let editions = [
            Edition(month: "2026-05", host: Host(name: "Alice", link: ""), topic: "Testing", status: .upcoming, roundup: ""),
            Edition(month: "2026-04", host: Host(name: "Bob", link: "https://bob.dev"), topic: "SwiftUI", status: .published, roundup: "https://example.com"),
        ]
        let html = renderTableHTML(editions)
        #expect(html.contains("2026-05"))
        #expect(html.contains("2026-04"))
        #expect(html.contains("Alice"))
        #expect(html.contains("<a href=\"https://bob.dev\">Bob</a>"))
        #expect(html.contains("badge-upcoming"))
        #expect(html.contains("badge-published"))
    }

    @Test func tableShowsRoundupLink() {
        let editions = [
            Edition(month: "2026-04", host: Host(name: "Bob", link: ""), topic: "SwiftUI", status: .published, roundup: "https://example.com/roundup"),
        ]
        let html = renderTableHTML(editions)
        #expect(html.contains("roundup-link"))
        #expect(html.contains("https://example.com/roundup"))
    }

    @Test func tableEmptyHostShowsDash() {
        let editions = [
            Edition(month: "2026-04", host: Host(name: "", link: ""), topic: "", status: .upcoming, roundup: ""),
        ]
        let html = renderTableHTML(editions)
        #expect(html.contains("&mdash;"))
    }

    @Test func tableShowsTopicInSpan() {
        let editions = [
            Edition(month: "2026-04", host: Host(name: "Alice", link: ""), topic: "Concurrency", status: .open, roundup: ""),
        ]
        let html = renderTableHTML(editions)
        #expect(html.contains("<span class=\"ed-topic\">Concurrency</span>"))
    }
}

@Suite struct MarkdownTableTests {
    @Test func markdownTableHeader() {
        let md = renderMarkdownTable([])
        #expect(md.contains("| Month | Host | Topic | Status |"))
        #expect(md.contains("|-------|------|-------|--------|"))
    }

    @Test func markdownTableWithEditions() {
        let editions = [
            Edition(month: "2026-05", host: Host(name: "Alice", link: "https://alice.dev"), topic: "Concurrency", status: .open, roundup: ""),
            Edition(month: "2026-04", host: Host(name: "Bob", link: ""), topic: "SwiftUI", status: .published, roundup: "https://example.com/roundup"),
        ]
        let md = renderMarkdownTable(editions)
        #expect(md.contains("[Alice](https://alice.dev)"))
        #expect(md.contains("| Bob |"))
        #expect(md.contains("[roundup](https://example.com/roundup)"))
    }

    @Test func markdownTableEmptyHostShowsTBD() {
        let editions = [
            Edition(month: "2026-04", host: Host(name: "", link: ""), topic: "", status: .upcoming, roundup: "")
        ]
        let md = renderMarkdownTable(editions)
        #expect(md.contains("| TBD | TBD |"))
    }
}

@Suite struct FindFeaturedTests {
    @Test func prefersOpenOverUpcoming() {
        let editions = [
            Edition(month: "2026-06", host: Host(name: "", link: ""), topic: "", status: .upcoming, roundup: ""),
            Edition(month: "2026-05", host: Host(name: "Alice", link: ""), topic: "Testing", status: .open, roundup: ""),
            Edition(month: "2026-04", host: Host(name: "", link: ""), topic: "", status: .published, roundup: "https://example.com"),
        ]
        let featured = findFeatured(editions)
        #expect(featured?.month == "2026-05")
    }

    @Test func fallsBackToUpcoming() {
        let editions = [
            Edition(month: "2026-06", host: Host(name: "", link: ""), topic: "", status: .upcoming, roundup: ""),
            Edition(month: "2026-04", host: Host(name: "", link: ""), topic: "", status: .published, roundup: "https://example.com"),
        ]
        let featured = findFeatured(editions)
        #expect(featured?.month == "2026-06")
    }

    @Test func fallsBackToFirst() {
        let editions = [
            Edition(month: "2026-04", host: Host(name: "", link: ""), topic: "", status: .published, roundup: "https://example.com"),
        ]
        let featured = findFeatured(editions)
        #expect(featured?.month == "2026-04")
    }

    @Test func emptyReturnsNil() {
        #expect(findFeatured([]) == nil)
    }
}
