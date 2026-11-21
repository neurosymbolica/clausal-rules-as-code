# eu/nis2_scope_entity_class

> **Disclaimer.** These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

## Scope

Directive (EU) 2022/2555 (NIS 2) Art 2(1) to (4), (7), (9) and (10) and Art 3(1) and (2), with the size ceilings of Article 2 of the Annex to Commission Recommendation 2003/361/EC to which Art 2(1) refers. Decided here, from a profile of caller-stated facts and judgements: the size category of the entity (size_class/3), whether the Directive applies to it (scope_decision/3) and whether it is an essential or an important entity (entity_class/3). An absent fact that can change the answer is named (indeterminate, one key); an unsure judgement that decides is referred to a lawyer (needs_legal_review). Out of scope: whether an activity is of an Annex I or II type (a caller judgement), the SME aggregation rules of Arts 3 to 6 of the Annex to the Recommendation, the national definitions of public administration, the identification of critical entities under Directive (EU) 2022/2557, Member State extensions and exemptions under Art 2(5) and (8), whether national law applies the Directive (country orders), and jurisdiction and registration (sibling order).

## Where the open questions are

- `manifest.yaml`: `deferred_set` and `excluded_set` list the provisions deliberately not implemented, with the reason and the consequence for a user; `operative_readings` (where present) records readings of ambiguous text.
- `SIGNATURE.md`: the inputs the domain expects, the answers it gives, and the readings it takes.
- Answers that turn on an unsettled reading are returned as a referral for legal review rather than as a definite answer.

## What was checked

- 242 tests, passing on Clausal Prolog, Scryer Prolog and Trealla Prolog (see the repository README).
- Every citation record quotes its statute word for word against the pinned text under `sources/` (`_tools/check_citations.py`).
- This domain has no provision-tracking ledger (`provisions.yaml`): the share of the statute it covers has not been accounted unit by unit.

Licence: EUPL-1.2. The statute text under `sources/` is not an official version of the law; see the repository `NOTICE`.
