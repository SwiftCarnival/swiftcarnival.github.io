import Foundation
import SiteGeneratorCore
import Yams

func loadEditions() throws -> EditionsFile {
    let yaml = try String(contentsOfFile: "data/editions.yml", encoding: .utf8)
    let decoder = YAMLDecoder()
    return try decoder.decode(EditionsFile.self, from: yaml)
}

func updateReadme(_ editions: [Edition]) {
    let readmePath = "README.md"
    guard var content = try? String(contentsOfFile: readmePath, encoding: .utf8) else { return }

    let startMarker = "<!-- EDITIONS:START -->"
    let endMarker = "<!-- EDITIONS:END -->"

    guard let startRange = content.range(of: startMarker),
          let endRange = content.range(of: endMarker) else { return }

    let table = renderMarkdownTable(editions)
    let replacement = "\(startMarker)\n\(table)\n\(endMarker)"
    content.replaceSubrange(startRange.lowerBound..<endRange.upperBound, with: replacement)

    try? content.write(toFile: readmePath, atomically: true, encoding: .utf8)
}
