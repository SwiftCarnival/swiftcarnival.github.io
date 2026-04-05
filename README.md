# Swift Blog Carnival

A monthly community blogging event for Swift developers. Each month, a volunteer host picks a topic, the community writes blog posts, and the host publishes a roundup.

**Website:** [swiftcarnival.github.io](https://swiftcarnival.github.io)

## Editions

<!-- EDITIONS:START -->
| Month | Host | Topic | Status |
|-------|------|-------|--------|
| 2026-04 | [Christian Tietze](https://christiantietze.de) | Tiny Languages | upcoming |
<!-- EDITIONS:END -->

## How It Works

1. **Volunteer:** [Open an issue](https://github.com/SwiftCarnival/swiftcarnival.github.io/issues/new?template=volunteer-to-host.yml) to claim a month and propose a topic. A maintainer will approve you.
2. **Announce:** Write a blog post or share on social media that your edition is open for submissions.
3. **Collect:** The community writes and publishes posts on your topic during the month.
4. **Publish:** At month's end, publish a roundup post linking to all submissions.
5. **Close the loop:** [Open an update issue](https://github.com/SwiftCarnival/swiftcarnival.github.io/issues/new?template=update-edition.yml) with your roundup URL. A maintainer marks it as published and the site updates automatically.

## Building the Site Locally

```
swift run SiteGenerator validate
swift run SiteGenerator generate
open output/index.html
```

## License

[CC-BY-4.0](LICENSE)
