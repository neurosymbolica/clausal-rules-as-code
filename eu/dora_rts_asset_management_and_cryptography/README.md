# eu/dora_rts_asset_management_and_cryptography

> **Disclaimer.** These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

## Scope

The duties of ONE financial entity under Commission Delegated Regulation (EU) 2024/1774 (RTS on the ICT risk management framework) Articles 4 and 5 (ICT asset management policy and procedure) and Articles 6 and 7 (encryption, cryptographic controls and cryptographic key management), gated by Regulation (EU) 2022/2554 (DORA) Article 16(1), first subparagraph: an entity listed there answers simplified_framework_entity. Three queries: which duties apply (required), whether all are performed (complete / incomplete), and which are outstanding. Every duty is a caller judgement (true, false, unsure); an unsure judgement that decides is referred as needs_legal_review. The microenterprise exception of Art 4(2)(c) is the only condition. Out of scope: whether the entity is a financial entity within DORA (Articles 2 and 3), the simplified framework of DORA Art 16(1) second subparagraph, (2) and (3) and RTS Title III, the other RTS articles, and the DORA articles the text refers to (Articles 8, 9 and 10).

## Where the open questions are

- `manifest.yaml`: `deferred_set` and `excluded_set` list the provisions deliberately not implemented, with the reason and the consequence for a user; `operative_readings` (where present) records readings of ambiguous text.
- `SIGNATURE.md`: the inputs the domain expects, the answers it gives, and the readings it takes.
- Answers that turn on an unsettled reading are returned as a referral for legal review rather than as a definite answer.

## What was checked

- 174 tests, passing on Clausal Prolog, Scryer Prolog and Trealla Prolog (see the repository README).
- Every citation record quotes its statute word for word against the pinned text under `sources/` (`_tools/check_citations.py`).
- This domain has no provision-tracking ledger (`provisions.yaml`): the share of the statute it covers has not been accounted unit by unit.

Licence: EUPL-1.2. The statute text under `sources/` is not an official version of the law; see the repository `NOTICE`.
