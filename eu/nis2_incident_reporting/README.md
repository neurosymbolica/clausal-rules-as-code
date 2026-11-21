# eu/nis2_incident_reporting

> **Disclaimer.** These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

## Scope

Directive (EU) 2022/2555 (NIS 2) Art 23(1), (3) and (4): for an essential or important entity and an incident taken as given, whether the incident is significant (Art 23(3)(a) or (b), each a judgement the caller states), which reporting steps of Art 23(4)(a) to (e) are due with their limits (24 hours for the early warning, 72 hours for the incident notification or 24 hours for a trust service provider whose trust services are affected, an intermediate report on request, a final report one month after the notification, and for an ongoing incident a progress report and a later final report), and whether a submitted early warning or incident notification was on time given the whole hours elapsed since becoming aware (late is late: no reasons-for-delay exception; inside the limit, without undue delay is a judgement referred to a lawyer when unsure). Out of scope: the entity class (Arts 2, 3), the definition of incident (Art 6), the competent CSIRT or authority, sector acts under Art 4, the moment of becoming aware, the content of each report, the calendar computation of the one-month limits, Art 23(2), Art 23(5) to (10) (the authorities' side) and the implementing acts under Art ...

## Where the open questions are

- `manifest.yaml`: `deferred_set` and `excluded_set` list the provisions deliberately not implemented, with the reason and the consequence for a user; `operative_readings` (where present) records readings of ambiguous text.
- `SIGNATURE.md`: the inputs the domain expects, the answers it gives, and the readings it takes.
- Answers that turn on an unsettled reading are returned as a referral for legal review rather than as a definite answer.

## What was checked

- 174 tests, passing on Clausal Prolog, Scryer Prolog and Trealla Prolog (see the repository README).
- Every citation record quotes its statute word for word against the pinned text under `sources/` (`_tools/check_citations.py`).
- This domain has no provision-tracking ledger (`provisions.yaml`): the share of the statute it covers has not been accounted unit by unit.

Licence: EUPL-1.2. The statute text under `sources/` is not an official version of the law; see the repository `NOTICE`.
