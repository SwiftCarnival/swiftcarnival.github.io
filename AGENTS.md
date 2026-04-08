# Agent Instructions

## Project

Swift Blog Carnival — a static site generator that reads `data/editions.yml` and produces `output/index.html` + updates `README.md`. Built with Swift Package Manager (swift-tools-version: 6.0, macOS 13+).

First, orient yourself in the code base and run tests. 

```
Sources/SiteGeneratorCore/          # Library target (testable)
Sources/SiteGenerator/              # Executable target (CLI)
```

## swift-html Conventions

This project uses [pointfreeco/swift-html](https://github.com/pointfreeco/swift-html). Follow these patterns:

### Node construction
- Use `[]` for empty/no-op nodes, not `.fragment([])`
- Use `let x: Node = if condition { .div(...) } else { [] }` — prefer if-expressions over var + append
- Pass children as variadic args to element functions: `.article(attributes: [...], child1, child2, child3)`
- Use string interpolation for mixed text + elements: `"Hosted by \(.a(attributes: [.href(url)], .text(name)))"`

### Escaping
- `.text("...")` escapes HTML entities automatically — use by default
- `.raw("...")` passes through unescaped — use only for HTML entities like `&rarr;`, `&mdash;`
- Never use `.raw()` with user-controlled input

### Attributes
- Classes: `attributes: [.class("block__element--modifier")]`
- ARIA: `.ariaLabel("...")`, `.ariaHidden(.true)` — built-in, not `.custom()`
- Links: `.href("...")`

### Model extensions
- Display logic lives on the model types, not in renderers:
  - `Host.displayName` — name or "TBD"
  - `Host.linkNode(rawFallback:)` — `<a>` or text fallback
  - `Edition.formattedMonth` — "April 2026"
  - `Edition.Status.badgeNode` — `<span class="badge badge--open">open</span>`
  - `Edition.Status.badgeClass` — "badge badge--open"

### CSS classes (BEM)
- Blocks: `featured`, `edition`, `badge`, `cta`, `volunteer`
- Elements: `featured__month`, `featured__host`, `edition__actions`, etc.
- Modifiers: `badge--open`, `badge--upcoming`, `cta--primary`, `cta--outline`
- Section labels: `section-label`, `section-label--spaced`
- Header: `header__dot`, `header__detail`

## File conventions

- One file per public function in `Rendering/`, named after the function: `RenderPage.swift` contains `renderPage()`
- One file per public type in model layer: `Host.swift`, `Edition.swift`
- Model display extensions live in the model's file, not with renderers
- Rendering files go in `Sources/SiteGeneratorCore/Rendering/`
- CLI commands get one file each in `Sources/SiteGenerator/`

## Verification

After any change:
1. `swift test` — all tests must pass
2. `swift run SiteGenerator generate` — site must generate
