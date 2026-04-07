import Html

public func renderTableHTML(_ editions: [Edition]) -> Node {
    .ol(attributes: [.class("edition-list"), .reversed(true)], editions.map { edition in
        let topicNode: Node = if !edition.topic.isEmpty {
            .span(attributes: [.class("edition__topic"), .ariaHidden(.true)], .text(edition.topic))
        } else {
            []
        }

        let actionNode: Node = if edition.status == .open && !edition.announcement.isEmpty {
            .a(attributes: [
                .href(edition.announcement),
                .class("edition__link edition__link--submit"),
                .ariaLabel("Submit a post for \(edition.formattedMonth): \(edition.topic)"),
            ], .text("Submit post "), .raw("&rarr;"))
        } else if edition.status == .published && !edition.roundup.isEmpty {
            .a(attributes: [
                .href(edition.roundup),
                .class("edition__link edition__link--roundup"),
                .ariaLabel("Read the roundup for \(edition.formattedMonth): \(edition.topic)"),
            ], .text("Read roundup "), .raw("&rarr;"))
        } else {
            []
        }

        return .li(attributes: [.class("edition")],
            .span(attributes: [.class("edition__month")], .text(edition.formattedMonth)),
            .span(attributes: [.class("edition__host")],
                edition.host.linkNode(rawFallback: edition.host.name.isEmpty ? "&mdash;" : nil),
                topicNode),
            .span(attributes: [.class("edition__actions")], actionNode, edition.status.badgeNode)
        )
    })
}

public func renderMarkdownTable(_ editions: [Edition]) -> String {
    var lines = [
        "| Month | Host | Topic | Status |",
        "|-------|------|-------|--------|",
    ]

    for edition in editions {
        let hostCell: String = if !edition.host.link.isEmpty {
            "[\(edition.host.displayName)](\(edition.host.link))"
        } else {
            edition.host.displayName
        }

        let topicDisplay = edition.topic.isEmpty ? "TBD" : edition.topic

        let roundupNote: String = if edition.status == .published && !edition.roundup.isEmpty {
            " ([roundup](\(edition.roundup)))"
        } else {
            ""
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
