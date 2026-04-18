import Html

public func renderPage(featured: Node?, editionItems: Node) -> Node {
    .document(
        .html(attributes: [.lang(.en)],
            .head(
                .meta(attributes: [.charset(.utf8)]),
                .meta(viewport: .width(.deviceWidth), .initialScale(1)),
                .title("Swift Blog Carnival"),
                .meta(description: "A monthly community blogging event for Swift developers. Volunteer to host, pick a topic, and bring the community together."),
                .link(attributes: [.rel(.stylesheet), .href("style.css")])
            ),
            .body(
                .div(attributes: [.class("page")],

                    .header(
                        .div(attributes: [.class("header__dot"), .ariaHidden(.true)]),
                        .h1(.text("Swift Blog Carnival")),
                        .p(.text("A monthly community blogging event. One host, one topic, everyone writes.")),
                        .p(attributes: [.class("header__detail")], .text("Each month a host picks a topic. You write a post on your own blog, then share the link. The host collects everything into a roundup."))
                    ),

                    .main(
                        .h2(attributes: [.class("section-label")], .text("Current Edition")),
                        featured ?? [],
                        .h2(attributes: [.class("section-label section-label--spaced")], .text("Editions")),
                        editionItems
                    ),

                    renderExampleTopics(),

                    .section(attributes: [.class("volunteer")],
                        .div(
                            .h2(.text("Want to host?")),
                            .p(.text("Pick a month, choose a topic, rally the community."))
                        ),
                        .a(attributes: [
                            .href("https://github.com/SwiftCarnival/swiftcarnival.github.io/issues/new?template=volunteer-to-host.yml"),
                            .class("cta cta--outline"),
                        ], .text("Volunteer"))
                    ),

                    .footer(
                        .span(.text("Swift Blog Carnival")),
                        .a(attributes: [.href("https://github.com/SwiftCarnival/swiftcarnival.github.io")], .text("GitHub"))
                    )
                )
            )
        )
    )
}
