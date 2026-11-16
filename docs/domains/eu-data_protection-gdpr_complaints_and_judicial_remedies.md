# Regulation (EU) 2016/679 (GDPR) Arts 77(1), 78(1), 78(2), 79(1) and 79(2): for the facts a caller states about one situation, whether the right to lodge a complaint with ...

`eu/data_protection/gdpr_complaints_and_judicial_remedies`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 220/220 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Regulation (EU) 2016/679 (GDPR) Arts 77(1), 78(1), 78(2), 79(1) and 79(2): for the facts a caller states about one situation, whether the right to lodge a complaint with a supervisory authority exists, whether the judicial remedy against a legally binding decision of a supervisory authority concerning the caller exists, whether the judicial remedy against a competent authority that does not handle a complaint or does not inform within three months exists, whether the judicial remedy against a controller or processor exists, and which courts Art 79(2) names. Each right is stated independently. Out of scope (handed to the caller, a lawyer or a sibling order): whether a complaint or claim would succeed, whether processing infringes the Regulation, whether the data subject's view is right, which authority to choose, the competence of the authority under Arts 55 and 56 (an attested outside fact), the counting of the three months, the legal characterisations legally binding and concerning them (tri-state judgements; unsure refers), Art 77(2), Art 78(3) and (4), Arts 80 and 82 and the definition of data subject in Art 4(1).

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02016R0679 | 2016-05-04 | 2026-11-12 | `b2ddde1d23c73c3d...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-11-12 | `65fc0d1e13fb2eaf...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-11-12 | `72879dd39a0700d1...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/data_protection/gdpr_complaints_and_judicial_remedies){ .md-button }

## Provisions deferred, and what follows

??? info "authority_duty_to_inform_the_complainant"

    **Why:** Art 77(2) says the authority with which the complaint has been lodged shall inform the complainant on the progress and the outcome of the complaint, including the possibility of a judicial remedy under Art 78. It is a duty of the authority, quoted (deferred: see the deferred set) because Art 78(2) points to the same information; it is not a limb of any query.

    **Consequence for a user:** The answers never say that an authority has or has not complied with Art 77(2); authority_inaction_remedy_right reads the caller's statement that the authority informed on the progress or the outcome.

??? info "court_of_the_authority_state"

    **Why:** Art 78(3) says proceedings against a supervisory authority are brought before the courts of the Member State where the authority is established. It is a fixed rule with no input.

    **Consequence for a user:** The answers of authority_decision_remedy_right and authority_inaction_remedy_right never say which court; the text of Art 78(3) names the courts of the State where the authority is established.

