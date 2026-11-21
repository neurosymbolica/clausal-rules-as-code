# eu/dora_tlpt

> **Disclaimer.** These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

## Scope

Who must carry out advanced testing by means of threat-led penetration testing (TLPT) under Regulation (EU) 2022/2554 (DORA), and how often: Article 26(1) and Article 26(8), third subparagraph, points (a) to (c), of the Regulation, and Article 2(1) and (2) of Commission Delegated Regulation (EU) 2025/1190 (the TLPT RTS). For one financial entity, tlpt_identification_basis answers whether a carve-out of Art 26(1) (an Article 16(1) entity, a microenterprise) excludes it from TLPT and otherwise whether it falls within a point (a) to (g) of Article 2(2) of the TLPT RTS (listed_for_tlpt, which is not the duty: the authority shall require TLPT unless its assessment shows it is not justified); tlpt_duty answers whether the entity, once identified by the authority, must carry out TLPT at least every three years or at the frequency the competent authority has set. Out of scope: the requirements for the test and the testers (Art 26(2) to (8), first and second subparagraphs, Article 27, Articles 7 and 15 of the TLPT RTS; order eu/dora-tlpt-testers-and-tests), the steps of the testing process (Articles 4 to 6 and 8 to 13 of the TLPT RTS; order eu/dora-tlpt-process), the authority's own ...

## Where the open questions are

- `manifest.yaml`: `deferred_set` and `excluded_set` list the provisions deliberately not implemented, with the reason and the consequence for a user; `operative_readings` (where present) records readings of ambiguous text.
- `SIGNATURE.md`: the inputs the domain expects, the answers it gives, and the readings it takes.
- Answers that turn on an unsettled reading are returned as a referral for legal review rather than as a definite answer.

## What was checked

- 291 tests, passing on Clausal Prolog, Scryer Prolog and Trealla Prolog (see the repository README).
- Every citation record quotes its statute word for word against the pinned text under `sources/` (`_tools/check_citations.py`).
- This domain has no provision-tracking ledger (`provisions.yaml`): the share of the statute it covers has not been accounted unit by unit.

Licence: EUPL-1.2. The statute text under `sources/` is not an official version of the law; see the repository `NOTICE`.
