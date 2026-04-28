#!/usr/bin/env python3
"""Sync a single GitHub issue body into data/editions.yml.

Status is derived from field presence:
  - roundup URL set                      -> "published"
  - else announcement URL set            -> "open"
  - else                                 -> "upcoming"

The script is idempotent: running it again with the same body yields the same file.
"""

import argparse
import re
import sys
from pathlib import Path

import yaml


EDITIONS_PATH = Path("data/editions.yml")

MONTH_RE = re.compile(r"^\d{4}-(0[1-9]|1[0-2])$")


def parse_issue_body(body: str) -> dict[str, str]:
    fields: dict[str, str] = {}
    current_key: str | None = None
    current_lines: list[str] = []

    for line in body.splitlines():
        heading = re.match(r"^###\s+(.+)$", line)
        if heading:
            if current_key is not None:
                fields[current_key] = "\n".join(current_lines).strip()
            current_key = heading.group(1).strip()
            current_lines = []
        else:
            current_lines.append(line)

    if current_key is not None:
        fields[current_key] = "\n".join(current_lines).strip()

    return {k: ("" if v == "_No response_" else v) for k, v in fields.items()}


def derive_status(announcement: str, roundup: str) -> str:
    if roundup:
        return "published"
    if announcement:
        return "open"
    return "upcoming"


def load_editions() -> dict:
    return yaml.safe_load(EDITIONS_PATH.read_text())


def save_editions(data: dict) -> None:
    EDITIONS_PATH.write_text(
        yaml.dump(data, default_flow_style=False, sort_keys=False, allow_unicode=True)
    )


def sync(fields: dict) -> str:
    month = fields.get("Month", "").strip()
    name = fields.get("Your name", "").strip()
    link = fields.get("Your blog or profile URL", "").strip()
    topic = fields.get("Topic", "").strip()
    announcement = fields.get("Announcement URL", "").strip()
    roundup = fields.get("Roundup URL", "").strip()

    if not month:
        return "ERROR: Missing month."
    if not MONTH_RE.match(month):
        return f"ERROR: Invalid month format: '{month}'. Expected YYYY-MM."
    if not name:
        return "ERROR: Missing host name."

    status = derive_status(announcement, roundup)

    data = load_editions()
    editions = data.get("editions", [])

    entry = next((e for e in editions if e["month"] == month), None)
    if entry is None:
        entry = {
            "month": month,
            "host": {"name": name, "link": link},
            "topic": topic,
            "status": status,
            "announcement": announcement,
            "roundup": roundup,
        }
        editions.append(entry)
        editions.sort(key=lambda e: e["month"], reverse=True)
    else:
        existing_name = entry["host"].get("name", "")
        if existing_name and existing_name != name:
            return (
                f"ERROR: Month {month} is already claimed by {existing_name}. "
                f"Update the existing issue instead of opening a new one."
            )
        entry["host"]["name"] = name
        entry["host"]["link"] = link
        if topic:
            entry["topic"] = topic
        entry["announcement"] = announcement
        entry["roundup"] = roundup
        entry["status"] = status

    data["editions"] = editions
    save_editions(data)

    parts = [f"**{month}** synced.", f"- Host: {name}"]
    if topic:
        parts.append(f"- Topic: {topic}")
    parts.append(f"- Status: {status}")
    if announcement:
        parts.append(f"- Announcement: {announcement}")
    if roundup:
        parts.append(f"- Roundup: {roundup}")
    return "\n".join(parts)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--body", required=True)
    args = parser.parse_args()

    result = sync(parse_issue_body(args.body))
    print(result)
    if result.startswith("ERROR:"):
        sys.exit(1)


if __name__ == "__main__":
    main()
