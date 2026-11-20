# Which licence class a payment service provider needs under the Payment Services Act 2019 (ss 5 and 6): the payment services it provides and the monthly ...

`sg/payments/psa_licence_class`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 99/99 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Which licence class a payment service provider needs under the Payment Services Act 2019 (ss 5 and 6): the payment services it provides and the monthly transaction-volume tests that separate a standard payment institution from a major payment institution. For ONE provider. Drafter's reading, not a lawyer's.

## Sources

The statute text is not reproduced here. Read it at Singapore Statutes Online (SSO):

| Instrument | Link | Last read |
|---|---|---|
| PSA2019 | <https://sso.agc.gov.sg/Act/PSA2019?ProvIds=Sc1-> | 2026-10-02 |
| PSA2019 | <https://sso.agc.gov.sg/Act/PSA2019?ProvIds=pr5-> | 2026-10-02 |
| PSA2019 | <https://sso.agc.gov.sg/Act/PSA2019?ProvIds=pr6-> | 2026-10-02 |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/sg/payments/psa_licence_class){ .md-button }

## Provisions deferred, and what follows

??? info "transition_period"

    **Why:** Order deferred_set: s 6(6): a licensee crossing a s 6(5) threshold has a prescribed period to apply to change its licence; this domain answers which licence the activity requires, not whether the licensee is yet in breach. 'Relevant date' in s 6(17) is used only by s 6(6).

    **Consequence for a user:** A licensee newly crossing a threshold must compute its prescribed grace period and application deadline itself.

??? info "service_characterisation"

    **Why:** Order deferred_set: whether an activity IS a given payment service (First Schedule Part 1, Part 2 exclusions, s 5(2), the s 2 DPT definitions) is supplied: services is asserted. First Schedule para 1 and (a)-(g) only list the seven payment services; this domain reads which services are provided as input and never decides it. (Mapped 2026-10-04; the entry existed in the order but not in this scope map. s 6(17) "e-money account issuance service" stays IN scope: the attested mixed_account_issuer reading applies it.)

    **Consequence for a user:** The caller must characterise each activity as one of the seven payment services before asking which licence it requires.

