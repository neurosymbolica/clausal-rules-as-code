# eu/dora_rts_physical_hr_identity_and_access

> **Disclaimer.** These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

## Scope

For ONE financial entity presupposed to be within the scope of DORA: which of the thirty-six duties of Commission Delegated Regulation (EU) 2024/1774 Articles 18 (physical and environmental security policy), 19 (ICT security elements of the human resource policy), 20 (identity management) and 21 (access control) apply to it, whether it has performed all of them, and which are outstanding; with DORA Article 16(1), first subparagraph, as the gate that takes the entities it lists out of these Title II duties (simplified_framework_entity). Each duty is a caller judgement (true, false, unsure); an unsure judgement that decides is handed to a lawyer (needs_legal_review). Out of scope: whether the entity is a financial entity in scope (DORA Articles 2 and 3), who is an Article 16(1) entity and the simplified framework (DORA Article 16(1) second subparagraph, 16(2), 16(3); RTS Title III), DORA Articles 4 to 15, the other RTS articles and the date of application.

## Where the open questions are

- `manifest.yaml`: `deferred_set` and `excluded_set` list the provisions deliberately not implemented, with the reason and the consequence for a user; `operative_readings` (where present) records readings of ambiguous text.
- `SIGNATURE.md`: the inputs the domain expects, the answers it gives, and the readings it takes.
- Answers that turn on an unsettled reading are returned as a referral for legal review rather than as a definite answer.

## What was checked

- 175 tests, passing on Clausal Prolog, Scryer Prolog and Trealla Prolog (see the repository README).
- Every citation record quotes its statute word for word against the pinned text under `sources/` (`_tools/check_citations.py`).
- This domain has no provision-tracking ledger (`provisions.yaml`): the share of the statute it covers has not been accounted unit by unit.

Licence: EUPL-1.2. The statute text under `sources/` is not an official version of the law; see the repository `NOTICE`.
