# SIGNATURE — sg/payments/psa_licence_class

## Public query surface

The domain exposes five public predicates (scaffold facade names preserved):

| Predicate | Arity | Description | Citation |
|---|---|---|---|
| `decide_psa_licence_class/2` | 2 | Main entry: `decide_psa_licence_class(PROFILE, RESULT)` where RESULT = `psa_licence(LICENCE, MPI_TRIGGERS, VOLUME_TOTAL_CENTS, CITATIONS)`. One solution per profile. | s 5(1), s 6(2)–(5), s 6(17) |
| `psa_licence_class_status/2` | 2 | Status determination: `psa_licence_class_status(PROFILE, LICENCE)` — returns the licence-class atom only. | s 5(1), s 6(2)–(5) |
| `psa_licence_class_checklist/2` | 2 | Checklist: `psa_licence_class_checklist(PROFILE, CHECKLIST)` — returns the item-by-item assessment (which rules fired, which citations apply). | s 6(3)–(5) |
| `psa_licence_class_what_if/4` | 4 | Threshold query: `psa_licence_class_what_if(PROFILE, KEY, VALUE, RESULT)` — re-evaluates with one profile key overridden, exposing the boundary at which the outcome changes. | s 6(5) |
| `fixtures/0` | 0 | Enumerates the domain's test fixtures (ground profiles with expected verdicts). | — |

## Verdict STATUS atoms

The `LICENCE` field of `psa_licence/4` takes exactly these atoms (first-match-wins order):

1. `no_licence_required`
2. `exempt_payment_service_provider`
3. `money_changing_licence`
4. `standard_payment_institution_licence`
5. `major_payment_institution_licence`
6. `indeterminate`

The `MPI_TRIGGERS` field is a list (subset, fixed order) of:
- `single_service_volume`
- `multi_service_volume`
- `e_money_account_float`
- `e_money_issued`

## Profile keys

| Key | Required? | Type | Value vocabulary / unit |
|---|---|---|---|
| `services` | REQUIRED | list of atoms | `[account_issuance, e_money_account_issuance, domestic_money_transfer, cross_border_money_transfer, merchant_acquisition, e_money_issuance, digital_payment_token, money_changing]` (order/duplicates irrelevant; atoms outside this set are ignored) |
| `exempt_payment_service_provider` | REQUIRED | atom | `true` or `false` |
| `monthly_average_volumes` | optional | list of `volume(Service, Cents)` | Cents is a non-negative integer (S$ in cents); at most one entry per service; entries for non-provided or non-volume-tested services are ignored |
| `resident_e_money_float_cents` | optional | integer | S$ in cents; default 0 |
| `singapore_issued_other_e_money_float_cents` | optional | integer | S$ in cents; default 0 |
| `specified_e_money_issued_cents` | optional | integer | S$ in cents; default 0 |

Either REQUIRED key absent → `indeterminate`.

## Citation-key atoms

| Atom | Source |
|---|---|
| `sg_psa_2019_s5_1_a` | s 5(1)(a) — licence requirement |
| `sg_psa_2019_s5_1_b` | s 5(1)(b) — exemption |
| `sg_psa_2019_s6_2` | s 6(2) — three licence types |
| `sg_psa_2019_s6_3` | s 6(3) — money-changing licence |
| `sg_psa_2019_s6_4` | s 6(4) — SPI/MPI requirement |
| `sg_psa_2019_s6_5_a_ii_a` | s 6(5)(a)(i) — single-service $3m trigger |
| `sg_psa_2019_s6_5_a_ii_b` | s 6(5)(a)(ii) — multi-service $6m trigger |
| `sg_psa_2019_s6_5_b` | s 6(5)(b) — e-money account float $5m trigger |
| `sg_psa_2019_s6_5_c` | s 6(5)(c) — e-money issued $5m trigger |
| `sg_psa_2019_s6_17` | s 6(17) — e-money account issuance definition |
| `sg_psa_2019_first_schedule_part_1` | First Schedule Part 1 — seven payment services |

## Imports (measured from the code, 2026-10-05)

Every kit and engine-library module this package's rule files import, with the predicates imported
(read from the `:- use_module` directives of its non-test `.clausal` files; sibling `sg/...` modules omitted).
This replaces the producer's "Planned reuse" table, which listed modules and predicates the code never
imports (e.g. `kit/deadline_lib`).

