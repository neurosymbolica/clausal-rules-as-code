# eu/dora_incident_classification_thresholds

> **Disclaimer.** These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

## Scope

For ONE ICT-related incident of ONE financial entity: whether each of the eight conditions that Article 8(1) of Commission Delegated Regulation (EU) 2024/1772 reads to decide a major incident is met -- the critical services affected (Article 6) and the materiality thresholds of Article 9(1) to (6), measured as Articles 1 to 7 say, under Article 18(1) of Regulation (EU) 2022/2554 (DORA) (dora_incident_threshold_status/4); and whether the final report on a major ICT-related incident was submitted within the one-month time limit of Article 5(1)(c) of Commission Delegated Regulation (EU) 2025/301, with the weekend and bank holiday rule of Article 5(4) to (6) (dora_final_report_timeliness/5). It does NOT decide whether the incident is major (Art 8(1) itself, formalised in the order on DORA incident reporting), recurring incidents (Art 8(2)), the classification of cyber threats (DORA Art 18(2)), the time limits of the initial notification and intermediate report and the notice of a delay (Art 5(1)(a), (b), (2), (3) of 2025/301), the reporting templates of Implementing Regulation (EU) 2025/302, or whether the entity is a financial entity within the scope of DORA. Every reading is the ...

## Where the open questions are

- `manifest.yaml`: `deferred_set` and `excluded_set` list the provisions deliberately not implemented, with the reason and the consequence for a user; `operative_readings` (where present) records readings of ambiguous text.
- `SIGNATURE.md`: the inputs the domain expects, the answers it gives, and the readings it takes.
- Answers that turn on an unsettled reading are returned as a referral for legal review rather than as a definite answer.

## What was checked

- 256 tests, passing on Clausal Prolog, Scryer Prolog and Trealla Prolog (see the repository README).
- Every citation record quotes its statute word for word against the pinned text under `sources/` (`_tools/check_citations.py`).
- This domain has no provision-tracking ledger (`provisions.yaml`): the share of the statute it covers has not been accounted unit by unit.

Licence: EUPL-1.2. The statute text under `sources/` is not an official version of the law; see the repository `NOTICE`.
