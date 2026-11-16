# The MAXIMUM administrative fine under Regulation (EU) 2016/679 Art 83(3) to (6): the tier (10000000 EUR / 2 % or 20000000 EUR / 4 %) by infringed provision, the ...

`eu/data_protection/gdpr_administrative_fine_maximum`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 186/186 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

The MAXIMUM administrative fine under Regulation (EU) 2016/679 Art 83(3) to (6): the tier (10000000 EUR / 2 % or 20000000 EUR / 4 %) by infringed provision, the higher-of fixed amount and percentage of the economic unit's total worldwide annual turnover for an undertaking (integer euro cents, tie gives the fixed amount), the fixed amount alone for a non-undertaking, the gravest-infringement rule of Art 83(3) for several linked, intentional or negligent infringements, and separate maxima otherwise. Out of scope, handed to the lawyer: the amount actually imposed (Art 83(1)-(2)), public authorities (Art 83(7)), procedure (Art 83(8)-(9)), whether the infringer is an undertaking, foreign-currency turnover, and provisions Art 83(4)-(6) do not list.

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02016R0679 | 2016-05-04 | 2026-09-05 | `c44dc232a4ef4465...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `6a2a99fb44e34eab...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/data_protection/gdpr_administrative_fine_maximum){ .md-button }

## Provisions deferred, and what follows

??? info "art83_7_public_authorities"

    **Why:** Each Member State may lay down whether and to what extent administrative fines may be imposed on public authorities and bodies established there. That is Member State law, not pinned and not formalized here. CHOICE (the order's author): DEFERRED, not modelled as an outside fact. Modelling it as an attested or fetched outside fact (fetcher none, as in eu/procurement/procedure-conduct) would need a public-authority input, an outside-fact key and a rule for what a Member State rule does to the Art 83(4)-(6) maximum, and Art 83(7) says nothing about the maximum, only about whether and to what extent a fine may be imposed. Open question for the operator.

    **Consequence for a user:** for a public authority the caller must check the Member State rule; this order returns the Regulation's maximum.

??? info "undertaking_and_group_turnover_computation"

    **Why:** Points (18) enterprise and (19) group of undertakings are quoted and read as the context of the judgement infringer_is_undertaking. The concept is ruled (reading 6: the competition-law economic unit, CJEU ILVA C-383/23 and Deutsche Wohnen C-807/21), but whether a given infringer is such a unit, and how the unit's turnover is composed, is not modelled: the caller supplies one turnover figure. See the excluded_set entry for Recital 150.

    **Consequence for a user:** The answer takes the turnover figure as given: the caller must decide whether the infringer forms or belongs to an economic unit and supply that unit's total worldwide annual turnover of the preceding business year itself.

??? info "preceding_financial_year_reference_point"

    **Why:** 'Preceding financial year' is not stated to precede the infringement or the decision. The order takes the figure as given by the caller and does not choose the reference year.

    **Consequence for a user:** The caller supplies the right year (open question for the operator).

