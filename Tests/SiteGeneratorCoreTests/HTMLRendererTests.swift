import Html
import Testing
@testable import SiteGeneratorCore

func edition(month: String = "2026-04", name: String = "", link: String = "", topic: String = "", status: Edition.Status = .upcoming, announcement: String = "", roundup: String = "") -> Edition {
    Edition(month: month, host: Host(name: name, link: link), topic: topic, status: status, announcement: announcement, roundup: roundup)
}

@Suite struct FeaturedHTMLTests {
    @Test func featuredWithHost() {
        let node = renderFeaturedHTML(edition(month: "2026-05", name: "Alice", link: "https://alice.dev", topic: "Concurrency", status: .open))
        let html = render(node)
        #expect(html.contains("May 2026"))
        #expect(html.contains(#"<a href="https://alice.dev">Alice</a>"#))
        #expect(html.contains("Concurrency"))
        #expect(html.contains("badge--open"))
    }

    @Test func featuredWithEmptyHost() {
        let html = render(renderFeaturedHTML(edition(month: "2026-04", status: .upcoming)))
        #expect(html.contains("TBD"))
        #expect(!html.contains("<a "))
    }

    @Test func featuredShowsAnnouncementWhenOpen() {
        let html = render(renderFeaturedHTML(edition(month: "2026-04", name: "Alice", topic: "Testing", status: .open, announcement: "https://example.com/call")))
        #expect(html.contains("cta--primary"))
        #expect(html.contains("https://example.com/call"))
        #expect(html.contains("See the call for posts"))
    }

    @Test func featuredHidesAnnouncementWhenUpcoming() {
        let html = render(renderFeaturedHTML(edition(month: "2026-04", name: "Alice", status: .upcoming, announcement: "https://example.com/call")))
        #expect(!html.contains("cta--primary"))
    }

    @Test func featuredHidesAnnouncementWhenEmpty() {
        let html = render(renderFeaturedHTML(edition(month: "2026-04", name: "Alice", status: .open)))
        #expect(!html.contains("cta--primary"))
    }
}

@Suite struct TableHTMLTests {
    @Test func tableContainsAllEditions() {
        let editions = [
            edition(month: "2026-05", name: "Alice", topic: "Testing", status: .upcoming),
            edition(month: "2026-04", name: "Bob", link: "https://bob.dev", topic: "SwiftUI", status: .published, roundup: "https://example.com"),
        ]
        let html = renderTableHTML(editions).map { render($0) }.joined()
        #expect(html.contains("May 2026"))
        #expect(html.contains("April 2026"))
        #expect(html.contains("Alice"))
        #expect(html.contains(#"<a href="https://bob.dev">Bob</a>"#))
        #expect(html.contains("badge--upcoming"))
        #expect(html.contains("badge--published"))
    }

    @Test func tableShowsRoundupLink() {
        let html = renderTableHTML([
            edition(month: "2026-04", name: "Bob", topic: "SwiftUI", status: .published, roundup: "https://example.com/roundup"),
        ]).map { render($0) }.joined()
        #expect(html.contains("edition__link--roundup"))
        #expect(html.contains("Read roundup"))
    }

    @Test func tableShowsSubmitLinkWhenOpenWithAnnouncement() {
        let html = renderTableHTML([
            edition(month: "2026-04", name: "Alice", topic: "Testing", status: .open, announcement: "https://example.com/call"),
        ]).map { render($0) }.joined()
        #expect(html.contains("edition__link--submit"))
        #expect(html.contains("Submit post"))
        #expect(html.contains("https://example.com/call"))
    }

    @Test func tableNoSubmitLinkWhenOpenWithoutAnnouncement() {
        let html = renderTableHTML([
            edition(month: "2026-04", name: "Alice", topic: "Testing", status: .open),
        ]).map { render($0) }.joined()
        #expect(!html.contains("edition__link--submit"))
    }

    @Test func tableEmptyHostShowsDash() {
        let html = renderTableHTML([edition(month: "2026-04")]).map { render($0) }.joined()
        #expect(html.contains("&mdash;"))
    }

    @Test func tableShowsTopicWithAriaHidden() {
        let items = renderTableHTML([
            edition(month: "2026-04", name: "Alice", topic: "Concurrency", status: .open),
        ])
        let html = render(items[0])
        #expect(html.contains(#"aria-hidden="true""#))
        #expect(html.contains("Concurrency"))
        #expect(html.contains("edition__topic"))
    }

    @Test func tableUsesFormattedMonths() {
        let html = renderTableHTML([edition(month: "2026-12", name: "Alice")]).map { render($0) }.joined()
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
