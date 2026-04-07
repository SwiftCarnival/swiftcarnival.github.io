import Html

public func renderEditionList(_ editions: [Edition]) -> Node {
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

