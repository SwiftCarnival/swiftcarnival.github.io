import ArgumentParser
import SiteGeneratorCore

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
