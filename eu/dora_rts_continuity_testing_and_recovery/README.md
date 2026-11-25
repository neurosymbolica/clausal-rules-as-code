# eu/dora_rts_continuity_testing_and_recovery

> **Disclaimer.** These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

## Scope

For ONE financial entity: which of the twenty-three duties of Articles 25 (testing of the ICT business continuity plans) and 26 (ICT response and recovery plans) of Commission Delegated Regulation (EU) 2024/1774 apply to it, whether it has performed all of them as the caller judges each, and which are outstanding; gated by Article 16(1), first subparagraph, of Regulation (EU) 2022/2554 (DORA), under which those articles do not bind the entities it lists (answered simplified_framework_entity). Conditions read: the microenterprise size class (Art 25(2)(c)), the entity type central counterparty or central securities depository (Art 25(3), 25(4)) and the use of ICT third-party service providers (Art 25(2)(b), 26(4)). Each duty is one caller judgement (true, false, unsure); an unsure judgement that decides is referred to a lawyer (needs_legal_review). Out of scope: whether the entity is a financial entity within DORA (Art 2, 3), DORA Article 11 itself, the other articles of the RTS, the simplified ICT risk management framework (DORA Art 16(1) second subparagraph, 16(2), 16(3); RTS Title III) and dates of application.

## Where the open questions are

- `manifest.yaml`: `deferred_set` and `excluded_set` list the provisions deliberately not implemented, with the reason and the consequence for a user; `operative_readings` (where present) records readings of ambiguous text.
- `SIGNATURE.md`: the inputs the domain expects, the answers it gives, and the readings it takes.
- Answers that turn on an unsettled reading are returned as a referral for legal review rather than as a definite answer.

## What was checked

- 191 tests, passing on Clausal Prolog, Scryer Prolog and Trealla Prolog (see the repository README).
- Every citation record quotes its statute word for word against the pinned text under `sources/` (`_tools/check_citations.py`).
- This domain has no provision-tracking ledger (`provisions.yaml`): the share of the statute it covers has not been accounted unit by unit.

Licence: EUPL-1.2. The statute text under `sources/` is not an official version of the law; see the repository `NOTICE`.
