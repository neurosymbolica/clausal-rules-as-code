# eu/cra_administrative_fines

> **Disclaimer.** These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

## Scope

The maximum administrative fines of Article 64 of Regulation (EU) 2024/2847 (the Cyber Resilience Act), with the date from which Article 64 applies (Article 71(2)) and the open-source software steward derogation of Art 64(10)(b). One query, administrative_fine_maximum/4, answers for one infringement, named by the provision infringed, at the date of the infringement: which tier of Art 64(2), (3) or (4) applies and the maximum fine in euro cents (the higher of the fixed amount and, for an undertaking, the percentage of its total worldwide annual turnover; the fixed amount at a tie; the half cent of 2,5 percent dropped); or that Article 64 does not yet apply (before 11 December 2027), does not list the provision, or does not apply to an open-source software steward (middle and lowest tiers only, on the printed reading of 'paragraphs 3 to 9'). Undertaking and steward status are the caller's tri-state judgements (unsure refers to a lawyer). Out of scope: the fine itself (Art 64(5)), whether the offender is within the Regulation's scope or bound by the provision, whether the provision was infringed, national application (Art 64(6) to (9)), and the relation to other fining regimes. Every ...

## Where the open questions are

- `manifest.yaml`: `deferred_set` and `excluded_set` list the provisions deliberately not implemented, with the reason and the consequence for a user; `operative_readings` (where present) records readings of ambiguous text.
- `SIGNATURE.md`: the inputs the domain expects, the answers it gives, and the readings it takes.
- Answers that turn on an unsettled reading are returned as a referral for legal review rather than as a definite answer.

## What was checked

- 224 tests, passing on Clausal Prolog, Scryer Prolog and Trealla Prolog (see the repository README).
- Every citation record quotes its statute word for word against the pinned text under `sources/` (`_tools/check_citations.py`).
- This domain has no provision-tracking ledger (`provisions.yaml`): the share of the statute it covers has not been accounted unit by unit.

Licence: EUPL-1.2. The statute text under `sources/` is not an official version of the law; see the repository `NOTICE`.
