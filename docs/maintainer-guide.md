# Maintainer Guide

How the Swift Blog Carnival workflow works, from volunteer sign-up to published roundup.

Each edition has **one living issue**. The host opens it, a maintainer approves it once, and the host edits the same issue as the edition progresses. Status is derived from which URL fields the host has filled in — there is no `status-*` labeling step.

## Labels

| Label | Applied by | Meaning |
|-------|------------|---------|
| `edition` | template (auto) | Issue tracks a single edition through its full lifecycle. |
| `needs-review` | template (auto) | New or re-opened issue, needs maintainer attention. |
| `approved` | maintainer | Authorizes the automation to sync this issue into `data/editions.yml`. Applied **once**; later edits re-run the sync as long as the label stays. |
| `rejected` | maintainer | Close without making changes. |

## Status derivation

The sync script (`scripts/update_editions.py`) sets `status` from URL field presence:

| Fields filled | Resulting status |
|---------------|------------------|
| Neither announcement nor roundup URL | `upcoming` |
| Announcement URL only | `open` |
| Roundup URL set (with or without announcement) | `published` |

## Lifecycle of an Edition

### 1. Host opens the issue

Someone opens an issue using the **Host an Edition** template, filling in at least:

- Month (YYYY-MM)
- Name

Optional fields: blog/profile URL, topic, announcement URL, roundup URL, notes.

The issue gets labeled `edition` + `needs-review` automatically.

### 2. Maintainer approves once

Check the month isn't already claimed and the fields look sane. Add the `approved` label.

What happens automatically:

- The issue body is parsed.
- A new entry is added to `data/editions.yml` with status derived from URL presence (usually `upcoming` at this point).
- The `needs-review` label is removed.
- A confirmation comment is posted showing exactly what was synced.
- The site and README rebuild and deploy.
- The issue **stays open** so the host can edit it later.

If something is wrong (bad month format, month already claimed by someone else, missing required field), the action posts an error comment. Remove `approved` while the host corrects the issue, then re-add it.

### 3. Host announces the edition is open

When the host publishes their call for posts, they edit the same issue and paste the announcement URL into the **Announcement URL** field.

The workflow re-runs on edit (because `approved` is still applied), changes the edition's status to `open` in `editions.yml`, and rebuilds the site. No maintainer action required.

### 4. Host publishes the roundup

After the month ends, the host edits the issue again and pastes the roundup URL into the **Roundup URL** field.

The workflow:

- Sets the edition's status to `published`.
- Records the roundup URL.
- Rebuilds the site.
- **Closes the issue** automatically (this is the only step that auto-closes).

## Filtering Issues

| What you're looking for | Filter |
|------------------------|--------|
| Everything needing attention | `is:open label:needs-review` |
| New host requests waiting on first approval | `is:open label:edition label:needs-review -label:approved` |
| Approved editions in progress | `is:open label:edition label:approved` |
| Published editions (history) | `is:closed label:edition label:approved` |

## What Maintainers Never Need to Do

- Edit `data/editions.yml` by hand (for the normal flow)
- Edit `README.md` by hand
- Trigger a deploy
- Re-label an issue for each status transition — `approved` is applied once and stays
- Run any scripts locally

Everything after the initial approval is driven by the host editing their own issue.

## Error Recovery

If the automation commits something wrong:

1. Edit `data/editions.yml` directly and push. The site rebuilds automatically.
2. Or revert the commit with `git revert`.

The automation only ever adds or updates a single edition entry per issue. It never deletes entries.

## Adding a New Maintainer

Add their GitHub username to the `MAINTAINERS` file (one username per line, no `@` prefix). They need write access to the repository to add labels. The workflow refuses to run if the actor adding `approved` is not listed there.

## Manual Overrides

Maintainers can always edit `data/editions.yml` directly for situations the automation doesn't cover, like:

- Removing an edition (host drops out)
- Changing a host's name or link after approval
- Correcting a roundup URL
- Reordering entries

Push to `main` and the site rebuilds.
