# eu/nis2_scope_entity_class

> **Disclaimer.** These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

## Scope

Directive (EU) 2022/2555 (NIS 2) Art 2 and Art 3, with the size categories of Art 2 of the Annex to Recommendation 2003/361/EC as Art 2(1) refers to it. Decides three questions for one entity from a profile of final figures and judgements: its size category (size_class/3), whether the Directive applies to it (scope_decision/3: the exclusions of Art 2(7), 2(9) and 2(10) first, then the thirteen grounds of Art 2(1) to 2(4)) and whether it is an essential or an important entity (entity_class/3, Art 3(1) and 3(2)). The Annex I or II type, and the open-textured points of Art 2(2)(b) to (e), are judgements of the caller: an unsure judgement that decides is handed back as needs_legal_review. Out of scope: how a Member State applies the Directive to an entity (country orders), the aggregation rules of Arts 3 to 6 of the Annex, national definitions of public administration, the Annex lists, and the obligations of Arts 21 and 23.

## Where the open questions are

- `manifest.yaml`: `deferred_set` and `excluded_set` list the provisions deliberately not implemented, with the reason and the consequence for a user; `operative_readings` (where present) records readings of ambiguous text.
- `SIGNATURE.md`: the inputs the domain expects, the answers it gives, and the readings it takes.
- Answers that turn on an unsettled reading are returned as a referral for legal review rather than as a definite answer.

## What was checked

- 268 tests, passing on Clausal Prolog, Scryer Prolog and Trealla Prolog (see the repository README).
- Every citation record quotes its statute word for word against the pinned text under `sources/` (`_tools/check_citations.py`).
- This domain has no provision-tracking ledger (`provisions.yaml`): the share of the statute it covers has not been accounted unit by unit.

Licence: EUPL-1.2. The statute text under `sources/` is not an official version of the law; see the repository `NOTICE`.
