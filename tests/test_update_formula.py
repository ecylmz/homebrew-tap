from __future__ import annotations

import importlib.util
import pathlib
import tempfile
import unittest
from unittest import mock


ROOT = pathlib.Path(__file__).resolve().parents[1]
SCRIPT = ROOT / ".github" / "scripts" / "update_formula.py"
SPEC = importlib.util.spec_from_file_location("update_formula", SCRIPT)
assert SPEC and SPEC.loader
update_formula = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(update_formula)


class UpdateFormulaTest(unittest.TestCase):
    def test_artifact_aliases_use_release_names(self) -> None:
        aliases = update_formula.parse_aliases("darwin_amd64=Darwin_x86_64,darwin_arm64=Darwin_arm64")

        self.assertEqual(
            update_formula.artifact_name(
                "{formula}_{target}.tar.gz",
                "apple-notes-md",
                "v0.1.2",
                "darwin_amd64",
                aliases,
            ),
            "apple-notes-md_Darwin_x86_64.tar.gz",
        )

    def test_updates_matching_url_and_sha(self) -> None:
        formula = '''class Example < Formula
  version "0.1.0"

  on_macos do
    url "https://github.com/acme/example/releases/download/v0.1.0/example-darwin-arm64.tar.gz"
    sha256 "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  end
end
'''
        with tempfile.TemporaryDirectory() as tmp:
            path = pathlib.Path(tmp) / "example.rb"
            path.write_text(formula)
            with mock.patch.object(update_formula, "sha256", return_value="b" * 64):
                update_formula.update_formula(
                    path,
                    "example",
                    "acme/example",
                    "v0.1.1",
                    "{formula}-{target}.tar.gz",
                    {"darwin_arm64": "darwin-arm64"},
                )

            updated = path.read_text()

        self.assertIn('version "0.1.1"', updated)
        self.assertIn("example-darwin-arm64.tar.gz", updated)
        self.assertIn("b" * 64, updated)
        self.assertNotIn("a" * 64, updated)


if __name__ == "__main__":
    unittest.main()
