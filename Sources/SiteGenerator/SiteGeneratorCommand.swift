import ArgumentParser
import Foundation
import Html
import SiteGeneratorCore
import Yams

@main
struct SiteGeneratorCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "SiteGenerator",
        abstract: "Swift Blog Carnival site generator",
        subcommands: [ValidateCommand.self, GenerateCommand.self]
    )
}

struct ValidateCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "validate",
        abstract: "Validate editions.yml"
    )

    mutating func run() throws {
        let data = try loadEditions()
        try validateEditions(data.editions)
        print("Validation passed (\(data.editions.count) edition(s))")
    }
}

struct GenerateCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "generate",
        abstract: "Generate the static site and update README"
    )

    mutating func run() throws {
        let data = try loadEditions()
        try validateEditions(data.editions)

        let featuredNode = findFeatured(data.editions).map { renderFeaturedHTML($0) }
        let editionItems = renderEditionList(data.editions)
        let html = render(renderPage(featured: featuredNode, editionItems: editionItems))

        let outputDir = "output"
        try FileManager.default.createDirectory(atPath: outputDir, withIntermediateDirectories: true)
        try html.write(toFile: "\(outputDir)/index.html", atomically: true, encoding: .utf8)

        if FileManager.default.fileExists(atPath: "Resources/static/style.css") {
            try FileManager.default.copyItem(atPath: "Resources/static/style.css", toPath: "\(outputDir)/style.css")
        }

        updateReadme(data.editions)

        print("Generated site in \(outputDir)/")
    }
}

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
