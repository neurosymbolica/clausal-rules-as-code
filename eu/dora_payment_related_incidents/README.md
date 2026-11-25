# eu/dora_payment_related_incidents

> **Disclaimer.** These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

## Scope

Article 23 of Regulation (EU) 2022/2554 (DORA), read with Article 2(1), points (a) to (d), Article 3, points (9), (11), (32) and (35) to (39), Article 18(3), point (a), and Article 19(1), first, third and sixth subparagraphs. For one incident of one financial entity it decides (1) payment_related_incident_status: whether Article 23 reaches the entity, whether the incident is an operational or security payment-related incident, and whether it is a major one subject to the reporting obligation of Article 19(1); and (2) payment_related_incident_report_recipients: for a major incident, to whom the entity reports (the relevant competent authority, or the national competent authority designated under Directive 2013/36/EU for a significant credit institution, and the Directive (EU) 2022/2555 authorities or CSIRTs where the Member State has so determined). Whether the incident is payment-related and whether it is major are the caller's judgements; unsure is referred to a lawyer as open_textured. Out of scope: the reports, time limits and client information (sibling order dora-incident-reporting), the content of reports, what the authorities do with them, the classification criteria and ...

## Where the open questions are

- `manifest.yaml`: `deferred_set` and `excluded_set` list the provisions deliberately not implemented, with the reason and the consequence for a user; `operative_readings` (where present) records readings of ambiguous text.
- `SIGNATURE.md`: the inputs the domain expects, the answers it gives, and the readings it takes.
- Answers that turn on an unsettled reading are returned as a referral for legal review rather than as a definite answer.

## What was checked

- 193 tests, passing on Clausal Prolog, Scryer Prolog and Trealla Prolog (see the repository README).
- Every citation record quotes its statute word for word against the pinned text under `sources/` (`_tools/check_citations.py`).
- This domain has no provision-tracking ledger (`provisions.yaml`): the share of the statute it covers has not been accounted unit by unit.

Licence: EUPL-1.2. The statute text under `sources/` is not an official version of the law; see the repository `NOTICE`.
