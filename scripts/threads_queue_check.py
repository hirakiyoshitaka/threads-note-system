#!/usr/bin/env python3
"""Check Threads posting queue JSON files."""

from __future__ import annotations

import json
import sys
from collections import Counter
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
QUEUE_DIR = ROOT / "data" / "threads_queue"
REQUIRED_FIELDS = (
    "theme",
    "threads_text",
    "status",
    "linked_note_draft_path",
    "linked_note_url",
    "scheduled_at",
    "posted_at",
    "error_message",
)


def load_queue_file(path: Path) -> dict[str, Any] | None:
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        print(f"[error] invalid JSON: {path.relative_to(ROOT)}: {exc}", file=sys.stderr)
        return None

    if not isinstance(data, dict):
        print(f"[error] JSON root must be an object: {path.relative_to(ROOT)}", file=sys.stderr)
        return None

    missing = [field for field in REQUIRED_FIELDS if field not in data]
    if missing:
        print(
            f"[error] missing fields in {path.relative_to(ROOT)}: {', '.join(missing)}",
            file=sys.stderr,
        )
        return None

    return data


def print_review_item(path: Path, item: dict[str, Any]) -> None:
    rel_path = path.relative_to(ROOT)
    print("")
    print(f"[review_required] {rel_path}")
    print(f"theme: {item['theme']}")
    print(f"scheduled_at: {item['scheduled_at']}")
    print("threads_text:")
    print(item["threads_text"])

    draft_path = ROOT / str(item["linked_note_draft_path"])
    if draft_path.is_file():
        print(f"[ok] linked_note_draft_path exists: {item['linked_note_draft_path']}")
    else:
        print(f"[error] linked_note_draft_path missing: {item['linked_note_draft_path']}")

    if not item["linked_note_url"]:
        print("[warning] linked_note_url is not set")


def main() -> int:
    print("=====================================")
    print("[threads_queue] Check")
    print("=====================================")
    print(f"[threads_queue] directory: {QUEUE_DIR.relative_to(ROOT)}")

    if not QUEUE_DIR.is_dir():
        print(f"[error] queue directory missing: {QUEUE_DIR.relative_to(ROOT)}", file=sys.stderr)
        return 1

    files = sorted(QUEUE_DIR.glob("*.json"))
    if not files:
        print("[warning] no queue files found")
        return 0

    items: list[tuple[Path, dict[str, Any]]] = []
    has_error = False

    for path in files:
        data = load_queue_file(path)
        if data is None:
            has_error = True
            continue
        items.append((path, data))

    counts = Counter(str(item["status"]) for _, item in items)

    print("")
    print("[threads_queue] status counts")
    for status, count in sorted(counts.items()):
        print(f"{status}: {count}")

    for path, item in items:
        if item["status"] == "review_required":
            print_review_item(path, item)
            draft_path = ROOT / str(item["linked_note_draft_path"])
            if not draft_path.is_file():
                has_error = True

    print("")
    if has_error:
        print("[threads_queue] result: CHECK NEEDED")
        return 1

    print("[threads_queue] result: OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

