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

**Easy way:** [Open an issue](https://github.com/SwiftCarnival/swiftcarnival.github.io/issues/new?template=volunteer-to-host.yml) using the "Volunteer to Host" template. A maintainer will add you to the schedule.

**PR way:** Fork this repo, add your entry to `data/editions.yml` (reverse chronological order, newest first), and open a pull request. Merging = confirmed.

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
