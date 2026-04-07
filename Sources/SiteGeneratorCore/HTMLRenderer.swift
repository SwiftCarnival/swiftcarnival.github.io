import Html

extension Node {
    static func ol(attributes: [Attribute<Tag.Ol>] = [], _ content: [ChildOf<Tag.Ol>]) -> Node {
        .element("ol", attributes: attributes, ChildOf<Tag.Ol>.fragment(content).rawValue)
    }
}

func badgeClass(_ status: Edition.Status) -> String {
    switch status {
    case .upcoming: "badge badge--upcoming"
    case .open: "badge badge--open"
    case .published: "badge badge--published"
    }
}

public func renderFeaturedHTML(_ edition: Edition) -> Node {
    let hostDisplay = edition.host.name.isEmpty ? "TBD" : edition.host.name
    let topicDisplay = edition.topic.isEmpty ? "TBD" : edition.topic
    let monthDisplay = formatMonth(edition.month)

    let hostContent: Node = if !edition.host.link.isEmpty {
        "Hosted by \(.a(attributes: [.href(edition.host.link)], .text(hostDisplay)))"
    } else {
        "Hosted by \(hostDisplay)"
    }

    let ctaNode: Node = if edition.status == .open && !edition.announcement.isEmpty {
        .div(attributes: [.class("featured__cta")],
            .a(attributes: [
                .href(edition.announcement),
                .class("cta cta--primary"),
                .ariaLabel("See the call for posts for \(monthDisplay): \(topicDisplay)"),
            ], .text("See the call for posts "), .raw("&rarr;")))
    } else {
        []
    }

    return .article(attributes: [.class("featured")],
        .span(attributes: [.class("featured__month")], .text(monthDisplay)),
        .span(attributes: [.class("featured__host")], hostContent),
        .span(attributes: [.class("featured__topic")], .text(topicDisplay)),
        .span(attributes: [.class(badgeClass(edition.status))], .text(edition.status.rawValue)),
        ctaNode
    )
}

public func renderTableHTML(_ editions: [Edition]) -> Node {
    .ol(attributes: [.class("edition-list"), .reversed(true)], editions.map { edition in
        let hostDisplay = edition.host.name.isEmpty ? "&mdash;" : edition.host.name
        let topicDisplay = edition.topic.isEmpty ? "" : edition.topic
        let monthDisplay = formatMonth(edition.month)

        let hostContent: Node = if !edition.host.link.isEmpty {
            .a(attributes: [.href(edition.host.link)], .text(hostDisplay))
        } else {
            .raw(hostDisplay)
        }

        let topicNode: Node = if !topicDisplay.isEmpty {
            .span(attributes: [.class("edition__topic"), .ariaHidden(.true)], .text(topicDisplay))
        } else {
            []
        }

        let actionNode: Node = if edition.status == .open && !edition.announcement.isEmpty {
            .a(attributes: [
                .href(edition.announcement),
                .class("edition__link edition__link--submit"),
                .ariaLabel("Submit a post for \(monthDisplay): \(topicDisplay)"),
            ], .text("Submit post "), .raw("&rarr;"))
        } else if edition.status == .published && !edition.roundup.isEmpty {
            .a(attributes: [
                .href(edition.roundup),
                .class("edition__link edition__link--roundup"),
                .ariaLabel("Read the roundup for \(monthDisplay): \(topicDisplay)"),
            ], .text("Read roundup "), .raw("&rarr;"))
        } else {
            []
        }

        return .li(attributes: [.class("edition")],
            .span(attributes: [.class("edition__month")], .text(monthDisplay)),
            .span(attributes: [.class("edition__host")], hostContent, topicNode),
            .span(attributes: [.class("edition__actions")], actionNode,
                .span(attributes: [.class(badgeClass(edition.status))], .text(edition.status.rawValue)))
        )
    })
}

public func renderPage(featured: Node?, editionItems: Node) -> Node {
    return .document(
        .html(attributes: [.lang(.en)],
            .head(
                .meta(attributes: [.charset(.utf8)]),
                .meta(viewport: .width(.deviceWidth), .initialScale(1)),
                .title("Swift Blog Carnival"),
                .meta(description: "A monthly community blogging event for Swift developers. Volunteer to host, pick a topic, and bring the community together."),
                .link(attributes: [.rel(.stylesheet), .href("style.css")])
            ),
            .body(
                .div(attributes: [.class("page")],

                    .header(
                        .div(attributes: [.class("header__dot"), .ariaHidden(.true)]),
                        .h1(.text("Swift Blog Carnival")),
                        .p(.text("A monthly community blogging event. One host, one topic, everyone writes.")),
                        .p(attributes: [.class("header__detail")], .text("Each month a host picks a topic. You write a post on your own blog, then share the link. The host collects everything into a roundup."))
                    ),

                    .main(
                        .h2(attributes: [.class("section-label")], .text("Current Edition")),
                        featured ?? [],
                        .h2(attributes: [.class("section-label section-label--spaced")], .text("Editions")),
                        editionItems
                    ),

                    .section(attributes: [.class("volunteer")],
                        .div(
                            .h2(.text("Want to host?")),
                            .p(.text("Pick a month, choose a topic, rally the community."))
                        ),
                        .a(attributes: [
                            .href("https://github.com/SwiftCarnival/swiftcarnival.github.io/issues/new?template=volunteer-to-host.yml"),
                            .class("cta cta--outline"),
                        ], .text("Volunteer"))
                    ),

                    .footer(
                        .span(.text("Swift Blog Carnival")),
                        .a(attributes: [.href("https://github.com/SwiftCarnival/swiftcarnival.github.io")], .text("GitHub"))
                    )
                )
            )
        )
    )
}

public func renderMarkdownTable(_ editions: [Edition]) -> String {
    var lines = [
        "| Month | Host | Topic | Status |",
        "|-------|------|-------|--------|",
    ]

    for edition in editions {
        let hostDisplay = edition.host.name.isEmpty ? "TBD" : edition.host.name
        let topicDisplay = edition.topic.isEmpty ? "TBD" : edition.topic

        let hostCell: String
        if !edition.host.link.isEmpty {
            hostCell = "[\(hostDisplay)](\(edition.host.link))"
        } else {
            hostCell = hostDisplay
        }

        let roundupNote: String
        if edition.status == .published && !edition.roundup.isEmpty {
            roundupNote = " ([roundup](\(edition.roundup)))"
        } else {
            roundupNote = ""
        }

        lines.append("| \(edition.month) | \(hostCell) | \(topicDisplay) | \(edition.status.rawValue)\(roundupNote) |")
    }

    return lines.joined(separator: "\n")
}

public func findFeatured(_ editions: [Edition]) -> Edition? {
    if let open = editions.reversed().first(where: { $0.status == .open }) {
        return open
    }
    if let upcoming = editions.reversed().first(where: { $0.status == .upcoming }) {
        return upcoming
    }
    return editions.first
}

public func formatMonth(_ month: String) -> String {
    let parts = month.split(separator: "-")
    guard parts.count == 2,
          let monthNum = Int(parts[1]) else { return month }

    let names = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ]
    guard monthNum >= 1 && monthNum <= 12 else { return month }
    return "\(names[monthNum - 1]) \(parts[0])"
}
