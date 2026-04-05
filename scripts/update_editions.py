#!/usr/bin/env python3
"""Parse a GitHub issue body and update data/editions.yml accordingly."""

import argparse
import re
import sys
from pathlib import Path

import yaml


EDITIONS_PATH = Path("data/editions.yml")


def parse_issue_body(body: str) -> dict[str, str]:
    fields = {}
    current_key = None
    current_lines = []

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

    cleaned = {}
    for k, v in fields.items():
        if v == "_No response_" or v == "":
            v = ""
        cleaned[k] = v

    return cleaned


def load_editions() -> dict:
    return yaml.safe_load(EDITIONS_PATH.read_text())


def save_editions(data: dict) -> None:
    EDITIONS_PATH.write_text(yaml.dump(data, default_flow_style=False, sort_keys=False, allow_unicode=True))


def approve(fields: dict) -> str:
    month = fields.get("Month", "").strip()
    name = fields.get("Your name", "").strip()
    link = fields.get("Your blog or profile URL", "").strip()
    topic = fields.get("Proposed topic", "").strip()

    if not month:
        return "ERROR: Missing month."

    if not re.match(r"^\d{4}-(0[1-9]|1[0-2])$", month):
        return f"ERROR: Invalid month format: '{month}'. Expected YYYY-MM."

    if not name:
        return "ERROR: Missing host name."

    data = load_editions()
    editions = data.get("editions", [])

    existing = None
    for e in editions:
        if e["month"] == month:
            existing = e
            break

    if existing is not None:
        if existing["host"]["name"]:
            return f"ERROR: Month {month} is already claimed by {existing['host']['name']}."
        existing["host"]["name"] = name
        existing["host"]["link"] = link
        if topic:
            existing["topic"] = topic
    else:
        new_entry = {
            "month": month,
            "host": {"name": name, "link": link},
            "topic": topic,
            "status": "upcoming",
            "roundup": "",
        }
        editions.append(new_entry)
        editions.sort(key=lambda e: e["month"], reverse=True)

    data["editions"] = editions
    save_editions(data)

    parts = [f"**{month}** added to the schedule."]
    parts.append(f"- Host: {name}")
    if topic:
        parts.append(f"- Topic: {topic}")
    parts.append("- Status: upcoming")
    return "\n".join(parts)


def update_status(fields: dict, target_status: str) -> str:
    month = (fields.get("Edition month", "") or fields.get("Month", "")).strip()

    if not month:
        return "ERROR: Missing edition month."

    if not re.match(r"^\d{4}-(0[1-9]|1[0-2])$", month):
        return f"ERROR: Invalid month format: '{month}'. Expected YYYY-MM."

    data = load_editions()
    editions = data.get("editions", [])

    entry = None
    for e in editions:
        if e["month"] == month:
            entry = e
            break

    if entry is None:
        return f"ERROR: No edition found for {month}."

    if target_status == "published":
        roundup = fields.get("Roundup URL", "").strip()
        if not roundup:
            return "ERROR: Roundup URL is required when setting status to published."
        entry["roundup"] = roundup

    entry["status"] = target_status
    save_editions(data)

    msg = f"**{month}** updated to **{target_status}**."
    if target_status == "published" and entry.get("roundup"):
        msg += f"\n- Roundup: {entry['roundup']}"
    return msg


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("action", choices=["approve", "status-open", "status-published"])
    parser.add_argument("--body", required=True)
    args = parser.parse_args()

    fields = parse_issue_body(args.body)

    if args.action == "approve":
        result = approve(fields)
    elif args.action == "status-open":
        result = update_status(fields, "open")
    elif args.action == "status-published":
        result = update_status(fields, "published")
    else:
        result = f"ERROR: Unknown action '{args.action}'."

    print(result)

    if result.startswith("ERROR:"):
        sys.exit(1)


if __name__ == "__main__":
    main()
