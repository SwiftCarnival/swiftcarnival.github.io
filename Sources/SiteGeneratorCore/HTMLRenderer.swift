import Html

public func renderFeaturedHTML(_ edition: Edition) -> Node {
    let hostDisplay = edition.host.name.isEmpty ? "TBD" : edition.host.name
    let topicDisplay = edition.topic.isEmpty ? "TBD" : edition.topic
    let monthDisplay = formatMonth(edition.month)

    let hostContent: Node
    if !edition.host.link.isEmpty {
        hostContent = .fragment([
            .text("Hosted by "),
            .a(attributes: [.href(edition.host.link)], .text(hostDisplay)),
        ])
    } else {
        hostContent = .text("Hosted by \(hostDisplay)")
    }

    let badgeClass = "badge \(badgeModifier(edition.status))"

    var children: [Node] = [
        .span(attributes: [.class("featured__month")], .text(monthDisplay)),
        .span(attributes: [.class("featured__host")], hostContent),
        .span(attributes: [.class("featured__topic")], .text(topicDisplay)),
        .span(attributes: [.class(badgeClass)], .text(edition.status.rawValue)),
    ]

    if edition.status == .open && !edition.announcement.isEmpty {
        children.append(
            .div(attributes: [.class("featured__cta")],
                .a(attributes: [
                    .href(edition.announcement),
                    .class("cta cta--primary"),
                    .ariaLabel("See the call for posts for \(monthDisplay): \(topicDisplay)"),
                ], .text("See the call for posts "), .raw("&rarr;"))
            )
        )
    }

    return .article(attributes: [.class("featured")], .fragment(children))
}

public func renderTableHTML(_ editions: [Edition]) -> [ChildOf<Tag.Ol>] {
    editions.map { edition in
        let hostDisplay = edition.host.name.isEmpty ? "&mdash;" : edition.host.name
        let topicDisplay = edition.topic.isEmpty ? "" : edition.topic
        let monthDisplay = formatMonth(edition.month)

        let hostContent: Node
        if !edition.host.link.isEmpty {
            hostContent = .a(attributes: [.href(edition.host.link)], .text(hostDisplay))
        } else {
            hostContent = .raw(hostDisplay)
        }

        let topicNode: Node
        if !topicDisplay.isEmpty {
            topicNode = .span(attributes: [.class("edition__topic"), .ariaHidden(.true)], .text(topicDisplay))
        } else {
            topicNode = .fragment([])
        }

        let badgeClass = "badge \(badgeModifier(edition.status))"

        let actionNode: Node
        if edition.status == .open && !edition.announcement.isEmpty {
            actionNode = .a(attributes: [
                .href(edition.announcement),
                .class("edition__link edition__link--submit"),
                .ariaLabel("Submit a post for \(monthDisplay): \(topicDisplay)"),
            ], .text("Submit post "), .raw("&rarr;"))
        } else if edition.status == .published && !edition.roundup.isEmpty {
            actionNode = .a(attributes: [
                .href(edition.roundup),
                .class("edition__link edition__link--roundup"),
                .ariaLabel("Read the roundup for \(monthDisplay): \(topicDisplay)"),
            ], .text("Read roundup "), .raw("&rarr;"))
        } else {
            actionNode = .fragment([])
        }

        return ChildOf<Tag.Ol>.li(attributes: [.class("edition")],
            .span(attributes: [.class("edition__month")], .text(monthDisplay)),
            .span(attributes: [.class("edition__host")], hostContent, topicNode),
            .span(attributes: [.class("edition__actions")], actionNode,
                .span(attributes: [.class(badgeClass)], .text(edition.status.rawValue)))
        )
    }
}

func badgeModifier(_ status: Edition.Status) -> String {
    switch status {
    case .upcoming: "badge--upcoming"
    case .open: "badge--open"
    case .published: "badge--published"
    }
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
