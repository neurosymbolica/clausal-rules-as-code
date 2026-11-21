# eu/dora_resilience_testing_programme

> **Disclaimer.** These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

## Scope

For ONE financial entity presupposed to be within the scope of Regulation (EU) 2022/2554 (DORA), which of the digital operational resilience testing duties of Article 24(1) to (6) and Article 25(1) to (3) apply to it (resilience_testing_duties_required), whether it has performed all of them as the caller judges it (resilience_testing_duties_complete), and which of them are outstanding (resilience_testing_duties_outstanding). A microenterprise has the one duty of Art 25(3); any other entity has the eight duties of Art 24(1) to (6) and Art 25(1), the second duty of Art 24(4) when an internal tester is used, and the duty of Art 25(2) when it is a central securities depository or central counterparty. Each duty is a caller judgement (true, false, unsure); an unsure judgement that decides is referred to a lawyer. Out of scope: whether the entity is a financial entity in scope (Articles 2 and 3), proportionality and the simplified framework (Articles 4 and 16), the ICT risk-management framework (Article 6) and detection (Article 10), threat-led penetration testing (Articles 26 and 27), and the date of application (Article 64); each belongs to a sibling order or is presupposed.

## Where the open questions are

- `manifest.yaml`: `deferred_set` and `excluded_set` list the provisions deliberately not implemented, with the reason and the consequence for a user; `operative_readings` (where present) records readings of ambiguous text.
- `SIGNATURE.md`: the inputs the domain expects, the answers it gives, and the readings it takes.
- Answers that turn on an unsettled reading are returned as a referral for legal review rather than as a definite answer.

## What was checked

- 210 tests, passing on Clausal Prolog, Scryer Prolog and Trealla Prolog (see the repository README).
- Every citation record quotes its statute word for word against the pinned text under `sources/` (`_tools/check_citations.py`).
- This domain has no provision-tracking ledger (`provisions.yaml`): the share of the statute it covers has not been accounted unit by unit.

Licence: EUPL-1.2. The statute text under `sources/` is not an official version of the law; see the repository `NOTICE`.
