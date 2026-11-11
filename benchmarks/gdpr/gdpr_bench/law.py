"""Load frozen official legislation and verify its provenance before inference."""
import json
from pathlib import Path
from .dataset import sha256


class LawCorpus:
    def __init__(self, directory):
        self.directory = Path(directory)
        self.manifest = json.loads((self.directory / "law-manifest.json").read_text())
        if self.manifest.get("celex") != "02016R0679-20160504":
            raise ValueError("Not the pinned GDPR corpus")
        for name, expected in self.manifest["sha256"].items():
            if sha256(self.directory / name) != expected:
                raise ValueError(f"Law source hash mismatch: {name}")
        self.articles = json.loads((self.directory / "articles.json").read_text())
        if set(self.articles) != {str(n) for n in range(1, 100)}:
            raise ValueError("GDPR corpus must have articles 1..99")

    def select(self, article_numbers):
        return "\n\n".join(self.articles[str(n)] for n in sorted(set(article_numbers)))
