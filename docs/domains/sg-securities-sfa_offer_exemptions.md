# Whether an offer of securities in Singapore is exempt from the prospectus requirement under the Securities and Futures Act 2001 (ss 272A, 272B, 274 and 275), on the size ...

`sg/securities/sfa_offer_exemptions`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 68/68 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Whether an offer of securities in Singapore is exempt from the prospectus requirement under the Securities and Futures Act 2001 (ss 272A, 272B, 274 and 275), on the size of the offer, the status of the investors and the offers made in the preceding window. For ONE offer. Drafter's reading, not a lawyer's.

## Sources

The statute text is not reproduced here. Read it at Singapore Statutes Online (SSO):

| Instrument | Link | Last read |
|---|---|---|
| SFA2001 | <https://sso.agc.gov.sg/Act/SFA2001?ProvIds=pr272A-> | 2026-10-02 |
| SFA2001 | <https://sso.agc.gov.sg/Act/SFA2001?ProvIds=pr272B-> | 2026-10-02 |
| SFA2001 | <https://sso.agc.gov.sg/Act/SFA2001?ProvIds=pr274-> | 2026-10-02 |
| SFA2001 | <https://sso.agc.gov.sg/Act/SFA2001?ProvIds=pr275-> | 2026-10-02 |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/sg/securities/sfa_offer_exemptions){ .md-button }

## Provisions deferred, and what follows

??? info "amount_substitution_orders"

    **Why:** Order deferred_set: s 272A(1)(a)(ii), s 272B(2), s 275(4): the Authority may substitute the amounts; the statutory figures are used.

    **Consequence for a user:** If the Authority has prescribed a substitute amount or number, the caller must apply it instead of this domain's statutory figure.

??? info "closely_related_offers"

    **Why:** Order deferred_set: s 272A(5)-(6) / s 272B(3)-(4) aggregation of closely related offers by prescribed factors; the supplier lists the offers to aggregate.

    **Consequence for a user:** The caller must identify closely related offers (including CIS offers under ss 302B/302C) and include them in prior_small_offers / prior_private_placement_offerees.

