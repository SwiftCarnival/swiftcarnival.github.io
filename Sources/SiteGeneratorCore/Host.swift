import Html

public struct Host: Codable, Sendable {
    public var name: String
    public var link: String

    public init(name: String, link: String) {
        self.name = name
        self.link = link
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
