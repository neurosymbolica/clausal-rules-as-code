# eu/nis2_lex_specialis_and_definitions

> **Disclaimer.** These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

## Scope

Article 4(1), first sentence, and Article 4(2) with points (a) and (b) of Directive (EU) 2022/2555 (NIS 2), read with Article 1(2) of Regulation (EU) 2022/2554 (DORA), for a financial entity presupposed to be within DORA (open question Q5). Two questions are answered, one per group of requirements: nis2_risk_management_provisions_status (point (a) test) and nis2_incident_notification_provisions_status (point (b) test, both of its conditions), each giving nis2_provisions_disapplied, nis2_provisions_apply or out_of_scope, or a status (indeterminate, needs_legal_review, input_problems). The entity class (essential, important, out of scope) is a caller key; whether DORA's requirements are at least equivalent in effect is the caller's judgement, and an unsure judgement that decides is referred to a lawyer as open-textured. Out of scope: who is a financial entity and DORA's scope, the entity's class under Articles 2 and 3 of the Directive, the content of Articles 21 and 23 and Chapter VII, Article 4(1) second sentence, Article 4(3) guidelines, Articles 6 and 25 of the Directive and DORA Article 1 except paragraph 2. Every reading is the drafter's, not a lawyer's.

## Where the open questions are

- `manifest.yaml`: `deferred_set` and `excluded_set` list the provisions deliberately not implemented, with the reason and the consequence for a user; `operative_readings` (where present) records readings of ambiguous text.
- `SIGNATURE.md`: the inputs the domain expects, the answers it gives, and the readings it takes.
- Answers that turn on an unsettled reading are returned as a referral for legal review rather than as a definite answer.

## What was checked

- 157 tests, passing on Clausal Prolog, Scryer Prolog and Trealla Prolog (see the repository README).
- Every citation record quotes its statute word for word against the pinned text under `sources/` (`_tools/check_citations.py`).
- This domain has no provision-tracking ledger (`provisions.yaml`): the share of the statute it covers has not been accounted unit by unit.

Licence: EUPL-1.2. The statute text under `sources/` is not an official version of the law; see the repository `NOTICE`.
