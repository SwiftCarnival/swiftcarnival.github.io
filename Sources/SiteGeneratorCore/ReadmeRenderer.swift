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
