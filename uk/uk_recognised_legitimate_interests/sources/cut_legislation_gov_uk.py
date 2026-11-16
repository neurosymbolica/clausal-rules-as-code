#!/usr/bin/env python3
# SPDX-License-Identifier: EUPL-1.2
"""Cut one element (a section, a schedule or an article) out of a legislation.gov.uk
Akoma Ntoso document and write it as a self-identifying pin with its sidecar.

legislation.gov.uk serves a section as a whole Akoma Ntoso document: the Part and
cross-heading wrappers, the enacting formula and the TLC term references come with it.
Pinned as served, every section would repeat those units under the same ids, and the
corpus unit reader refuses an id claimed twice. So the pin keeps:

  * the root <akomaNtoso> and <act>, and <meta><identification> (the FRBR block that says
    which work, expression and manifestation this is), and
  * <body> holding only the cut element, with its own eIds unchanged,

and drops everything else. One change is made inside the element: the eId attribute of
each inline <term> (a defined term in quotation marks) and, in this copy, each inline <ref> is removed, so the term reads as
part of its sentence and not as a separate unit. No text is added, removed or changed;
the script refuses the cut unless the normalised text of the cut element equals the
normalised text of the same element in the served document.

  cut_legislation_gov_uk.py SOURCE.akn.xml ELEMENT_EID DOC_ID URL OUT_STEM DESCRIPTION WORK FETCHED

This copy (uk/uk_recognised_legitimate_interests) differs from the generic cutter only in the sidecar it writes: the header names this domain, the sidecar carries `work: WORK`
(provision_binding.pinned_docs skips a sidecar with neither `work` nor `celex`), and `fetched`
is the FETCHED date given (the day the source was served), not the day the cut is run. One
change to the cut: the eId of each inline <ref> (a citation such as "2002/58/EC" or
"S.I. 2018/506") is removed as well as each <term>'s, for the same reason -- with its eId the
unit reader makes the citation a unit of its own and the sentence reads "Directiveof the
European Parliament" and "Regulations 2018 ()". The refusal is unchanged. A `unit_keys` table, where one is needed, is appended by hand.
"""
import copy, hashlib, re, sys, datetime
import xml.etree.ElementTree as ET

AKN = "http://docs.oasis-open.org/legaldocml/ns/akn/3.0"
N = "{%s}" % AKN
ET.register_namespace("", AKN)
ET.register_namespace("uk", "https://www.legislation.gov.uk/namespaces/UK-AKN")
ET.register_namespace("ukl", "http://www.legislation.gov.uk/namespaces/legislation")
ET.register_namespace("xsi", "http://www.w3.org/2001/XMLSchema-instance")


def norm(el):
    return re.sub(r"\s+", " ", "".join(el.itertext())).strip()


def main(source, eid, doc_id, url, stem, description, work, fetched):
    raw = open(source, "rb").read()
    root = ET.fromstring(raw)
    act = root[0]
    found = [e for e in root.iter() if e.get("eId") == eid]
    if len(found) != 1:
        raise SystemExit(f"{eid}: found {len(found)} elements, expected 1")
    element = copy.deepcopy(found[0])
    for inline in list(element.iter(N + "term")) + list(element.iter(N + "ref")):
        inline.attrib.pop("eId", None)
    new_root = ET.Element(root.tag, root.attrib)
    new_act = ET.SubElement(new_root, act.tag, act.attrib)
    meta = ET.SubElement(new_act, N + "meta")
    meta.append(copy.deepcopy(act.find(N + "meta").find(N + "identification")))
    body = ET.SubElement(new_act, N + "body")
    body.append(element)
    if norm(element) != norm(found[0]):
        raise SystemExit(f"{eid}: cut text differs from the served text")
    out = ET.tostring(new_root, encoding="utf-8", xml_declaration=True)
    open(stem + ".akn.xml", "wb").write(out)
    name = stem.rsplit("/", 1)[-1]
    meta_text = f"""# Statute pin for uk/uk_recognised_legitimate_interests: {description}
# CUT AT THE SMALLEST DOCUMENT-NATIVE ELEMENT covering the part of this domain's scope it carries.
doc_id: {doc_id}
work: "{work}"
format: akn
url: "{url}"
fetched: {fetched}
file: {name}.akn.xml
sha256: "{hashlib.sha256(out).hexdigest()}"
extract:
  root: {eid}
  source_sha256: "{hashlib.sha256(raw).hexdigest()}"
  method: >
    sources/cut_legislation_gov_uk.py: the single element with eId {eid} of the document served at
    the url above, under the original akomaNtoso > act root with meta > identification kept; the
    Part, Chapter, Section and cross-heading wrappers, the rest of meta (lifecycle, analysis, temporal
    data, TLC references, commentary notes) and the enacting formula are dropped, and
    the eId of each inline term and ref element is removed so a defined term or a citation reads inside its sentence.
    The served document carries a transform date (FRBRManifestation), so a re-fetch on another
    day has another source_sha256 while the text is the same.
  verified: >
    {datetime.date.today().isoformat()}: the normalised text of the cut element is identical to the
    same element in the served document (the script refuses the cut otherwise).
"""
    open(stem + ".meta.yaml", "w").write(meta_text)


if __name__ == "__main__":
    main(*sys.argv[1:])
