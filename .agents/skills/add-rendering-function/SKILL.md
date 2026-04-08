---
name: add-rendering-function
description: Scaffolds a new rendering function in SiteGeneratorCore/Rendering following project file conventions and swift-html patterns. Use when adding a new renderer.
---

# Add Rendering Function

Scaffold a new rendering function following project conventions.

## Steps

1. Create a new file in `Sources/SiteGeneratorCore/Rendering/` named after the function (e.g., `RenderFoo.swift` for `renderFoo()`)
2. Add `import Html` at the top
3. Define a public function that returns `Node` (for HTML) or `String` (for other formats)
4. Use model extensions (`edition.formattedMonth`, `host.displayName`, `edition.status.badgeNode`) instead of inline display logic
5. Follow these patterns:
   - `let x: Node = if condition { ... } else { [] }` for conditional content
   - `"text \(.element(...))"` for mixed text + elements
   - `.text()` for all user data, `.raw()` only for HTML entities
   - `attributes: [.class("block__element--modifier")]` for BEM classes
6. Add tests in `Tests/SiteGeneratorCoreTests/HTMLRendererTests.swift`
7. If the function is called from the CLI, wire it up in `Sources/SiteGenerator/GenerateCommand.swift`

## Verification

```bash
swift test
swift run SiteGenerator generate
```
