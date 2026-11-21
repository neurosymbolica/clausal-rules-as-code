# eu/data_protection/gdpr_cooperation_with_the_supervisory_authority

> **Disclaimer.** These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

## Scope

Regulation (EU) 2016/679 (GDPR) Art 31, one request at a time: whether a caller that states it acts as a controller, a processor or the representative of one is under the duty to cooperate, on request, with the supervisory authority in the performance of its tasks, and whether an attested statement says it cooperated with that request. Answers are cooperation_not_required (no request, a request the caller judges not in the performance of the authority's tasks, or not bound), cooperation_met or cooperation_not_met (copying the attested statement), or a non-final status (input_problems, indeterminate naming the first missing key, or needs_legal_review for an absent cooperation statement or an unsure judgement on the authority's tasks). Out of scope: who is a controller, processor or representative (Arts 4(7), 4(8), 27), the authority's tasks (Art 57), its powers and corrective measures (Art 58), fines (Art 83), and whether the cooperation was sufficient, timely or complete.

## Where the open questions are

- `manifest.yaml`: `deferred_set` and `excluded_set` list the provisions deliberately not implemented, with the reason and the consequence for a user; `operative_readings` (where present) records readings of ambiguous text.
- `SIGNATURE.md`: the inputs the domain expects, the answers it gives, and the readings it takes.
- Answers that turn on an unsettled reading are returned as a referral for legal review rather than as a definite answer.

## What was checked

- 173 tests, passing on Clausal Prolog, Scryer Prolog and Trealla Prolog (see the repository README).
- Every citation record quotes its statute word for word against the pinned text under `sources/` (`_tools/check_citations.py`).
- This domain has no provision-tracking ledger (`provisions.yaml`): the share of the statute it covers has not been accounted unit by unit.

Licence: EUPL-1.2. The statute text under `sources/` is not an official version of the law; see the repository `NOTICE`.