| Module | Predicates imported | Imported by |
|---|---|---|
| `kit/query_combinators` | `override_key/4` | queries.clausal |
| `library(clpz)` | (whole module) | psa_licence_class.clausal |

## Determination slice: `psa_licence_class.clausal`

### Statutory value facts owned by this slice

| Name | Value (integer cents) | Source |
|---|---|---|
| `mpi_single_service_threshold_cents` | 300000000 | s 6(5)(a)(i) — S$3,000,000 |
| `mpi_multi_service_threshold_cents` | 600000000 | s 6(5)(a)(ii) — S$6,000,000 |
| `mpi_e_money_account_float_threshold_cents` | 500000000 | s 6(5)(b) — S$5,000,000 |
| `mpi_e_money_issued_threshold_cents` | 500000000 | s 6(5)(c) — S$5,000,000 |

These are declared as `:- constant_value(...)` in this file and read via `constant/1` in rule bodies. No shared constants file.

### Service vocabulary (owned by this slice)

```
account_issuance
e_money_account_issuance
domestic_money_transfer
cross_border_money_transfer
merchant_acquisition
e_money_issuance
digital_payment_token
money_changing
```

Volume-tested subset (s 6(5)(a)):
```
account_issuance
domestic_money_transfer
cross_border_money_transfer
merchant_acquisition
digital_payment_token
```

### Rules (first-match-wins, in order)

| Rule ID | Condition | Verdict | Citations |
|---|---|---|---|
| R0 (pre-rule) | Either REQUIRED key absent | `indeterminate` | `[]` |
| R1 | `services` is empty (after filtering to vocabulary) | `no_licence_required` | `[]` |
| R2 | `exempt_payment_service_provider = true` | `exempt_payment_service_provider` | `[sg_psa_2019_s5_1_b]` |
| R3 | `services` (filtered) is exactly `[money_changing]` | `money_changing_licence` | `[sg_psa_2019_s6_3]` |
| R4 | Any of the four MPI triggers fires (see below) | `major_payment_institution_licence` | `[sg_psa_2019_s6_4] ++ trigger_citations` |
| R5 | (default — no trigger fired) | `standard_payment_institution_licence` | `[sg_psa_2019_s6_4]` |

### MPI trigger definitions (all strict `>`)

| Trigger | Condition | Citation |
|---|---|---|
| `single_service_volume` | ∃ volume-tested service S provided: volume(S) > 300000000 | `sg_psa_2019_s6_5_a_ii_a` |
| `multi_service_volume` | ≥ 2 volume-tested services provided AND VOLUME_TOTAL_CENTS > 600000000 | `sg_psa_2019_s6_5_a_ii_b` |
| `e_money_account_float` | `e_money_account_issuance` provided AND (resident_e_money_float_cents + singapore_issued_other_e_money_float_cents) > 500000000 | `sg_psa_2019_s6_5_b` |
| `e_money_issued` | `e_money_issuance` provided AND specified_e_money_issued_cents > 500000000 | `sg_psa_2019_s6_5_c` |

Trigger citations in R4 are appended in the fixed order above (only those that fire).

### Verdict atoms (this slice)

`no_licence_required`, `exempt_payment_service_provider`, `money_changing_licence`, `standard_payment_institution_licence`, `major_payment_institution_licence`, `indeterminate`

### Shared predicates (belong in `kernel.clausal`)

None. This slice is fully self-contained. The only shared floor in `kernel.clausal` is the module declaration and the `psa_licence/4` compound term definition (if the scaffold places it there). No predicate is shared between slices because there is only one slice in this domain.

### Predicate inventory (this slice)

| Predicate | Arity | Role |
|---|---|---|
| `psa_licence_class/2` | 2 | Internal: `psa_licence_class(PROFILE, RESULT)` — the core decision (called by `decide_psa_licence_class/2`) |
| `psa_licence_class_volume_total/2` | 2 | Internal: compute VOLUME_TOTAL_CENTS from profile |
| `psa_licence_class_mpi_triggers/2` | 2 | Internal: compute the MPI trigger list from profile |
| `psa_licence_class_volume_for/3` | 3 | Internal: `psa_licence_class_volume_for(SERVICE, VOLUMES, CENTS)` — look up one service's volume (default 0) |
| `psa_licence_class_volume_tested_services/2` | 2 | Internal: filter provided services to the volume-tested subset |
