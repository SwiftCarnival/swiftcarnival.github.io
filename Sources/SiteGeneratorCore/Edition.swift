public struct Edition: Codable, Sendable {
    public var month: String
    public var host: Host
    public var topic: String
    public var status: Status
    public var announcement: String
    public var roundup: String

    public enum Status: String, Codable, Sendable {
        case upcoming
        case open
        case published
    }

    public init(month: String, host: Host, topic: String, status: Status, announcement: String = "", roundup: String) {
        self.month = month
        self.host = host
        self.topic = topic
        self.status = status
        self.announcement = announcement
        self.roundup = roundup
    }
}

public struct EditionsFile: Codable, Sendable {
    public var editions: [Edition]

    public init(editions: [Edition]) {
        self.editions = editions
    }
}
