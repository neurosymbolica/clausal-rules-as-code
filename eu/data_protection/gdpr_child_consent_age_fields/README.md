# eu/data_protection/gdpr_child_consent_age_fields

> **Disclaimer.** These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

## Scope

Regulation (EU) 2016/679 Art 8(1) and 8(2), with the Art 4(25) cross-reference. Given one processing based on consent (Art 6(1)(a)) in relation to an information society service offered directly to a child, decides whether Art 8 bars the processing: is the child's own consent enough (age at least 16, or at least the national age of digital consent in force on the consent date, never below 13) or is consent or authorisation of the holder of parental responsibility needed. A separate field says whether the Art 8(2) duty to make reasonable efforts to verify parental consent is discharged. Out of scope, handed to the lawyer or a sibling order: validity of the consent itself (Art 4(11), Art 7, gdpr-art6-lawfulness), lawfulness of the processing on the whole, validity of a contract with a child (Art 8(3), national contract law), who holds parental responsibility, and which Member State's law applies (an input).

## Where the open questions are

- `manifest.yaml`: `deferred_set` and `excluded_set` list the provisions deliberately not implemented, with the reason and the consequence for a user; `operative_readings` (where present) records readings of ambiguous text.
- `SIGNATURE.md`: the inputs the domain expects, the answers it gives, and the readings it takes.
- Answers that turn on an unsettled reading are returned as a referral for legal review rather than as a definite answer.

## What was checked

- 216 tests, passing on Clausal Prolog, Scryer Prolog and Trealla Prolog (see the repository README).
- Every citation record quotes its statute word for word against the pinned text under `sources/` (`_tools/check_citations.py`).
- This domain has no provision-tracking ledger (`provisions.yaml`): the share of the statute it covers has not been accounted unit by unit.

Licence: EUPL-1.2. The statute text under `sources/` is not an official version of the law; see the repository `NOTICE`.
