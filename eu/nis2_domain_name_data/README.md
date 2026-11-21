# eu/nis2_domain_name_data

> **Disclaimer.** These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

## Scope

Directive (EU) 2022/2555 (NIS 2) Article 28(1) to (6): what a Member State must require of a TLD name registry and of an entity providing domain name registration services as regards domain name registration data. Decided here: the nine duties of Art 28 for an addressed provider and none for any other entity; the registration data the database must hold (Art 28(2)(a) to (d), point (d) read per element); whether the non-personal registration data must be made publicly available (Art 28(4)); whether access to specific registration data must be provided (Art 28(5) first sentence); and whether a reply to any request for access was timely (Art 28(5) second sentence, within 72 hours of receipt, a part of an hour rounded up, and without undue delay). Out of scope: whether an entity is a TLD name registry or registrar (Art 6; the caller states it), lawfulness under Union data protection law, the adequacy of data and procedures, national access procedures, what counts as receipt of a request, and whether publication was in fact without undue delay. Open-textured judgements (personal data, legitimate access seeker, lawful and duly substantiated request, undue delay) are the caller's; an ...

## Where the open questions are

- `manifest.yaml`: `deferred_set` and `excluded_set` list the provisions deliberately not implemented, with the reason and the consequence for a user; `operative_readings` (where present) records readings of ambiguous text.
- `SIGNATURE.md`: the inputs the domain expects, the answers it gives, and the readings it takes.
- Answers that turn on an unsettled reading are returned as a referral for legal review rather than as a definite answer.

## What was checked

- 221 tests, passing on Clausal Prolog, Scryer Prolog and Trealla Prolog (see the repository README).
- Every citation record quotes its statute word for word against the pinned text under `sources/` (`_tools/check_citations.py`).
- This domain has no provision-tracking ledger (`provisions.yaml`): the share of the statute it covers has not been accounted unit by unit.

Licence: EUPL-1.2. The statute text under `sources/` is not an official version of the law; see the repository `NOTICE`.
