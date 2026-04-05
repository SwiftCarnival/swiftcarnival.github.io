import Testing
@testable import SiteGeneratorCore

func edition(month: String = "2026-04", name: String = "", link: String = "", topic: String = "", status: Edition.Status = .upcoming, announcement: String = "", roundup: String = "") -> Edition {
    Edition(month: month, host: Host(name: name, link: link), topic: topic, status: status, announcement: announcement, roundup: roundup)
}

@Suite struct FeaturedHTMLTests {
    @Test func featuredWithHost() {
        let e = edition(month: "2026-05", name: "Alice", link: "https://alice.dev", topic: "Concurrency", status: .open)
        let html = renderFeaturedHTML(e)
        #expect(html.contains("May 2026"))
        #expect(html.contains("<a href=\"https://alice.dev\">Alice</a>"))
        #expect(html.contains("Concurrency"))
        #expect(html.contains("badge-open"))
    }

    @Test func featuredWithEmptyHost() {
        let e = edition(month: "2026-04", status: .upcoming)
        let html = renderFeaturedHTML(e)
        #expect(html.contains("TBD"))
        #expect(!html.contains("<a href"))
    }

    @Test func featuredShowsAnnouncementWhenOpen() {
        let e = edition(month: "2026-04", name: "Alice", topic: "Testing", status: .open, announcement: "https://example.com/call")
        let html = renderFeaturedHTML(e)
        #expect(html.contains("announcement-link"))
        #expect(html.contains("https://example.com/call"))
        #expect(html.contains("See the call for posts"))
    }

    @Test func featuredHidesAnnouncementWhenUpcoming() {
        let e = edition(month: "2026-04", name: "Alice", status: .upcoming, announcement: "https://example.com/call")
        let html = renderFeaturedHTML(e)
        #expect(!html.contains("announcement-link"))
    }

    @Test func featuredHidesAnnouncementWhenEmpty() {
        let e = edition(month: "2026-04", name: "Alice", status: .open)
        let html = renderFeaturedHTML(e)
        #expect(!html.contains("announcement-link"))
    }
}

@Suite struct TableHTMLTests {
    @Test func tableContainsAllEditions() {
        let editions = [
            edition(month: "2026-05", name: "Alice", topic: "Testing", status: .upcoming),
            edition(month: "2026-04", name: "Bob", link: "https://bob.dev", topic: "SwiftUI", status: .published, roundup: "https://example.com"),
        ]
        let html = renderTableHTML(editions)
        #expect(html.contains("May 2026"))
        #expect(html.contains("April 2026"))
        #expect(html.contains("Alice"))
        #expect(html.contains("<a href=\"https://bob.dev\">Bob</a>"))
        #expect(html.contains("badge-upcoming"))
        #expect(html.contains("badge-published"))
    }

    @Test func tableShowsRoundupLink() {
        let editions = [
            edition(month: "2026-04", name: "Bob", topic: "SwiftUI", status: .published, roundup: "https://example.com/roundup"),
        ]
        let html = renderTableHTML(editions)
        #expect(html.contains("roundup-link"))
        #expect(html.contains("Read roundup"))
    }

    @Test func tableShowsSubmitLinkWhenOpenWithAnnouncement() {
        let editions = [
            edition(month: "2026-04", name: "Alice", topic: "Testing", status: .open, announcement: "https://example.com/call"),
        ]
        let html = renderTableHTML(editions)
        #expect(html.contains("submit-link"))
        #expect(html.contains("Submit post"))
        #expect(html.contains("https://example.com/call"))
    }

    @Test func tableNoSubmitLinkWhenOpenWithoutAnnouncement() {
        let editions = [
            edition(month: "2026-04", name: "Alice", topic: "Testing", status: .open),
        ]
        let html = renderTableHTML(editions)
        #expect(!html.contains("submit-link"))
    }

    @Test func tableEmptyHostShowsDash() {
        let editions = [edition(month: "2026-04")]
        let html = renderTableHTML(editions)
        #expect(html.contains("&mdash;"))
    }

    @Test func tableShowsTopicWithAriaHidden() {
        let editions = [
            edition(month: "2026-04", name: "Alice", topic: "Concurrency", status: .open),
        ]
        let html = renderTableHTML(editions)
        #expect(html.contains("<span class=\"ed-topic\" aria-hidden=\"true\">Concurrency</span>"))
    }

    @Test func tableUsesFormattedMonths() {
        let editions = [edition(month: "2026-12", name: "Alice")]
        let html = renderTableHTML(editions)
        #expect(html.contains("December 2026"))
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
            edition(month: "2026-05", name: "Alice", link: "https://alice.dev", topic: "Concurrency", status: .open),
            edition(month: "2026-04", name: "Bob", topic: "SwiftUI", status: .published, roundup: "https://example.com/roundup"),
        ]
        let md = renderMarkdownTable(editions)
        #expect(md.contains("[Alice](https://alice.dev)"))
        #expect(md.contains("| Bob |"))
        #expect(md.contains("[roundup](https://example.com/roundup)"))
    }

    @Test func markdownTableEmptyHostShowsTBD() {
        let editions = [edition(month: "2026-04")]
        let md = renderMarkdownTable(editions)
        #expect(md.contains("| TBD | TBD |"))
    }
}

@Suite struct FindFeaturedTests {
    @Test func prefersOpenOverUpcoming() {
        let editions = [
            edition(month: "2026-06", status: .upcoming),
            edition(month: "2026-05", name: "Alice", topic: "Testing", status: .open),
            edition(month: "2026-04", status: .published, roundup: "https://example.com"),
        ]
        #expect(findFeatured(editions)?.month == "2026-05")
    }

    @Test func fallsBackToUpcoming() {
        let editions = [
            edition(month: "2026-06", status: .upcoming),
            edition(month: "2026-04", status: .published, roundup: "https://example.com"),
        ]
        #expect(findFeatured(editions)?.month == "2026-06")
    }

    @Test func fallsBackToFirst() {
        let editions = [
            edition(month: "2026-04", status: .published, roundup: "https://example.com"),
        ]
        #expect(findFeatured(editions)?.month == "2026-04")
    }

    @Test func emptyReturnsNil() {
        #expect(findFeatured([]) == nil)
    }
}
