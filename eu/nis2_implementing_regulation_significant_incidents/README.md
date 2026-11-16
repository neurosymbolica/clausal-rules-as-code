# eu/nis2_implementing_regulation_significant_incidents

> **Disclaimer.** These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

## Scope

Whether ONE incident of ONE relevant entity of Commission Implementing Regulation (EU) 2024/2690 (DNS service providers, TLD name registries, cloud computing, data centre, content delivery network, managed and managed security service providers, providers of online marketplaces, online search engines and social networking services platforms, trust service providers) is a significant incident for the purposes of Article 23(3) of Directive (EU) 2022/2555: Art 3(1) points (a) to (g) as alternative criteria (the money test, the four judgements, recurring incidents under Art 4, and the entity-type criteria of Arts 5 to 14), with Art 3(2) taking scheduled interruptions and planned maintenance consequences out of every criterion. Results: significant, not_significant, or a status (indeterminate naming one missing key, needs_legal_review for a decisive unsure judgement, input_problems). Out of scope: whether the event is an incident and the entity a relevant entity (Directive (EU) 2022/2555 Art 6), the trade-secret definition (Directive (EU) 2016/943 Art 2), the reporting steps (Directive (EU) 2022/2555 Art 23), the security measures of Art 2 and the Annex, and the user counting method of ...

## Where the open questions are

- `manifest.yaml`: `deferred_set` and `excluded_set` list the provisions deliberately not implemented, with the reason and the consequence for a user; `operative_readings` (where present) records readings of ambiguous text.
- `SIGNATURE.md`: the inputs the domain expects, the answers it gives, and the readings it takes.
- Answers that turn on an unsettled reading are returned as a referral for legal review rather than as a definite answer.

## What was checked

- 241 tests, passing on Clausal Prolog, Scryer Prolog and Trealla Prolog (see the repository README).
- Every citation record quotes its statute word for word against the pinned text under `sources/` (`_tools/check_citations.py`).
- This domain has no provision-tracking ledger (`provisions.yaml`): the share of the statute it covers has not been accounted unit by unit.

Licence: EUPL-1.2. The statute text under `sources/` is not an official version of the law; see the repository `NOTICE`.
