"""Fetch an official GDPR snapshot into a NEW directory; never overwrite a freeze."""
import argparse
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import urllib.request
import xml.etree.ElementTree as ET

URL = "https://publications.europa.eu/resource/cellar/5f2552c2-cc45-11e6-ad7c-01aa75ed71a1.0022.01/DOC_1"


def extract(data):
    root = ET.fromstring(data)
    info = root.find("INFO.CONSLEG")
    if info is None or info.get("CONSLEG.REF") != "2016R0679":
        raise ValueError("Response is not GDPR legislation")
    articles = {}
    for article in root.findall(".//ARTICLE"):
        # Separate leaves with spaces: retain article, paragraph and point labels.
        lines = [" ".join(" ".join(part.itertext()).split()) for part in article]
        articles[str(int(article.attrib["IDENTIFIER"]))] = "\n".join(lines)
    if set(articles) != {str(n) for n in range(1, 100)}:
        raise ValueError("Incomplete official GDPR source")
    return articles, dict(info.attrib)


def fetch(output):
    output = Path(output)
    if output.exists():
        raise FileExistsError("Use a new directory, then review changes explicitly")
    with urllib.request.urlopen(URL, timeout=60) as response:
        if response.status != 200:
            raise ValueError(f"Official source returned HTTP {response.status}")
        data = response.read()
    articles, metadata = extract(data)
    output.mkdir(parents=True)
    (output / "gdpr.xml").write_bytes(data)
    (output / "articles.json").write_text(json.dumps(articles, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    (output / "gdpr-articles.txt").write_text("\n\n".join(articles.values()) + "\n", encoding="utf-8")
    manifest = {"celex": "02016R0679-20160504", "regulation": "EU 2016/679", "language": "en", "source_url": URL,
                "canonical_url": "https://eur-lex.europa.eu/eli/reg/2016/679/2016-05-04/eng",
                "fetched_at": datetime.now(timezone.utc).isoformat(), "formex_metadata": metadata,
                "status": "Official Publications Office consolidated document, including its recorded corrigenda; consolidated text is documentary and not the authentic Official Journal.",
                "extraction": "All 99 complete articles; whitespace normalized from Formex. Full source including recitals retained as gdpr.xml. Per-case article subset identical across LLM arms; recitals not injected.",
                "sha256": {n: hashlib.sha256((output / n).read_bytes()).hexdigest() for n in ("gdpr.xml", "articles.json", "gdpr-articles.txt")}}
    (output / "law-manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    print(json.dumps({"articles": len(articles), "source": URL, "output": str(output)}))


if __name__ == "__main__":
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("output")
    fetch(ap.parse_args().output)
