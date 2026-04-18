import Html

public func renderExampleTopics() -> Node {
    .section(attributes: [.class("topics")],
        .h2(attributes: [.class("section-label")], .text("Example Topics")),
        .p(attributes: [.class("topics__intro")],
            .text("Need inspiration? These prompts are open for any host to pick up and make their own.")),
        .ul(attributes: [.class("topics__list")],
            .li(attributes: [.class("topics__item")],
                .strong(attributes: [.class("topics__title")], .text("Swift\u{2019}s type system as a design tool")),
                .p(attributes: [.class("topics__desc")], .text("How to encode business rules directly into types so invalid states become uncompilable, not just untested."))
            ),
            .li(attributes: [.class("topics__item")],
                .strong(attributes: [.class("topics__title")], .text("Building a tiny language in Swift")),
                .p(attributes: [.class("topics__desc")], .text("Write a parser and interpreter for a domain-specific language using enums, indirect cases, and pattern matching."))
            ),
            .li(attributes: [.class("topics__item")],
                .strong(attributes: [.class("topics__title")], .text("The archaeology of a Swift Evolution proposal")),
                .p(attributes: [.class("topics__desc")], .text("Pick one accepted SE proposal and trace it from pitch through review to implementation, showing how the language sausage gets made."))
            ),
            .li(attributes: [.class("topics__item")],
                .strong(attributes: [.class("topics__title")], .text("Property wrappers beyond @State")),
                .p(attributes: [.class("topics__desc")], .text("Unusual and creative uses like validated inputs, feature flags, or lazy-logged properties."))
            ),
            .li(attributes: [.class("topics__item")],
                .strong(attributes: [.class("topics__title")], .text("What Objective-C taught Swift (and what Swift forgot)")),
                .p(attributes: [.class("topics__desc")], .text("An honest look at runtime dynamism trade-offs, message sending, and what got lost in translation."))
            ),
            .li(attributes: [.class("topics__item")],
                .strong(attributes: [.class("topics__title")], .text("Swift on the server in 2026: an honest field report")),
                .p(attributes: [.class("topics__desc")], .text("Real production pain points, deployment stories, and where Vapor/Hummingbird actually shine vs. where you\u{2019}d still reach for something else."))
            ),
            .li(attributes: [.class("topics__item")],
                .strong(attributes: [.class("topics__title")], .text("Concurrency patterns that aren\u{2019}t in the docs")),
                .p(attributes: [.class("topics__desc")], .text("Practical actor reentrancy pitfalls, TaskGroup choreography, and structured concurrency patterns that only emerge in real codebases."))
            ),
            .li(attributes: [.class("topics__item")],
                .strong(attributes: [.class("topics__title")], .text("Macro-driven code generation")),
                .p(attributes: [.class("topics__desc")], .text("Building a Swift macro from scratch and reflecting on when metaprogramming helps vs. when it just confuses your future self."))
            ),
            .li(attributes: [.class("topics__item")],
                .strong(attributes: [.class("topics__title")], .text("Plain-text workflows powered by Swift")),
                .p(attributes: [.class("topics__desc")], .text("Writing CLI tools, text parsers, or Markdown processors in Swift for personal productivity pipelines."))
            ),
            .li(attributes: [.class("topics__item")],
                .strong(attributes: [.class("topics__title")], .text("A visual guide to Swift\u{2019}s memory layout")),
                .p(attributes: [.class("topics__desc")], .text("Illustrating how structs, classes, enums, and existentials actually sit in memory, with diagrams that make ARC and copy-on-write click."))
            ),
            .li(attributes: [.class("topics__item")],
                .strong(attributes: [.class("topics__title")], .text("Cross-pollination: one concept stolen from another language")),
                .p(attributes: [.class("topics__desc")], .text("Take a pattern from Rust, Haskell, or Kotlin and show how it maps onto idiomatic Swift \u{2014} and where the analogy breaks."))
            ),
            .li(attributes: [.class("topics__item")],
                .strong(attributes: [.class("topics__title")], .text("The 50-line challenge")),
                .p(attributes: [.class("topics__desc")], .text("Build something genuinely useful in 50 lines or fewer of Swift, proving that the language can be concise when you let it breathe."))
            )
        )
    )
}
