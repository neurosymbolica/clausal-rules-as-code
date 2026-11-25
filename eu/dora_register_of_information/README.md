# eu/dora_register_of_information

> **Disclaimer.** These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

## Scope

The register-of-information duties of ONE financial entity under Regulation (EU) 2022/2554 (DORA) Article 28(3) and Commission Implementing Regulation (EU) 2024/2956 (the ITS) Articles 2 to 6: which of the thirty-four duties apply to it and at which levels (register_of_information_duties_required/3), whether it has performed all of them (register_of_information_duties_complete/3), and which are outstanding (register_of_information_duties_outstanding/3). Each duty applies always or on one crisp trigger the caller states; its performance is the caller's judgement (true, false or unsure), an unsure judgement that decides being referred as needs_legal_review. Out of scope: whether the entity is a financial entity within the scope of DORA (presupposed; the DORA order on scope and entity types), the content of each template (Annexes I to IV of the ITS), the rest of Article 28 (deferred, formalised where it is in the DORA orders on the financial entity's ICT third-party duties and on the key contractual provisions) and the permissive ITS Art 5(2). Every reading is the drafter's, not a lawyer's.

## Where the open questions are

- `manifest.yaml`: `deferred_set` and `excluded_set` list the provisions deliberately not implemented, with the reason and the consequence for a user; `operative_readings` (where present) records readings of ambiguous text.
- `SIGNATURE.md`: the inputs the domain expects, the answers it gives, and the readings it takes.
- Answers that turn on an unsettled reading are returned as a referral for legal review rather than as a definite answer.

## What was checked

- 171 tests, passing on Clausal Prolog, Scryer Prolog and Trealla Prolog (see the repository README).
- Every citation record quotes its statute word for word against the pinned text under `sources/` (`_tools/check_citations.py`).
- This domain has no provision-tracking ledger (`provisions.yaml`): the share of the statute it covers has not been accounted unit by unit.

Licence: EUPL-1.2. The statute text under `sources/` is not an official version of the law; see the repository `NOTICE`.
