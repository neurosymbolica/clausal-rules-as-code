# Singapore goods and services tax: whether a business is liable to register for GST under the First Schedule of the Goods and Services Tax Act 1993, on the retrospective ...

`sg/tax/gst_registration`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 86/86 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Singapore goods and services tax: whether a business is liable to register for GST under the First Schedule of the Goods and Services Tax Act 1993, on the retrospective and the prospective tests of its taxable turnover, with the date by which it must notify the Comptroller and the date its registration takes effect. For ONE business on ONE reference date. Drafter's reading, not a lawyer's.

## Sources

The statute text is not reproduced here. Read it at Singapore Statutes Online (SSO):

| Instrument | Link | Last read |
|---|---|---|
| GSTA1993 | <https://sso.agc.gov.sg/Act/GSTA1993?ProvIds=Sc1-> | 2026-10-02 |
| IA1965 | <https://sso.agc.gov.sg/Act/IA1965?ProvIds=pr50-> | 2026-10-02 |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/sg/tax/gst_registration){ .md-button }

## Provisions deferred, and what follows

??? info "quarter_basis_before_2019"

    **Why:** Order deferred_set: paragraph 1(1)(a)(i) and 4(1) (the pre-2019 rolling-four-quarters test) are out of scope; calendar_year is >= 2019. Para 1(3)(a) is the quarter-basis twin of the in-scope 1(3)(b) relief.

    **Consequence for a user:** A caller assessing a quarter ending before 1 January 2019 must apply the quarterly test, its relief and its notification rule itself.

??? info "comptroller_directions_and_discretions"

    **Why:** Order deferred_set: para 2 anti-splitting directions, the protection-of-revenue refusals (4(3), 5(2A)) and their follow-on registrations (4(4)-(5), 5(2B)-(2C)), the earlier agreed effective dates (4(2)(b), 5(2)(b)) and the discretionary early registration from day X (5(3), 5(4)) are Comptroller discretions.

    **Consequence for a user:** Where the Comptroller has given a direction, refused registration, agreed an earlier date or registered from day X, the caller must substitute that outcome for this domain's computed date.

??? info "excluded_day_extension"

    **Why:** Order deferred_set: Interpretation Act 1965 s 50(b)/(c): a period whose last day is a Sunday or public holiday runs to the next non-excluded day; NOTIFY_BY is the nominal day (needs a public-holiday calendar).

    **Consequence for a user:** If NOTIFY_BY falls on a Sunday or public holiday the caller must extend it to the next non-excluded day.

??? info "short_period_excluded_days"

    **Why:** s 50(d) applies only to periods not exceeding 6 days; every period in this domain is 30 days, so it never applies.

    **Consequence for a user:** None (inapplicable to the 30-day periods computed here).

