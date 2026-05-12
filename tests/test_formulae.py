from __future__ import annotations

import pathlib
import re
import unittest


ROOT = pathlib.Path(__file__).resolve().parents[1]


class FormulaeTest(unittest.TestCase):
    def test_formulae_use_release_archives_with_real_checksums(self) -> None:
        for path in sorted((ROOT / "Formula").glob("*.rb")):
            text = path.read_text()
            with self.subTest(formula=path.name):
                self.assertNotIn("0000000000000000000000000000000000000000000000000000000000000000", text)
                urls = re.findall(r'url "([^"]+)"', text)
                self.assertGreaterEqual(len(urls), 1)
                self.assertTrue(all(url.endswith(".tar.gz") for url in urls))
                self.assertTrue(all("github.com/ecylmz/" in url for url in urls))
                checksums = re.findall(r'sha256 "([0-9a-f]{64})"', text)
                self.assertEqual(len(urls), len(checksums))


if __name__ == "__main__":
    unittest.main()

