# Swift Blog Carnival

A monthly community blogging event for Swift developers. Each month, a volunteer host picks a topic, the community writes blog posts, and the host publishes a roundup.

**Website:** [swiftcarnival.github.io](https://swiftcarnival.github.io)

## Editions

<!-- EDITIONS:START -->
| Month | Host | Topic | Status |
|-------|------|-------|--------|
| 2026-04 | [Christian Tietze](https://christiantietze.de) | Tiny Languages | open ([announcement](https://christiantietze.de/posts/2026/04/swift-blog-carnival-tiny-languages/)) |
<!-- EDITIONS:END -->

## How It Works

One issue per edition. Open it once, edit it as you go.

1. **Claim a month:** [Open an issue](https://github.com/SwiftCarnival/swiftcarnival.github.io/issues/new?template=host-edition.yml) with your month, name, and topic. A maintainer approves you once.
2. **Announce:** Write your call for posts on your blog. Edit the issue and paste the announcement URL — the site marks your edition as **open** automatically.
3. **Publish the roundup:** At month's end, publish a roundup post on your blog. Edit the issue and paste the roundup URL — the site marks the edition as **published** and the issue closes.

## Example Topics

Need a topic? These are open for any host to pick up and make their own:

- **Swift's type system as a design tool** — how types shape the way you design software.
- **Little languages** — Swift is full of tiny languages hiding in plain sight: result builders, key paths, regex literals. Write about a DSL you built, one you use daily, or one you wish existed.
- **The archaeology of Swift** — dig into an Evolution proposal that surprised you, a feature that arrived differently than pitched, or a design decision whose rationale is buried in mailing list threads.
- **Hidden in plain sight** — a Swift feature, API, or pattern you use in a way its designers probably didn't intend.
- **What Objective-C taught Swift (and what Swift forgot)** — runtime dynamism trade-offs, message sending, and what got lost in translation.
- **Swift outside Xcode** — on servers, on Linux, in Docker, as scripting glue, on embedded devices. Where does Swift thrive off Apple's golden path, and where does it stumble?
- **Living with Swift concurrency** — it's been a few years now. War stories, patterns that clicked late, mental models that helped, things you still avoid.
- **Code that writes code** — macros, build plugins, Sourcery, gyb, or clever use of generics to avoid repetition. When does metaprogramming earn its keep?
- **Plain-text workflows powered by Swift** — Swift as a tool for your plain-text life: scripts, CLI utilities, text processing, automation. What made you reach for it instead of Python or Bash?
- **Under the hood** — what happens below the abstraction layer you normally work at? Memory layout, SIL, the runtime, ARC internals, witness tables. Pick something you looked into and explain what you found.
- **Cross-pollination** — take a concept from another language and show how it maps onto idiomatic Swift — and where the analogy breaks.
- **The 50-line challenge** — build something genuinely useful in 50 lines or fewer of Swift.
- **The app I never shipped** — a project that taught you something important even though it never saw the light of day.
- **Boundaries** — where do you draw the lines in your Swift code? Between modules, layers, your code and someone else's framework. How do you decide what gets an abstraction?
- **Explaining Swift to a ___** — a Rust developer, a teenager, a product manager, your past self. What do you emphasize, what do you skip, and what do you realize about Swift only when you try to explain it?

## Building the Site Locally

```
swift run SiteGenerator validate
swift run SiteGenerator generate
open output/index.html
```

## License

[CC-BY-4.0](LICENSE)
