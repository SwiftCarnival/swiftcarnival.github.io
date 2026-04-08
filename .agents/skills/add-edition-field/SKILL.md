---
name: add-edition-field
description: Adds a new field to the Edition model and propagates it through renderers, test helpers, fixtures, and validation. Use when extending the Edition data schema.
---

# Add Edition Field

Add a new field to the Edition model and propagate it through all renderers.

## Steps

1. Add the field to `Edition` in `Sources/SiteGeneratorCore/Edition.swift`
   - Add the property to the struct
   - Add it to `init()` with a sensible default
   - If it needs display formatting, add a computed property extension in the same file

2. Update `data/editions.yml` if existing editions need the new field

3. Update renderers that should display it:
   - `Rendering/RenderFeaturedHTML.swift` — the featured article section
   - `Rendering/RenderEditionList.swift` — the edition list `<ol>`
   - `Rendering/RenderMarkdownTable.swift` — the README markdown table

4. Update tests in `Tests/SiteGeneratorCoreTests/HTMLRendererTests.swift`
   - Update the `edition()` test helper to include the new field with a default
   - Add assertions for the new field in relevant test suites

5. If the field affects validation, update `Sources/SiteGeneratorCore/Validation.swift`

## Verification

```bash
swift test
swift run SiteGenerator generate
```
