#!/usr/bin/env python3
"""Tests for update_editions.py — run from the repo root: python scripts/test_update_editions.py"""

import os
import shutil
import sys
import tempfile
import unittest
from pathlib import Path

import yaml

import update_editions as ue


def issue_body(month: str, name: str = "Jane Swift", link: str = "https://example.com",
               topic: str = "Concurrency", announcement: str = "", roundup: str = "") -> str:
    parts = [
        "### Month", "", month, "",
        "### Your name", "", name, "",
        "### Your blog or profile URL", "", link or "_No response_", "",
        "### Topic", "", topic or "_No response_", "",
        "### Announcement URL", "", announcement or "_No response_", "",
        "### Roundup URL", "", roundup or "_No response_", "",
    ]
    return "\n".join(parts)


class SyncTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.mkdtemp()
        self.cwd = os.getcwd()
        os.chdir(self.tmp)
        Path("data").mkdir()
        Path("data/editions.yml").write_text("editions: []\n")

    def tearDown(self):
        os.chdir(self.cwd)
        shutil.rmtree(self.tmp)

    def read(self) -> dict:
        return yaml.safe_load(Path("data/editions.yml").read_text())

    def test_new_edition_with_no_urls_is_upcoming(self):
        ue.sync(ue.parse_issue_body(issue_body("2026-06")))
        e = self.read()["editions"][0]
        self.assertEqual(e["month"], "2026-06")
        self.assertEqual(e["status"], "upcoming")
        self.assertEqual(e["announcement"], "")
        self.assertEqual(e["roundup"], "")

    def test_announcement_url_makes_open(self):
        ue.sync(ue.parse_issue_body(issue_body("2026-06", announcement="https://x/y")))
        e = self.read()["editions"][0]
        self.assertEqual(e["status"], "open")
        self.assertEqual(e["announcement"], "https://x/y")

    def test_roundup_url_makes_published(self):
        ue.sync(ue.parse_issue_body(issue_body("2026-06",
                                                 announcement="https://x/y",
                                                 roundup="https://x/r")))
        e = self.read()["editions"][0]
        self.assertEqual(e["status"], "published")
        self.assertEqual(e["roundup"], "https://x/r")

    def test_repeated_sync_is_idempotent(self):
        body = issue_body("2026-06", announcement="https://x/y")
        ue.sync(ue.parse_issue_body(body))
        first = Path("data/editions.yml").read_text()
        ue.sync(ue.parse_issue_body(body))
        self.assertEqual(first, Path("data/editions.yml").read_text())

    def test_status_progression_via_edits(self):
        ue.sync(ue.parse_issue_body(issue_body("2026-06")))
        self.assertEqual(self.read()["editions"][0]["status"], "upcoming")
        ue.sync(ue.parse_issue_body(issue_body("2026-06", announcement="https://x/y")))
        self.assertEqual(self.read()["editions"][0]["status"], "open")
        ue.sync(ue.parse_issue_body(issue_body("2026-06",
                                                 announcement="https://x/y",
                                                 roundup="https://x/r")))
        self.assertEqual(self.read()["editions"][0]["status"], "published")

    def test_clearing_roundup_demotes_to_open(self):
        ue.sync(ue.parse_issue_body(issue_body("2026-06",
                                                 announcement="https://x/y",
                                                 roundup="https://x/r")))
        ue.sync(ue.parse_issue_body(issue_body("2026-06", announcement="https://x/y")))
        self.assertEqual(self.read()["editions"][0]["status"], "open")
        self.assertEqual(self.read()["editions"][0]["roundup"], "")

    def test_invalid_month_returns_error(self):
        result = ue.sync(ue.parse_issue_body(issue_body("2026-13")))
        self.assertTrue(result.startswith("ERROR:"))

    def test_missing_month_returns_error(self):
        result = ue.sync(ue.parse_issue_body(issue_body("")))
        self.assertTrue(result.startswith("ERROR:"))

    def test_missing_name_returns_error(self):
        result = ue.sync(ue.parse_issue_body(issue_body("2026-06", name="")))
        self.assertTrue(result.startswith("ERROR:"))

    def test_different_host_claiming_same_month_is_rejected(self):
        ue.sync(ue.parse_issue_body(issue_body("2026-06", name="Alice")))
        result = ue.sync(ue.parse_issue_body(issue_body("2026-06", name="Bob")))
        self.assertTrue(result.startswith("ERROR:"))

    def test_inserted_in_reverse_chronological_order(self):
        ue.sync(ue.parse_issue_body(issue_body("2026-06")))
        ue.sync(ue.parse_issue_body(issue_body("2026-08")))
        ue.sync(ue.parse_issue_body(issue_body("2026-07")))
        months = [e["month"] for e in self.read()["editions"]]
        self.assertEqual(months, ["2026-08", "2026-07", "2026-06"])


class DeriveStatusTests(unittest.TestCase):
    def test_no_urls(self):
        self.assertEqual(ue.derive_status("", ""), "upcoming")

    def test_announcement_only(self):
        self.assertEqual(ue.derive_status("https://x/y", ""), "open")

    def test_roundup_wins(self):
        self.assertEqual(ue.derive_status("https://x/y", "https://x/r"), "published")
        self.assertEqual(ue.derive_status("", "https://x/r"), "published")


if __name__ == "__main__":
    sys.path.insert(0, str(Path(__file__).parent))
    unittest.main()
