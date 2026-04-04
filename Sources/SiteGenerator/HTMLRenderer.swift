import Foundation

func renderFeaturedHTML(_ edition: Edition) -> String {
    let hostDisplay = edition.host.name.isEmpty ? "TBD" : edition.host.name
    let topicDisplay = edition.topic.isEmpty ? "TBD" : edition.topic

    let hostLink: String
    if !edition.host.link.isEmpty {
        hostLink = "<a href=\"\(edition.host.link)\">\(hostDisplay)</a>"
    } else {
        hostLink = hostDisplay
    }

    return """
    <section class="featured">
        <span class="badge">\(edition.status.rawValue)</span>
        <h2>\(edition.month)</h2>
        <p class="host">Host: \(hostLink)</p>
        <p class="topic">Topic: \(topicDisplay)</p>
    </section>
    """
}

func renderTableHTML(_ editions: [Edition]) -> String {
    var rows = ""
    for edition in editions {
        let hostDisplay = edition.host.name.isEmpty ? "TBD" : edition.host.name
        let topicDisplay = edition.topic.isEmpty ? "TBD" : edition.topic

        let hostCell: String
        if !edition.host.link.isEmpty {
            hostCell = "<a href=\"\(edition.host.link)\">\(hostDisplay)</a>"
        } else {
            hostCell = hostDisplay
        }

        let statusCell = "<span class=\"status-\(edition.status.rawValue)\">\(edition.status.rawValue)</span>"

        rows += """
                <tr>
                    <td>\(edition.month)</td>
                    <td>\(hostCell)</td>
                    <td>\(topicDisplay)</td>
                    <td>\(statusCell)</td>
                </tr>\n
        """
    }

    return """
    <table>
        <thead>
            <tr>
                <th>Month</th>
                <th>Host</th>
                <th>Topic</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
    \(rows)    </tbody>
    </table>
    """
}

func renderMarkdownTable(_ editions: [Edition]) -> String {
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

func findFeatured(_ editions: [Edition]) -> Edition? {
    if let open = editions.reversed().first(where: { $0.status == .open }) {
        return open
    }
    if let upcoming = editions.reversed().first(where: { $0.status == .upcoming }) {
        return upcoming
    }
    return editions.first
}
