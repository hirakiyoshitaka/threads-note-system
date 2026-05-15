#!/usr/bin/env python3
"""Future Threads API poster stub.

This script intentionally does not post yet. It only shows which approved
queue items would become posting targets when the API implementation is added.
"""

from __future__ import annotations

import json
import os
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
QUEUE_DIR = ROOT / "data" / "threads_queue"


def env_true(name: str, default: str = "true") -> bool:
    return os.getenv(name, default).strip().lower() not in {"0", "false", "no", "off"}


def load_items() -> list[tuple[Path, dict[str, Any]]]:
    items: list[tuple[Path, dict[str, Any]]] = []
    for path in sorted(QUEUE_DIR.glob("*.json")):
        data = json.loads(path.read_text(encoding="utf-8"))
        if isinstance(data, dict):
            items.append((path, data))
    return items


def main() -> int:
    dry_run = env_true("DRY_RUN", "true")
    access_token = os.getenv("THREADS_ACCESS_TOKEN")
    user_id = os.getenv("THREADS_USER_ID")

    print("=====================================")
    print("[threads_post_api_stub] DRY RUN")
    print("=====================================")

    if dry_run:
        print("今はDRY RUNです。Threads APIへの実投稿は行いません。")
    else:
        print("DRY_RUN=false が指定されていますが、実投稿処理はまだTODOです。")
        if not access_token:
            print("[error] THREADS_ACCESS_TOKEN is not set")
            return 1
        if not user_id:
            print("[error] THREADS_USER_ID is not set")
            return 1

    approved_items = [(path, item) for path, item in load_items() if item.get("status") == "approved"]

    print(f"[info] approved queue items: {len(approved_items)}")
    for path, item in approved_items:
        print("")
        print(f"[target] {path.relative_to(ROOT)}")
        print(f"theme: {item.get('theme')}")
        print(f"scheduled_at: {item.get('scheduled_at')}")
        print("threads_text:")
        print(item.get("threads_text", ""))

    print("")
    print("[todo] Threads API投稿処理をここに追加する")
    print("[todo] 投稿成功後は本来 status=posted、posted_at=投稿時刻 に更新する")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

