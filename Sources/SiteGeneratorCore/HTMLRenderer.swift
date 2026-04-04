import Foundation

public func renderFeaturedHTML(_ edition: Edition) -> String {
    let hostDisplay = edition.host.name.isEmpty ? "TBD" : edition.host.name
    let topicDisplay = edition.topic.isEmpty ? "TBD" : edition.topic

    let hostValue: String
    if !edition.host.link.isEmpty {
        hostValue = "<a href=\"\(edition.host.link)\">\(hostDisplay)</a>"
    } else {
        hostValue = hostDisplay
    }

    let badgeClass: String
    switch edition.status {
    case .upcoming: badgeClass = "badge-upcoming"
    case .open: badgeClass = "badge-open"
    case .published: badgeClass = "badge-published"
    }

    return """
    <section class="featured" aria-label="Current Edition">
        <div class="featured-header">
            <span class="featured-label">Current Edition</span>
            <span class="badge \(badgeClass)">\(edition.status.rawValue)</span>
        </div>
        <div class="featured-month">\(formatMonth(edition.month))</div>
        <div class="featured-meta">
            <div class="featured-detail">
                <span class="detail-label">Host</span>
                <span class="detail-value">\(hostValue)</span>
            </div>
            <div class="featured-detail">
                <span class="detail-label">Topic</span>
                <span class="detail-value">\(topicDisplay)</span>
            </div>
        </div>
    </section>
    """
}

public func renderTableHTML(_ editions: [Edition]) -> String {
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

        let badgeClass: String
        switch edition.status {
        case .upcoming: badgeClass = "badge-upcoming"
        case .open: badgeClass = "badge-open"
        case .published: badgeClass = "badge-published"
        }

        let statusCell = "<span class=\"badge \(badgeClass)\">\(edition.status.rawValue)</span>"

        let roundupCell: String
        if edition.status == .published && !edition.roundup.isEmpty {
            roundupCell = "<td class=\"cell-roundup\"><a href=\"\(edition.roundup)\" class=\"roundup-link\">Read roundup &rarr;</a></td>"
        } else {
            roundupCell = "<td class=\"cell-roundup\"></td>"
        }

        rows += """
                <tr>
                    <td class="cell-month">\(edition.month)</td>
                    <td class="cell-host">\(hostCell)</td>
                    <td class="cell-topic">\(topicDisplay)</td>
                    <td class="cell-status">\(statusCell)</td>
                    \(roundupCell)
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
                <th></th>
            </tr>
        </thead>
        <tbody>
    \(rows)    </tbody>
    </table>
    """
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

func formatMonth(_ month: String) -> String {
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
