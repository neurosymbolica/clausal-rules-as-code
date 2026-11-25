# eu/dora_rts_logging_and_network_security

> **Disclaimer.** These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

## Scope

For ONE financial entity within the scope of DORA (presupposed, not decided): which of the duties on logging (Article 12), network security management (Article 13) and securing information in transit (Article 14) of Commission Delegated Regulation (EU) 2024/1774 apply to it, whether it has performed all of them, and which are outstanding, with the rule of Regulation (EU) 2022/2554 (DORA) Article 16(1), first subparagraph, that Articles 5 to 15 of DORA do not apply to the entities it lists (answered simplified_framework_entity). Each duty is the caller's judgement (true, false or unsure); an unsure judgement that decides goes to a lawyer as needs_legal_review. Out of scope: the simplified ICT risk management framework of DORA Article 16(1), second subparagraph, (2) and (3) (deferred); the other articles of the technical standards, DORA Articles 2 to 15, the proportionality principle, the standards of Regulation (EU) No 1025/2012 and the dates of application (excluded; sibling orders).

## Where the open questions are

- `manifest.yaml`: `deferred_set` and `excluded_set` list the provisions deliberately not implemented, with the reason and the consequence for a user; `operative_readings` (where present) records readings of ambiguous text.
- `SIGNATURE.md`: the inputs the domain expects, the answers it gives, and the readings it takes.
- Answers that turn on an unsettled reading are returned as a referral for legal review rather than as a definite answer.

## What was checked

- 175 tests, passing on Clausal Prolog, Scryer Prolog and Trealla Prolog (see the repository README).
- Every citation record quotes its statute word for word against the pinned text under `sources/` (`_tools/check_citations.py`).
- This domain has no provision-tracking ledger (`provisions.yaml`): the share of the statute it covers has not been accounted unit by unit.

Licence: EUPL-1.2. The statute text under `sources/` is not an official version of the law; see the repository `NOTICE`.
