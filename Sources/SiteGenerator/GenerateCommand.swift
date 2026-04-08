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

        let cssSource = "Resources/static/style.css"
        let cssDest = "\(outputDir)/style.css"
        if FileManager.default.fileExists(atPath: cssSource) {
            try? FileManager.default.removeItem(atPath: cssDest)
            try FileManager.default.copyItem(atPath: cssSource, toPath: cssDest)
        }

        updateReadme(data.editions)

        print("Generated site in \(outputDir)/")
    }
}
