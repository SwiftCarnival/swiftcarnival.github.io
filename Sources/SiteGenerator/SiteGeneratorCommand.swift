import ArgumentParser

@main
struct SiteGeneratorCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "SiteGenerator",
        abstract: "Swift Blog Carnival site generator",
        subcommands: [ValidateCommand.self, GenerateCommand.self]
    )
}
