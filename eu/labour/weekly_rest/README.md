# eu/labour/weekly_rest

> **Disclaimer.** These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

## Scope

Whether one worker's rota, over one stated period, gives the weekly rest that Art 5 of Directive 2003/88/EC requires a Member State to ensure: the period is cut into blocks of 7 days (14 days under a reference period of Art 16(a)) from 00:00 on its first day; every minute that is not working time is rest (Art 2(1), Art 2(2)); a block holds the weekly rest when it holds one unbroken run of at least 2100 minutes (24 hours plus the 11 hours of daily rest), or 1440 minutes under the reduced minimum of Art 5 second subparagraph, two such rests in a 14-day block, measured in exact minutes. Decided here: the status (weekly_rest_status/7), the smallest block rest in minutes (shortest_weekly_rest_minutes/6), the first day of the first block without the weekly rest (first_period_without_weekly_rest/6), and the threshold boundary (weekly_rest_threshold/2); Art 5 not applied to mobile workers (Art 20(1) with Art 2(7)) and seagoing fishing vessel workers (Art 21(1)); a derogation stated under Art 17(1), 17(3), 17(4) or Art 18. Handed to the caller or a lawyer: whether on-call time is working time under national laws and/or practice (open-textured, Art 2(1)); whether the reduced minimum, a ...

## Where the open questions are

- `manifest.yaml`: `deferred_set` and `excluded_set` list the provisions deliberately not implemented, with the reason and the consequence for a user; `operative_readings` (where present) records readings of ambiguous text.
- `SIGNATURE.md`: the inputs the domain expects, the answers it gives, and the readings it takes.
- Answers that turn on an unsettled reading are returned as a referral for legal review rather than as a definite answer.

## What was checked

- 219 tests, passing on Clausal Prolog, Scryer Prolog and Trealla Prolog (see the repository README).
- Every citation record quotes its statute word for word against the pinned text under `sources/` (`_tools/check_citations.py`).
- This domain has no provision-tracking ledger (`provisions.yaml`): the share of the statute it covers has not been accounted unit by unit.

Licence: EUPL-1.2. The statute text under `sources/` is not an official version of the law; see the repository `NOTICE`.
