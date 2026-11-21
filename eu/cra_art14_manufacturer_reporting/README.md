# eu/cra_art14_manufacturer_reporting

> **Disclaimer.** These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

## Scope

Reporting obligations of manufacturers under Article 14(1) to (6) of Regulation (EU) 2024/2847 (Cyber Resilience Act), with the Article 3 definitions that Article 14 uses (read as the caller's classification) and the date of application of Article 14 in Article 71(2) (11 September 2026). Decided here: whether an incident having an impact on the security of a product with digital elements is severe (Art 14(5), either limb); which reporting steps are due, with their limits, for an actively exploited vulnerability (Art 14(2)) or a severe incident (Art 14(4)), with the intermediate report on request (Art 14(6)); and whether an early warning or a notification was submitted within its 24-hour or 72-hour limit (a partial hour rounded up) and without undue delay. Out of scope (deferred or excluded sets): who is a manufacturer and which product or event is covered, product scope and transitional provisions, the recipient CSIRT and the single reporting platform (Art 14(7), Art 16), the content of each report and the clause on information already provided, informing users (Art 14(8)), the Commission's acts (Art 14(9) and (10)), computing the end of the 14-day and one-month calendar periods, ...

## Where the open questions are

- `manifest.yaml`: `deferred_set` and `excluded_set` list the provisions deliberately not implemented, with the reason and the consequence for a user; `operative_readings` (where present) records readings of ambiguous text.
- `SIGNATURE.md`: the inputs the domain expects, the answers it gives, and the readings it takes.
- Answers that turn on an unsettled reading are returned as a referral for legal review rather than as a definite answer.

## What was checked

- 200 tests, passing on Clausal Prolog, Scryer Prolog and Trealla Prolog (see the repository README).
- Every citation record quotes its statute word for word against the pinned text under `sources/` (`_tools/check_citations.py`).
- This domain has no provision-tracking ledger (`provisions.yaml`): the share of the statute it covers has not been accounted unit by unit.

Licence: EUPL-1.2. The statute text under `sources/` is not an official version of the law; see the repository `NOTICE`.
