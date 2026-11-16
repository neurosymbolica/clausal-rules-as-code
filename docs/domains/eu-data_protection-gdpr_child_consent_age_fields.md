# Regulation (EU) 2016/679 Art 8(1) and 8(2), with the Art 4(25) cross-reference. Given one processing based on consent (Art 6(1)(a)) in relation to an information society ...

`eu/data_protection/gdpr_child_consent_age_fields`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 216/216 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Regulation (EU) 2016/679 Art 8(1) and 8(2), with the Art 4(25) cross-reference. Given one processing based on consent (Art 6(1)(a)) in relation to an information society service offered directly to a child, decides whether Art 8 bars the processing: is the child's own consent enough (age at least 16, or at least the national age of digital consent in force on the consent date, never below 13) or is consent or authorisation of the holder of parental responsibility needed. A separate field says whether the Art 8(2) duty to make reasonable efforts to verify parental consent is discharged. Out of scope, handed to the lawyer or a sibling order: validity of the consent itself (Art 4(11), Art 7, gdpr-art6-lawfulness), lawfulness of the processing on the whole, validity of a contract with a child (Art 8(3), national contract law), who holds parental responsibility, and which Member State's law applies (an input).

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02016R0679 | 2016-05-04 | 2026-09-05 | `c44dc232a4ef4465...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `b10e27dd93652da7...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/data_protection/gdpr_child_consent_age_fields){ .md-button }

## Provisions deferred, and what follows

??? info "definitions_not_applied"

    **Why:** Art 4 is pinned whole because the smallest document element that contains Art 4(25) is the article. The other definitions (personal data, processing, controller, main establishment, supervisory authority and the rest) are not read by any limb of Art 8: the profile states the facts in those terms already. The Art 4(7) controller is the subject of Art 8(2) but the profile does not need the definition.

    **Consequence for a user:** The answers do not test whether the data is personal data (Art 4(1)) or who the controller is (Art 4(7)); the caller must establish both itself, and the Art 8(2) verification falls on that controller.

