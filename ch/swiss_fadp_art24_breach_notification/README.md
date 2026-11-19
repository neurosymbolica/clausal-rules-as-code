# ch/swiss_fadp_art24_breach_notification

> **Disclaimer.** These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

## Scope

Swiss law in force (drafter's reading, not a lawyer's): the breach-reporting duties of the Federal Act on Data Protection (DSG, SR 235.1, German text, fedlex consolidation Stand 7 July 2025, authoritative): whether the controller must report a breach of data security (DSG Art 5 letter h) to the Commissioner (EDOEB) under DSG Art 24(1), whether the processor must report it to the controller under DSG Art 24(3), and whether the controller must inform the data subject under DSG Art 24(4) or may restrict, defer or dispense with that information under DSG Art 24(5) letters a to c. For comparison, its own limb for EU GDPR Art 33(1) (the controller's notification to the supervisory authority) and a side-by-side comparison of the two authority duties on the same facts. Open-textured judgements (breach, high risk, necessity, the Art 24(5) grounds, personal data breach, unlikely risk) are handed to the caller as tri-state values; an unsure judgement that decides goes to a lawyer (needs_legal_review). Out of scope: timing ('so rasch als moeglich', the EU 72 hours), the content of a report or information (DSG Art 24(2), DSV Art 15), documentation, the Commissioner's forwarding (Art 24(5bis)), ...

## Where the open questions are

- `manifest.yaml`: `deferred_set` and `excluded_set` list the provisions deliberately not implemented, with the reason and the consequence for a user; `operative_readings` (where present) records readings of ambiguous text.
- `SIGNATURE.md`: the inputs the domain expects, the answers it gives, and the readings it takes.
- Answers that turn on an unsettled reading are returned as a referral for legal review rather than as a definite answer.

## What was checked

- 192 tests, passing on Clausal Prolog, Scryer Prolog and Trealla Prolog (see the repository README).
- Every citation record quotes its statute word for word against the pinned text under `sources/` (`_tools/check_citations.py`).
- This domain has no provision-tracking ledger (`provisions.yaml`): the share of the statute it covers has not been accounted unit by unit.

Licence: EUPL-1.2. The statute text under `sources/` is not an official version of the law; see the repository `NOTICE`.
