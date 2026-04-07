public struct Host: Codable, Sendable {
    public var name: String
    public var link: String

    public init(name: String, link: String) {
        self.name = name
        self.link = link
    }
}
