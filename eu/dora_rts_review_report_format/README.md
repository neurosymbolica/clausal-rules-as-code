# eu/dora_rts_review_report_format

> **Disclaimer.** These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

## Scope

What a financial entity's report on the review of its ICT risk management framework must be and contain under Article 27 of Commission Delegated Regulation (EU) 2024/1774 (the RTS on ICT risk management tools, methods, processes and policies): the searchable electronic format of Article 27(1) and the items of Article 27(2), points (a) to (l), with the sentences of its second subparagraph for points (c) and (f). The report is the one of DORA Article 6(5), submitted to the competent authority upon its request (third sentence, the request key); the entities of DORA Article 16(1), first subparagraph, are outside Title II (the gate). Three questions about one financial entity and its report: which duties apply (ict_risk_framework_review_report_duties_required), whether the report meets all of them (ict_risk_framework_review_report_duties_complete), and which are outstanding (ict_risk_framework_review_report_duties_outstanding). Each item is a caller judgement (true, false or unsure); unsure goes to a lawyer as an open-textured question. Out of scope: whether the entity is a financial entity within DORA (Article 2), the review itself, the request and the duty to submit (DORA Article 6), ...

## Where the open questions are

- `manifest.yaml`: `deferred_set` and `excluded_set` list the provisions deliberately not implemented, with the reason and the consequence for a user; `operative_readings` (where present) records readings of ambiguous text.
- `SIGNATURE.md`: the inputs the domain expects, the answers it gives, and the readings it takes.
- Answers that turn on an unsettled reading are returned as a referral for legal review rather than as a definite answer.

## What was checked

- 205 tests, passing on Clausal Prolog, Scryer Prolog and Trealla Prolog (see the repository README).
- Every citation record quotes its statute word for word against the pinned text under `sources/` (`_tools/check_citations.py`).
- This domain has no provision-tracking ledger (`provisions.yaml`): the share of the statute it covers has not been accounted unit by unit.

Licence: EUPL-1.2. The statute text under `sources/` is not an official version of the law; see the repository `NOTICE`.
