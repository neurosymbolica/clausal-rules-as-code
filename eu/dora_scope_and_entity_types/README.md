# eu/dora_scope_and_entity_types

> **Disclaimer.** These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

## Scope

Who is within the scope of Regulation (EU) 2022/2554 (the Digital Operational Resilience Act, DORA), and as which type of entity, from the original OJ text (32022R2554): Article 2(1) points (a) to (u), Article 2(2) (financial entities), the exclusions of Article 2(3) points (a) to (f) and the option of the Member States in the first sentence of Article 2(4), read with Article 3 points (19), (32), (36), (39), (60), (63) and (64). For ONE entity of ONE type stated by the caller, dora_scope_decision/3 answers in_scope(TYPE) or out_of_scope, and dora_entity_category/3 answers financial_entity, ict_third_party_service_provider or out_of_scope, each with fixed citations; an absent key the answer needs gives indeterminate([KEY]) and a badly formed profile gives input_problems(PROBLEMS). Out of scope: whether an entity meets the definition of a type in the Union act Article 3 refers to (the caller's classification), the relation to Article 4 of Directive (EU) 2022/2555 (NIS2), the duties of an entity in scope, the notice and publication duties of Article 2(4), second and third sentences, and the date of application (Article 64). Every reading is the drafter's, not a lawyer's.

## Where the open questions are

- `manifest.yaml`: `deferred_set` and `excluded_set` list the provisions deliberately not implemented, with the reason and the consequence for a user; `operative_readings` (where present) records readings of ambiguous text.
- `SIGNATURE.md`: the inputs the domain expects, the answers it gives, and the readings it takes.
- Answers that turn on an unsettled reading are returned as a referral for legal review rather than as a definite answer.

## What was checked

- 245 tests, passing on Clausal Prolog, Scryer Prolog and Trealla Prolog (see the repository README).
- Every citation record quotes its statute word for word against the pinned text under `sources/` (`_tools/check_citations.py`).
- This domain has no provision-tracking ledger (`provisions.yaml`): the share of the statute it covers has not been accounted unit by unit.

Licence: EUPL-1.2. The statute text under `sources/` is not an official version of the law; see the repository `NOTICE`.
