# Status of each domain

Generated at export by running, in this repository, each domain's tests and the public
validators (`_tools/check_citations.py`, `check_parameters.py`, `check_provisions.py`,
`check_provenance.py`). Provision tracking shows the ledger's own headline: how many
units of the pinned statute extract are formalized, deferred and unaccounted.

Hidden-test results (reference implementation, mutation testing, adversarial review) are
not listed yet; they will be added per domain in the next release.

| Domain | Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|---|
| `eu/aml/amlr_beneficial_ownership_threshold` | 105/105 | enforced: 13 units: 3 formalized, 10 deferred (9 authorized, 1 expansion), 0 unaccounted | pass | pass | pass |
| `eu/aml/amlr_bo_chain` | 84/84 | enforced: 10 units: 3 formalized, 7 deferred (2 authorized, 5 expansion), 0 unaccounted | pass | pass | pass |
| `eu/procurement/framework_agreements` | 199/199 | enforced: 13 units: 12 formalized, 1 deferred (1 authorized, 0 expansion), 0 unaccounted | pass | pass | pass |
| `eu/procurement/life_cycle_costing` | 234/234 | enforced: 15 units: 13 formalized, 2 deferred (2 authorized, 0 expansion), 0 unaccounted | pass | pass | pass |
| `eu/procurement/shortlisting` | 182/182 | enforced: 3 units: 2 formalized, 1 deferred (1 authorized, 0 expansion), 0 unaccounted | pass | pass | pass |
| `eu/procurement/time_limits` | 117/117 | enforced: 43 units: 18 formalized, 25 deferred (25 authorized, 0 expansion), 0 unaccounted | pass | pass | pass |
| `eu/procurement/utilities_negotiated_without_prior_call` | 146/146 | enforced: 14 units: 10 formalized, 4 deferred (4 authorized, 0 expansion), 0 unaccounted | pass | pass | pass |
| `eu/state_aid/de_minimis_cumulation` | 120/120 | enforced: 10 units: 4 formalized, 6 deferred (0 authorized, 6 expansion), 0 unaccounted | pass | pass | pass |
