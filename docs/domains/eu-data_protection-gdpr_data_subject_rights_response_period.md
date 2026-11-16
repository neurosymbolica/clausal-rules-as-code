# Regulation (EU) 2016/679 Art 12(3), with Regulation (EEC, Euratom) No 1182/71 Art 3(1) second subparagraph, 3(2)(c) and 3(4) applied to its periods (ruling Q3, ...

`eu/data_protection/gdpr_data_subject_rights_response_period`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 177/177 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Regulation (EU) 2016/679 Art 12(3), with Regulation (EEC, Euratom) No 1182/71 Art 3(1) second subparagraph, 3(2)(c) and 3(4) applied to its periods (ruling Q3, 2026-11-01, a lawyer point). Decided here: which period binds the controller for information on action taken on a request under Articles 15 to 22 (the one-month first_period, or the extended_period of three months counted from receipt when the controller claims the extension and the user judges it necessary for the complexity and number of the requests; an unsure judgement is referred, an absent one is indeterminate); the deadline date for a receipt date and a period (same date in the last month, else its last day, a Saturday or Sunday moved to the following working day; no public-holiday shift, as response_deadline/3 takes no profile); the record of the five outside facts as given or absent; and the input check of the fifty-four-key profile contract. Out of scope: 'without undue delay' (only the outer limit is computed), Art 12(2), 12(4), 12(5) and 12(6) (sibling orders on response duties), the electronic-means modality of Art 12(3), any later clock start (Q23), and the public-holiday shift of the original relation ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `92d1a62cc2ded398...` |
| CELEX 31971R1182 | as pinned | 2026-11-05 | `cf9451469dd7aa34...` |
| CELEX 31971R1182 | as pinned | 2026-11-05 | `c7d819a8ee942b7c...` |
| CELEX 31971R1182 | as pinned | 2026-11-05 | `55a56126f24456ad...` |
| CELEX 31971R1182 | as pinned | 2026-11-05 | `27a4c5d981f76151...` |
| CELEX 31971R1182 | as pinned | 2026-11-05 | `359886d5081f218d...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/data_protection/gdpr_data_subject_rights_response_period){ .md-button }

## Provisions deferred, and what follows

??? info "regulation_1182_71_article_1_scope"

    **Why:** Article 1 limits Regulation (EEC, Euratom) No 1182/71 to acts of the Council or Commission; Regulation (EU) 2016/679 is an act of the European Parliament and of the Council. This order applies Article 3 to the periods of Regulation (EU) 2016/679 by analogy (a lawyer point, see PERIODS), so no rule reads Article 1.

    **Consequence for a user:** Every deadline this order gives rests on applying Article 3 of Regulation (EEC, Euratom) No 1182/71 to Regulation (EU) 2016/679, which Article 1 of that Regulation does not itself provide: a caller that relies on the date accepts that reading, or computes the period under the rule it holds applicable.

??? info "regulation_1182_71_article_2_public_holidays_and_working_days"

    **Why:** Article 2(1) defines public holidays as the days designated as such in the Member State or in the Community institution in which action is to be taken, as published by the Commission in the Official Journal; Article 2(2) defines working days as all days other than public holidays, Sundays and Saturdays. This order chooses no Member State or institution and reads no published list: public holidays arrive as the outside fact public_holidays, and PERIODS states the working day of the Article 3(4) shift itself.

    **Consequence for a user:** response_deadline/3 moves a deadline only for a Saturday or a Sunday: where the date it gives is a public holiday of the Member State or Community institution in which the action is to be taken (Article 2(1)), the caller moves it to the following working day itself. public_holidays is only recorded by request_outside_facts/2.

