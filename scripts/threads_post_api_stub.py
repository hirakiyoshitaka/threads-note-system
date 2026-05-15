#!/usr/bin/env python3
"""Post approved Threads queue items.

DRY_RUN defaults to true. In dry-run mode this script never calls the Threads
API and never mutates queue JSON files.
"""

from __future__ import annotations

from datetime import datetime, timezone
from json import JSONDecodeError
import json
import os
from pathlib import Path
import tempfile
from typing import Any
from urllib.error import HTTPError, URLError
from urllib.parse import urlencode
from urllib.request import Request, urlopen


ROOT = Path(__file__).resolve().parents[1]
QUEUE_DIR = ROOT / "data" / "threads_queue"
API_BASE_URL = "https://graph.threads.net/v1.0"


def env_true(name: str, default: str = "true") -> bool:
    return os.getenv(name, default).strip().lower() not in {"0", "false", "no", "off"}


def load_items() -> list[tuple[Path, dict[str, Any]]]:
    items: list[tuple[Path, dict[str, Any]]] = []
    for path in sorted(QUEUE_DIR.glob("*.json")):
        data = json.loads(path.read_text(encoding="utf-8"))
        if isinstance(data, dict):
            items.append((path, data))
    return items


def save_item(path: Path, item: dict[str, Any]) -> None:
    encoded = json.dumps(item, ensure_ascii=False, indent=2) + "\n"
    with tempfile.NamedTemporaryFile(
        "w",
        encoding="utf-8",
        dir=path.parent,
        delete=False,
    ) as tmp:
        tmp.write(encoded)
        tmp_path = Path(tmp.name)
    tmp_path.replace(path)


def sanitize_error(message: str, access_token: str | None) -> str:
    if access_token:
        message = message.replace(access_token, "[redacted]")
    return message


def api_post(endpoint: str, params: dict[str, str], access_token: str) -> dict[str, Any]:
    url = f"{API_BASE_URL}/{endpoint.lstrip('/')}"
    body = urlencode(params).encode("utf-8")
    request = Request(url, data=body, method="POST")
    request.add_header("Content-Type", "application/x-www-form-urlencoded")

    try:
        with urlopen(request, timeout=30) as response:
            raw = response.read().decode("utf-8")
    except HTTPError as exc:
        raw_error = exc.read().decode("utf-8", errors="replace")
        raise RuntimeError(
            sanitize_error(f"HTTP {exc.code}: {raw_error}", access_token)
        ) from exc
    except URLError as exc:
        raise RuntimeError(sanitize_error(f"Network error: {exc.reason}", access_token)) from exc

    try:
        data = json.loads(raw)
    except JSONDecodeError as exc:
        raise RuntimeError("Threads API returned invalid JSON") from exc

    if not isinstance(data, dict):
        raise RuntimeError("Threads API response was not a JSON object")

    return data


def validate_post_target(path: Path, item: dict[str, Any]) -> str | None:
    status = item.get("status")
    if status == "posted":
        return "already posted"
    if status != "approved":
        return "status is not approved"

    threads_text = str(item.get("threads_text") or "").strip()
    if not threads_text:
        return "threads_text is empty"

    draft_path_value = item.get("linked_note_draft_path")
    if not draft_path_value:
        return "linked_note_draft_path is empty"

    draft_path = ROOT / str(draft_path_value)
    if not draft_path.is_file():
        return f"linked_note_draft_path does not exist: {draft_path_value}"

    return None


def create_text_container(user_id: str, access_token: str, text: str) -> str:
    data = api_post(
        f"{user_id}/threads",
        {
            "media_type": "TEXT",
            "text": text,
            "access_token": access_token,
        },
        access_token,
    )
    creation_id = data.get("id")
    if not creation_id:
        raise RuntimeError("Threads container creation response did not include id")
    return str(creation_id)


def publish_container(user_id: str, access_token: str, creation_id: str) -> str | None:
    data = api_post(
        f"{user_id}/threads_publish",
        {
            "creation_id": creation_id,
            "access_token": access_token,
        },
        access_token,
    )
    post_id = data.get("id")
    return str(post_id) if post_id else None


def mark_error(path: Path, item: dict[str, Any], message: str) -> None:
    item["error_message"] = message
    save_item(path, item)


def mark_posted(path: Path, item: dict[str, Any], threads_post_id: str | None) -> None:
    item["status"] = "posted"
    item["posted_at"] = datetime.now(timezone.utc).astimezone().isoformat(timespec="seconds")
    item["error_message"] = None
    if threads_post_id:
        item["threads_post_id"] = threads_post_id
    save_item(path, item)


def main() -> int:
    dry_run = env_true("DRY_RUN", "true")
    access_token = os.getenv("THREADS_ACCESS_TOKEN")
    user_id = os.getenv("THREADS_USER_ID")

    print("=====================================")
    print("[threads_post_api_stub] Threads API Poster")
    print("=====================================")

    if dry_run:
        print("今はDRY RUNです。Threads APIへの実投稿は行いません。")
    else:
        print("DRY_RUN=false です。approved の投稿だけThreads APIへ投稿します。")
        if not access_token:
            print("[error] THREADS_ACCESS_TOKEN is not set")
            return 1
        if not user_id:
            print("[error] THREADS_USER_ID is not set")
            return 1

    items = load_items()
    approved_items = [(path, item) for path, item in items if item.get("status") == "approved"]

    print(f"[info] approved queue items: {len(approved_items)}")
    for path, item in approved_items:
        print("")
        print(f"[target] {path.relative_to(ROOT)}")
        print(f"theme: {item.get('theme')}")
        print(f"scheduled_at: {item.get('scheduled_at')}")
        print("threads_text:")
        print(item.get("threads_text", ""))
        validation_error = validate_post_target(path, item)
        if validation_error:
            print(f"[skip] {validation_error}")

    if dry_run:
        print("")
        print("[dry_run] 投稿対象の確認のみで終了しました。")
        return 0

    posted_count = 0
    failed_count = 0

    for path, item in approved_items:
        rel_path = path.relative_to(ROOT)
        validation_error = validate_post_target(path, item)
        if validation_error:
            print(f"[skip] {rel_path}: {validation_error}")
            if item.get("status") == "approved":
                mark_error(path, item, validation_error)
                failed_count += 1
            continue

        try:
            text = str(item["threads_text"]).strip()
            print(f"[post] creating Threads container: {rel_path}")
            creation_id = create_text_container(str(user_id), str(access_token), text)
            print(f"[post] publishing Threads container: {rel_path}")
            threads_post_id = publish_container(str(user_id), str(access_token), creation_id)
            mark_posted(path, item, threads_post_id)
            posted_count += 1
            print(f"[ok] posted: {rel_path}")
        except RuntimeError as exc:
            message = sanitize_error(str(exc), access_token)
            mark_error(path, item, message)
            failed_count += 1
            print(f"[error] {rel_path}: {message}")

    print("")
    print(f"[result] posted: {posted_count}, errors: {failed_count}")
    return 1 if failed_count else 0


if __name__ == "__main__":
    raise SystemExit(main())
