import ArgumentParser
import Foundation
import Html
import SiteGeneratorCore

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
