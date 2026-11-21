# eu/data_protection/gdpr_art6_lawful_basis

> **Disclaimer.** These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

## Scope

Regulation (EU) 2016/679 (GDPR), consolidated text 02016R0679-20160504, no date argument. Two bounded questions. (1) lawful_basis_status/4: whether one processing, described by one attribute-list profile, has a lawful basis under Art 6(1), and which of points (a) to (f) holds: point (a) read as the host's attested statement that consent was given with its conditions met (Art 7 is decided by the order gdpr-consent-conditions); points (b) to (e) as caller judgements of necessity; points (c) and (e) also need the attested statement that the basis is laid down by Union or Member State law (Art 6(3) first sentence); point (f) needs the caller's judgement of the legitimate interest and of the balance, and is barred for a public authority in its tasks (Art 6(1) last subparagraph). basis_claimed restricts the question to one point. (2) purpose_compatibility/4: the Art 6(4) compatibility test for processing for a new purpose, with the five factors of points (a) to (e) as optional crisp keys and the weighing left to the caller's judgement. Open-textured judgements are stated by the caller and an unsure one goes to a lawyer (needs_legal_review). Out of scope: compliance with the Regulation ...

## Where the open questions are

- `manifest.yaml`: `deferred_set` and `excluded_set` list the provisions deliberately not implemented, with the reason and the consequence for a user; `operative_readings` (where present) records readings of ambiguous text.
- `SIGNATURE.md`: the inputs the domain expects, the answers it gives, and the readings it takes.
- Answers that turn on an unsettled reading are returned as a referral for legal review rather than as a definite answer.

## What was checked

- 247 tests, passing on Clausal Prolog, Scryer Prolog and Trealla Prolog (see the repository README).
- Every citation record quotes its statute word for word against the pinned text under `sources/` (`_tools/check_citations.py`).
- This domain has no provision-tracking ledger (`provisions.yaml`): the share of the statute it covers has not been accounted unit by unit.

Licence: EUPL-1.2. The statute text under `sources/` is not an official version of the law; see the repository `NOTICE`.
