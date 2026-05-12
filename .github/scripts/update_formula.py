#!/usr/bin/env python3
"""Update this tap's multi-architecture Homebrew formulae from GitHub releases."""

from __future__ import annotations

import argparse
import hashlib
import os
import pathlib
import re
import urllib.request


ROOT = pathlib.Path(__file__).resolve().parents[2]
USER_AGENT = "ecylmz-homebrew-tap-updater"
TARGETS = ("darwin_arm64", "darwin_amd64", "linux_arm64", "linux_amd64")


def sha256(url: str) -> str:
    headers = {"User-Agent": USER_AGENT}
    token = os.environ.get("GITHUB_TOKEN")
    if token and url.startswith("https://github.com/"):
        headers["Authorization"] = f"Bearer {token}"

    digest = hashlib.sha256()
    request = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(request) as response:
        while chunk := response.read(1024 * 1024):
            digest.update(chunk)
    return digest.hexdigest()


def parse_aliases(value: str | None) -> dict[str, str]:
    if not value:
        return {}
    aliases: dict[str, str] = {}
    for item in value.split(","):
        if not item.strip():
            continue
        if "=" not in item:
            raise SystemExit(f"invalid alias {item!r}; expected target=artifact-target")
        target, alias = item.split("=", 1)
        target = target.strip()
        if target not in TARGETS:
            raise SystemExit(f"unknown target alias {target!r}")
        aliases[target] = alias.strip()
    return aliases


def artifact_name(template: str, formula: str, tag: str, target: str, aliases: dict[str, str]) -> str:
    version = tag.removeprefix("v")
    return template.format(
        formula=formula,
        tag=tag,
        version=version,
        target=aliases.get(target, target),
    )


def release_url(repository: str, tag: str, artifact: str) -> str:
    return f"https://github.com/{repository}/releases/download/{tag}/{artifact}"


def update_pair(text: str, old_url: str, new_url: str, digest: str) -> str:
    pattern = (
        rf'(?P<prefix>url "{re.escape(old_url)}"\n\s+sha256 ")'
        r'[0-9a-f]{64}'
        r'(?P<suffix>")'
    )
    updated, count = re.subn(pattern, rf'\g<prefix>{digest}\g<suffix>', text, count=1)
    if count != 1:
        raise SystemExit(f"expected exactly one url/sha256 pair for {old_url}")
    return updated.replace(old_url, new_url, 1)


def update_formula(path: pathlib.Path, formula: str, repository: str, tag: str, template: str, aliases: dict[str, str]) -> None:
    text = path.read_text()
    old_version = re.search(r'^\s*version "([^"]+)"', text, flags=re.MULTILINE)
    if not old_version:
        raise SystemExit(f"{path} has no version")
    old_tag = f"v{old_version.group(1)}"

    for target in TARGETS:
        old_artifact = artifact_name(template, formula, old_tag, target, aliases)
        new_artifact = artifact_name(template, formula, tag, target, aliases)
        old_url = release_url(repository, old_tag, old_artifact)
        new_url = release_url(repository, tag, new_artifact)
        if old_url not in text:
            continue
        text = update_pair(text, old_url, new_url, sha256(new_url))

    text, count = re.subn(r'^\s*version "[^"]+"', f'  version "{tag.removeprefix("v")}"', text, count=1, flags=re.MULTILINE)
    if count != 1:
        raise SystemExit(f"expected exactly one version in {path}")

    path.write_text(text)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--formula", required=True)
    parser.add_argument("--tag", required=True)
    parser.add_argument("--repository", required=True)
    parser.add_argument("--artifact-template", default="{formula}-{target}.tar.gz")
    parser.add_argument("--target-aliases")
    args = parser.parse_args()

    path = ROOT / "Formula" / f"{args.formula}.rb"
    if not path.exists():
        raise SystemExit(f"missing formula: {path}")
    update_formula(path, args.formula, args.repository, args.tag, args.artifact_template, parse_aliases(args.target_aliases))


if __name__ == "__main__":
    main()

