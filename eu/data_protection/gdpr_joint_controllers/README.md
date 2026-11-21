# eu/data_protection/gdpr_joint_controllers

> **Disclaimer.** These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

## Scope

Regulation (EU) 2016/679 (GDPR), three rules that sibling orders leave open, each answered from the position of one party for one processing and, for Art 82, one claim for one damage. (1) Art 26(3) read with Art 28(10): whether the data subject may exercise its rights in respect of and against the caller whatever the arrangement between joint controllers says (rights_against_each_joint_controller/3); joint determination of the purposes and means is the caller's tri-state judgement and is handed to a lawyer when unsure, never tested here. (2) Art 82(4): whether the caller, stated responsible under Art 82(2) and (3) by an attested outside fact, is liable for the entire damage because at least one other involved party is responsible for the same damage (liability_for_the_entire_damage/4). (3) Art 82(5): whether a caller that paid full compensation in accordance with Art 82(4) may claim back from the listed other responsible parties (recourse_after_full_compensation/4); full payment is the caller's tri-state judgement. The input check is gdpr_joint_controllers_input_problems/2. Out of scope and decided elsewhere: Art 26(1) and (2) (gdpr-accountability-security), Art 82(1) to (3) ...

## Where the open questions are

- `manifest.yaml`: `deferred_set` and `excluded_set` list the provisions deliberately not implemented, with the reason and the consequence for a user; `operative_readings` (where present) records readings of ambiguous text.
- `SIGNATURE.md`: the inputs the domain expects, the answers it gives, and the readings it takes.
- Answers that turn on an unsettled reading are returned as a referral for legal review rather than as a definite answer.

## What was checked

- 187 tests, passing on Clausal Prolog, Scryer Prolog and Trealla Prolog (see the repository README).
- Every citation record quotes its statute word for word against the pinned text under `sources/` (`_tools/check_citations.py`).
- This domain has no provision-tracking ledger (`provisions.yaml`): the share of the statute it covers has not been accounted unit by unit.

Licence: EUPL-1.2. The statute text under `sources/` is not an official version of the law; see the repository `NOTICE`.
