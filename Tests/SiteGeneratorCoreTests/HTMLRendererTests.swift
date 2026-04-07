import Html
import Testing
@testable import SiteGeneratorCore

func edition(month: String = "2026-04", name: String = "", link: String = "", topic: String = "", status: Edition.Status = .upcoming, announcement: String = "", roundup: String = "") -> Edition {
    Edition(month: month, host: Host(name: name, link: link), topic: topic, status: status, announcement: announcement, roundup: roundup)
}

@Suite struct FeaturedHTMLTests {
    @Test func featuredWithHost() {
        let html = render(renderFeaturedHTML(edition(month: "2026-05", name: "Alice", link: "https://alice.dev", topic: "Concurrency", status: .open)))
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
        let html = render(renderTableHTML([
            edition(month: "2026-05", name: "Alice", topic: "Testing", status: .upcoming),
            edition(month: "2026-04", name: "Bob", link: "https://bob.dev", topic: "SwiftUI", status: .published, roundup: "https://example.com"),
        ]))
        #expect(html.contains("May 2026"))
        #expect(html.contains("April 2026"))
        #expect(html.contains("Alice"))
        #expect(html.contains(#"<a href="https://bob.dev">Bob</a>"#))
        #expect(html.contains("badge--upcoming"))
        #expect(html.contains("badge--published"))
    }

    @Test func tableShowsRoundupLink() {
        let html = render(renderTableHTML([
            edition(month: "2026-04", name: "Bob", topic: "SwiftUI", status: .published, roundup: "https://example.com/roundup"),
        ]))
        #expect(html.contains("edition__link--roundup"))
        #expect(html.contains("Read roundup"))
    }

    @Test func tableShowsSubmitLinkWhenOpenWithAnnouncement() {
        let html = render(renderTableHTML([
            edition(month: "2026-04", name: "Alice", topic: "Testing", status: .open, announcement: "https://example.com/call"),
        ]))
        #expect(html.contains("edition__link--submit"))
        #expect(html.contains("Submit post"))
        #expect(html.contains("https://example.com/call"))
    }

    @Test func tableNoSubmitLinkWhenOpenWithoutAnnouncement() {
        let html = render(renderTableHTML([
            edition(month: "2026-04", name: "Alice", topic: "Testing", status: .open),
        ]))
        #expect(!html.contains("edition__link--submit"))
    }

    @Test func tableEmptyHostShowsDash() {
        let html = render(renderTableHTML([edition(month: "2026-04")]))
        #expect(html.contains("&mdash;"))
    }

    @Test func tableShowsTopicWithAriaHidden() {
        let html = render(renderTableHTML([
            edition(month: "2026-04", name: "Alice", topic: "Concurrency", status: .open),
        ]))
        #expect(html.contains(#"aria-hidden="true""#))
        #expect(html.contains("Concurrency"))
        #expect(html.contains("edition__topic"))
    }

    @Test func tableUsesFormattedMonths() {
        let html = render(renderTableHTML([edition(month: "2026-12", name: "Alice")]))
        #expect(html.contains("December 2026"))
    }

    @Test func tableWrappedInReversedOl() {
        let html = render(renderTableHTML([edition(month: "2026-04")]))
        #expect(html.contains("<ol"))
        #expect(html.contains("edition-list"))
        #expect(html.contains("reversed"))
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

@Suite struct PageHTMLTests {
    @Test func pageContainsDoctype() {
        let html = render(renderPage(featured: nil, editionItems: []))
        #expect(html.hasPrefix("<!DOCTYPE html>"))
    }

    @Test func pageContainsStructure() {
        let html = render(renderPage(featured: nil, editionItems: []))
        #expect(html.contains("Swift Blog Carnival"))
        #expect(html.contains("section-label"))
        #expect(html.contains("volunteer"))
        #expect(html.contains("cta--outline"))
        #expect(html.contains(#"lang="en""#))
    }
}
