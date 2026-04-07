import Html

public func renderFeaturedHTML(_ edition: Edition) -> Node {
    let hostContent: Node = if !edition.host.link.isEmpty {
        "Hosted by \(.a(attributes: [.href(edition.host.link)], .text(edition.host.displayName)))"
    } else {
        "Hosted by \(edition.host.displayName)"
    }

    let topicDisplay = edition.topic.isEmpty ? "TBD" : edition.topic

    let ctaNode: Node = if edition.status == .open && !edition.announcement.isEmpty {
        .div(attributes: [.class("featured__cta")],
            .a(attributes: [
                .href(edition.announcement),
                .class("cta cta--primary"),
                .ariaLabel("See the call for posts for \(edition.formattedMonth): \(topicDisplay)"),
            ], .text("See the call for posts "), .raw("&rarr;")))
    } else {
        []
    }

    return .article(attributes: [.class("featured")],
        .span(attributes: [.class("featured__month")], .text(edition.formattedMonth)),
        .span(attributes: [.class("featured__host")], hostContent),
        .span(attributes: [.class("featured__topic")], .text(topicDisplay)),
        edition.status.badgeNode,
        ctaNode
    )
}
