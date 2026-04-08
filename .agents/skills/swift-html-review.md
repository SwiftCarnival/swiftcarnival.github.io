# swift-html Code Review

Review Swift rendering code for idiomatic swift-html usage. Check files in `Sources/SiteGeneratorCore/Rendering/`.

## Checks

### Safety
- `.raw()` should only be used for HTML entities (`&rarr;`, `&mdash;`). All other text must use `.text()` for automatic escaping.
- No string interpolation inside `.raw()` — that bypasses escaping.

### Idioms
- Empty nodes: use `[]`, not `.fragment([])` or `.text("")`
- Conditional nodes: use `let x: Node = if ... { } else { [] }`, not `var` + `.append()`
- Mixed text + elements: use string interpolation on Node (`"text \(.element(...))"`)
- Variadic children: pass directly to element functions, don't build intermediate arrays

### Structure
- Display logic (name fallbacks, formatted dates, badge rendering) belongs on model types in `Edition.swift` / `Host.swift`, not inline in renderers
- Each public rendering function gets its own file in `Rendering/`, named after the function
- Rendering files must `import Html`

### BEM class names
- Verify element separator is `__` (double underscore): `featured__month`
- Verify modifier separator is `--` (double hyphen): `badge--open`
- No single-hyphen BEM (like `badge-open` or `featured-month`)
