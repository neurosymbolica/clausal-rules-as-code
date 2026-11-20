# Whether a person or entity must be registered as a corporate service provider under the Corporate Service Providers Act 2024 (ss 2, 7 and 16): which corporate services ...

`sg/companies/csp_registration`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 90/90 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Whether a person or entity must be registered as a corporate service provider under the Corporate Service Providers Act 2024 (ss 2, 7 and 16): which corporate services it provides, whether a registration is missing, and whether the nominee-director duty applies. For ONE person or entity on ONE reference date. Drafter's reading, not a lawyer's.

## Sources

The statute text is not reproduced here. Read it at Singapore Statutes Online (SSO):

| Instrument | Link | Last read |
|---|---|---|
| CSPA2024 | <https://sso.agc.gov.sg/Act/CSPA2024?ProvIds=pr16-> | 2026-10-02 |
| CSPA2024 | <https://sso.agc.gov.sg/Act/CSPA2024?ProvIds=pr2-> | 2026-10-02 |
| CSPA2024 | <https://sso.agc.gov.sg/Act/CSPA2024?ProvIds=pr7-> | 2026-10-02 |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/sg/companies/csp_registration){ .md-button }

## Provisions deferred, and what follows

??? info "registered_qualified_individuals"

    **Why:** Order deferred_set: ss 10-11, 15 (registered qualified individuals) and the registration criteria in s 9 are out of scope; these definitions and s 2(3)(b) serve only that regime.

    **Consequence for a user:** Any RQI requirement attached to the CSP's registration must be checked separately.

??? info "transitional_registrations"

    **Why:** Order deferred_set: Part 9 saving and transitional provisions (filing agents, ACRA RQIs) are out of scope; registered_service_types is asserted current. Limb (b) covers persons treated as registered under s 42(3).

    **Consequence for a user:** A transitionally registered CSP must itself include those types in registered_service_types.

??? info "fit_and_proper_judgment"

    **Why:** Order deferred_set: whether the CSP WAS satisfied and what the prescribed factors are is supplied as booleans. s 16(2) and (a)-(b) say how the fit-and-proper determination is made; this domain does not make it. s 16(1) stays in scope. (Mapped 2026-10-04.)

    **Consequence for a user:** The caller must determine fit-and-proper status under s 16(2) and supply it.

