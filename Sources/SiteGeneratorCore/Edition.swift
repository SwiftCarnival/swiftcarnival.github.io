import Html

public struct Edition: Codable, Sendable {
    public var month: String
    public var host: Host
    public var topic: String
    public var announcement: String
    public var roundup: String

    public enum Status: String, Sendable {
        case upcoming
        case open
        case published
    }

    public var status: Status {
        if !roundup.isEmpty { return .published }
        if !announcement.isEmpty { return .open }
        return .upcoming
    }

    public init(month: String, host: Host, topic: String, announcement: String = "", roundup: String) {
        self.month = month
        self.host = host
        self.topic = topic
        self.announcement = announcement
        self.roundup = roundup
    }

    private enum CodingKeys: String, CodingKey {
        case month, host, topic, announcement, roundup
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

public struct EditionsFile: Codable, Sendable {
    public var editions: [Edition]

    public init(editions: [Edition]) {
        self.editions = editions
    }
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
