# eu/nis2_incident_reporting

> **Disclaimer.** These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

## Scope

Directive (EU) 2022/2555 (NIS 2) Art 23(1), (3), (4): whether an incident is significant (either of two judgement limbs), which reporting steps are then due (early warning, incident notification, intermediate report, final report, progress report and later final report) and whether the early warning and the incident notification were in time (24 and 72 hour limits, 24 for a trust service provider's notification, no excuse after the limit, plus a without-undue-delay judgement). Out of scope and handed to the lawyer: entity class, recipient authority, definition of incident, sector-specific acts, calendar-month periods, content of the reports, notification of service recipients, Art 23(2), and Implementing Regulation (EU) 2024/2690.

## Where the open questions are

- `manifest.yaml`: `deferred_set` and `excluded_set` list the provisions deliberately not implemented, with the reason and the consequence for a user; `operative_readings` (where present) records readings of ambiguous text.
- `SIGNATURE.md`: the inputs the domain expects, the answers it gives, and the readings it takes.
- Answers that turn on an unsettled reading are returned as a referral for legal review rather than as a definite answer.

## What was checked

- 115 tests, passing on Clausal Prolog, Scryer Prolog and Trealla Prolog (see the repository README).
- Every citation record quotes its statute word for word against the pinned text under `sources/` (`_tools/check_citations.py`).
- This domain has no provision-tracking ledger (`provisions.yaml`): the share of the statute it covers has not been accounted unit by unit.

Licence: EUPL-1.2. The statute text under `sources/` is not an official version of the law; see the repository `NOTICE`.
