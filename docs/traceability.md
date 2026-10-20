# From statute to rule

The aim is that a reader can start from any answer and arrive at the exact words of law it rests
on, and start from any sentence of the pinned law and see what the domain did with it.

## The pinned source

Each domain's `sources/` folder holds the extract of the official text it implements, as
published by the Publications Office of the European Union: Formex 4 XML (the format of the
Official Journal) or XHTML from EUR-Lex. Beside each extract, a small record states:

- the CELEX number, and for a consolidated text the consolidation date;
- the URL it was fetched from and the date it was fetched;
- the SHA-256 fingerprint of the extract and of the full document it was cut from;
- how the extract was cut, and how the cut was verified against the full document;
- the period of validity of that version.

Anyone can fetch the same document and confirm that the bytes match.

## Citations and parameters

A rule never quotes the law directly; it cites a **citation record**, which holds the label, the
source reference and the verbatim text, and lists the units of the pinned extract it covers. The
citation check confirms that every quotation is an exact substring of the pinned text. Numbers
taken from the law (25 %, EUR 300 000, 35 days) live in **parameter records**, each with the
sentence that fixes the value, checked the same way.

## Provision tracking

The pinned extract is divided into units: articles, paragraphs, points. The provision-tracking
ledger (`provisions.yaml`) accounts for every one of them as:

- **formalized**: at least one rule cites it;
- **deferred**: not formalized, with the reason and the consequence for anyone relying on the
  domain, and whether the domain's commissioning specification authorized the deferral;
- **excluded**: outside the domain's scope by design (for example a provision of a different
  article that the extract cross-refers to).

A unit that is none of these is **unaccounted**, and in every domain of this release the check
fails if any unit is unaccounted. Today the count is zero in all eight.

## The side-by-side report

For each domain, a report shows every unit of the pinned extract with its own text on the left
and the claim made about it on the right: the rule's quotation, or the deferral's reason and
consequence. It is built from the ledger alone, so what you read is exactly what the check
scored.

- [Does a person's effective holding reach the 25 % threshold (AMLR Art 52)?](reports/eu-aml-amlr_beneficial_ownership_threshold.html)
- [Is a person a beneficial owner through direct and indirect holdings in a chain of entities (AMLR Art 52(1))?](reports/eu-aml-amlr_bo_chain.html)
- [Is a framework agreement's term, and a call-off under it, lawful (Directive 2014/24 Art 33)?](reports/eu-procurement-framework_agreements.html)
- [Is a life-cycle costing method valid, and what does it compute (Art 68)?](reports/eu-procurement-life_cycle_costing.html)
- [May the authority limit the number of candidates, and to how many (Art 65)?](reports/eu-procurement-shortlisting.html)
- [What is the minimum time limit for receipt (Art 27-31)?](reports/eu-procurement-time_limits.html)
- [May a utility negotiate without a prior call for competition (Directive 2014/25 Art 50)?](reports/eu-procurement-utilities_negotiated_without_prior_call.html)
- [How much de minimis aid has an undertaking received in the rolling three-year window, and is it under the ceiling (Regulation (EU) 2023/2831)?](reports/eu-state_aid-de_minimis_cumulation.html)
