import Html

extension Node {
    static func ol(attributes: [Attribute<Tag.Ol>] = [], _ content: [ChildOf<Tag.Ol>]) -> Node {
        .element("ol", attributes: attributes, ChildOf<Tag.Ol>.fragment(content).rawValue)
    }
}

extension Edition {
    var formattedMonth: String { formatMonth(month) }
}

extension Edition.Status {
    var badgeClass: String {
        switch self {
        case .upcoming: "badge badge--upcoming"
        case .open: "badge badge--open"
        case .published: "badge badge--published"
        }
    }

    var badgeNode: Node {
        .span(attributes: [.class(badgeClass)], .text(rawValue))
    }
}

extension Host {
    var displayName: String { name.isEmpty ? "TBD" : name }

    func linkNode(rawFallback: String? = nil) -> Node {
        if !link.isEmpty {
            .a(attributes: [.href(link)], .text(rawFallback ?? displayName))
        } else if let rawFallback {
            .raw(rawFallback)
        } else {
            .text(displayName)
        }
    }
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
