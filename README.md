# Swift Blog Carnival

A monthly community blogging event for Swift developers. Each month, a volunteer host picks a topic, the community writes blog posts, and the host publishes a roundup.

**Website:** [swiftcarnival.github.io](https://swiftcarnival.github.io)

## Editions

<!-- EDITIONS:START -->
| Month | Host | Topic | Status |
|-------|------|-------|--------|
| 2026-04 | TBD | TBD | upcoming |
<!-- EDITIONS:END -->

## How to Volunteer

1. Fork this repository.
2. Edit `data/editions.yml` — add a new entry for the month you want to host.
3. Keep entries in reverse chronological order (newest first).
4. Open a pull request.
5. Merging your PR means you're confirmed as host.

## How It Works

1. **Host** picks a topic and announces it (blog, social media, etc.)
2. **Community** writes and publishes posts on the topic during the month.
3. **Host** collects links and publishes a roundup post at month's end.
4. **Host** submits another PR updating `status` to `published` and adding the `roundup` URL.

## Building the Site Locally

```
swift run SiteGenerator validate
swift run SiteGenerator generate
open output/index.html
```

## License

[CC-BY-4.0](LICENSE)
