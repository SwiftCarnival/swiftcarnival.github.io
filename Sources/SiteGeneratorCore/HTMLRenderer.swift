import Foundation

public func renderFeaturedHTML(_ edition: Edition) -> String {
    let hostDisplay = edition.host.name.isEmpty ? "TBD" : edition.host.name
    let topicDisplay = edition.topic.isEmpty ? "TBD" : edition.topic

    let hostValue: String
    if !edition.host.link.isEmpty {
        hostValue = "Hosted by <a href=\"\(edition.host.link)\">\(hostDisplay)</a>"
    } else {
        hostValue = "Hosted by \(hostDisplay)"
    }

    let badgeClass: String
    switch edition.status {
    case .upcoming: badgeClass = "badge-upcoming"
    case .open: badgeClass = "badge-open"
    case .published: badgeClass = "badge-published"
    }

    return """
    <div class="featured">
        <span class="featured-month">\(formatMonth(edition.month))</span>
        <span class="featured-detail">\(hostValue)</span>
        <span class="featured-detail">\(topicDisplay)</span>
        <span class="badge \(badgeClass)">\(edition.status.rawValue)</span>
    </div>
    """
}

public func renderTableHTML(_ editions: [Edition]) -> String {
    var items = ""
    for edition in editions {
        let hostDisplay = edition.host.name.isEmpty ? "&mdash;" : edition.host.name
        let topicDisplay = edition.topic.isEmpty ? "" : edition.topic

        let hostHTML: String
        if !edition.host.link.isEmpty {
            hostHTML = "<a href=\"\(edition.host.link)\">\(hostDisplay)</a>"
        } else {
            hostHTML = hostDisplay
        }

        let topicHTML: String
        if !topicDisplay.isEmpty {
            topicHTML = "<span class=\"ed-topic\">\(topicDisplay)</span>"
        } else {
            topicHTML = ""
        }

        let badgeClass: String
        switch edition.status {
        case .upcoming: badgeClass = "badge-upcoming"
        case .open: badgeClass = "badge-open"
        case .published: badgeClass = "badge-published"
        }

        let roundupHTML: String
        if edition.status == .published && !edition.roundup.isEmpty {
            roundupHTML = "<a href=\"\(edition.roundup)\" class=\"roundup-link\">Roundup &rarr;</a>"
        } else {
            roundupHTML = ""
        }

        items += """
            <div class="ed-item">
                <span class="ed-month">\(edition.month)</span>
                <span class="ed-info">\(hostHTML)\(topicHTML)</span>
                <span class="ed-end">\(roundupHTML)<span class="badge \(badgeClass)">\(edition.status.rawValue)</span></span>
            </div>\n
        """
    }

    return items
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
