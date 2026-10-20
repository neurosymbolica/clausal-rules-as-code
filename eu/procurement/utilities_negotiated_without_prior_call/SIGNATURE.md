# SIGNATURE — eu/procurement/utilities_negotiated_without_prior_call

## Public query surface

`decide_utilities_negotiated_without_prior_call(PROFILE, utilities_negotiated_verdict(STATUS, GROUND, CITATIONS))` — the main decision: given a profile, returns exactly one verdict. STATUS is `use_lawful` or `use_unlawful`. GROUND is the carrying ground atom or `n_a`. CITATIONS is a list of citation atoms.

`utilities_negotiated_verdict(STATUS, GROUND, CITATIONS)` — result constructor: STATUS is `use_lawful`/`use_unlawful`, GROUND is the carrying ground atom or `n_a`, CITATIONS is the list of pinpoint citation atoms | Dir 2014/25/EU Art 50

`utilities_negotiated_without_prior_call_status(PROFILE, STATUS)` — projects just the status atom from the decision.

`utilities_negotiated_without_prior_call_checklist(PROFILE, CHECKLIST)` — the per-condition checklist with `item(REQ_ID, STATUS, CITATION)` rows carrying `cite(...)` provenance on every item (met and unmet alike).

`utilities_negotiated_without_prior_call_what_if(PROFILE, KEY, VALUE, RESULT)` — counterfactual: override one profile key and re-decide.

`utilities_negotiated_without_prior_call_unmet_count(PROFILE, COUNT)` — calculation: the number of unmet conditions for the pleaded ground (the figure the rules dictate when the use is refused or partially supported).

`fixtures` — ground-truth test profiles for the oracle.

## STATUS vocabulary

- `use_lawful` — the negotiated procedure without prior call is lawful under the pleaded ground
- `use_unlawful` — no ground in the exhaustive list is made out; the chapeau refuses the use

## GROUND vocabulary (pleaded ground atoms)

- `art_50_a_no_suitable_tenders`
- `art_50_b_research_contract`
- `art_50_c_sole_operator`
- `art_50_d_extreme_urgency`
- `art_50_e_additional_deliveries`
- `art_50_f_repetition`
- `art_50_g_commodity_market`
- `art_50_h_bargain_purchase`
- `art_50_i_advantageous_winding_up`
- `art_50_j_design_contest`
- `n_a` (used in the verdict when STATUS is `use_unlawful`)

## Contract-type atoms (imported from eu.procurement.directive_2014_24.vocabulary — never re-declared)

- `works`
- `supplies`
- `services`

## Sole-operator reason atoms (local to this domain)

- `unique_artistic_work_or_performance`
- `competition_absent_for_technical_reasons`
- `protection_of_exclusive_rights`

## Profile keys

| Key | Type | Value vocabulary |
|---|---|---|
| `pleaded_ground_key` | atom | one of the ten ground atoms above |
| `contract_type_key` | atom | `works` \| `supplies` \| `services` |
| `sole_operator_reason_key` | atom | one of the three sole-operator reason atoms (relevant only for ground c) |
| `no_suitable_tenders_or_requests_received` | bool | true / false / absent |
| `initial_conditions_not_substantially_altered` | bool | true / false / absent |
| `contract_purely_for_research_experiment_study_or_development` | bool | true / false / absent |
| `not_for_securing_profit_or_recovering_research_costs` | bool | true / false / absent |
| `award_does_not_prejudice_competitive_award_of_subsequent_contracts` | bool | true / false / absent |
| `only_particular_operator_can_perform` | bool | true / false / absent |
| `no_reasonable_alternative_or_substitute` | bool | true / false / absent |
| `absence_of_competition_not_artificially_narrowed` | bool | true / false / absent |
| `extreme_urgency_time_limits_cannot_be_met` | bool | true / false / absent |
| `urgency_events_unforeseeable_by_contracting_entity` | bool | true / false / absent |
| `urgency_not_attributable_to_contracting_entity` | bool | true / false / absent |
| `additional_deliveries_by_original_supplier` | bool | true / false / absent |
| `change_of_supplier_would_cause_technical_incompatibility` | bool | true / false / absent |
| `repetition_conforms_to_basic_project` | bool | true / false / absent |
| `original_contract_followed_article_44_1_procedure` | bool | true / false / absent |
| `basic_project_indicated_extent_and_conditions` | bool | true / false / absent |
| `possible_use_of_this_procedure_disclosed_at_first_tender` | bool | true / false / absent |
| `supplies_quoted_and_purchased_on_commodity_market` | bool | true / false / absent |
| `bargain_opportunity_available_for_very_short_time` | bool | true / false / absent |
| `price_considerably_lower_than_normal_market_prices` | bool | true / false / absent |
| `particularly_advantageous_conditions_from_winding_up_or_liquidator` | bool | true / false / absent |
| `supplier_winding_up_or_in_insolvency_procedure` | bool | true / false / absent |
| `contract_follows_directive_design_contest` | bool | true / false / absent |
| `awarded_to_contest_winner_or_all_winners_invited` | bool | true / false / absent |

## Citation-key atoms

| Atom | Refers to |
|---|---|
| `eu_dir_2014_25_art_50_chapeau` | Art 50 chapeau (exhaustive gateway) |
| `eu_dir_2014_25_art_50_a` | Art 50(a) |
| `eu_dir_2014_25_art_50_b` | Art 50(b) |
| `eu_dir_2014_25_art_50_c` | Art 50(c) (general) |
| `eu_dir_2014_25_art_50_c_i` | Art 50(c)(i) unique art |
| `eu_dir_2014_25_art_50_c_ii` | Art 50(c)(ii) technical reasons |
| `eu_dir_2014_25_art_50_c_iii` | Art 50(c)(iii) exclusive rights |
| `eu_dir_2014_25_art_50_d` | Art 50(d) |
| `eu_dir_2014_25_art_50_e` | Art 50(e) |
| `eu_dir_2014_25_art_50_f` | Art 50(f) |
| `eu_dir_2014_25_art_50_g` | Art 50(g) |
| `eu_dir_2014_25_art_50_h` | Art 50(h) |
| `eu_dir_2014_25_art_50_i` | Art 50(i) |
| `eu_dir_2014_25_art_50_j` | Art 50(j) |

## Public predicates

| Predicate | Description | Citation |
|---|---|---|
| `decide_utilities_negotiated_without_prior_call(PROFILE, VERDICT)` | Main decision: returns `utilities_negotiated_verdict(STATUS, GROUND, CITATIONS)` | Dir 2014/25/EU Art 50 |
| `utilities_negotiated_verdict(STATUS, GROUND, CITATIONS)` | Result constructor: STATUS is `use_lawful`/`use_unlawful`, GROUND is the carrying ground atom or `n_a`, CITATIONS is the list of pinpoint citation atoms | Dir 2014/25/EU Art 50 |
| `utilities_negotiated_without_prior_call_status(PROFILE, STATUS)` | Projects the status atom from the decision | Dir 2014/25/EU Art 50 |
| `utilities_negotiated_without_prior_call_checklist(PROFILE, CHECKLIST)` | Per-condition checklist with `item(REQ_ID, STATUS, CITATION)` rows and `cite(...)` provenance | Dir 2014/25/EU Art 50 |
| `utilities_negotiated_without_prior_call_what_if(PROFILE, KEY, VALUE, RESULT)` | Counterfactual: override one key, re-decide | Dir 2014/25/EU Art 50 |
| `utilities_negotiated_without_prior_call_unmet_count(PROFILE, COUNT)` | Calculation: number of unmet conditions for the pleaded ground | Dir 2014/25/EU Art 50 |
| `fixtures` | Ground-truth test profiles for the oracle | — |

## Planned reuse

| Module | What is imported | Why |
|---|---|---|
| `eu.procurement.directive_2014_24.vocabulary` | `works`, `supplies`, `services` (contract-type atoms) | Backbone contract-type vocabulary; never re-declared in this package |
| `formalize_lib` | `profile_get`, `check_true`, `check_false`, `assess`, `item`, `met`, `unmet`, `unknown`, `labels`, `assessment`, `decide_labeled`, `summarize`, `has_unmet`, `has_unknown`, `classify_labeled` | Profile access, tri-valued checks, checklist engine, verdict classification |
| `kit.query_combinators` | `what_if`, `override_key` | What-if query type (counterfactual override) |
| `validate_props` | `run_prop`, `prop_totality`, `prop_determinism`, `prop_citation_complete` | Verification properties for the test suite |

## Genuinely local vocabulary

All ground atoms, sole-operator reason atoms, boolean condition keys, and citation atoms are local to this domain. The contract-type atoms (`works`, `supplies`, `services`) are imported from the backbone and re-exported through the package root via `__init__`.

---

## Determination slice: `utilities_negotiated_without_prior_call.clausal`

### Statutory value facts owned by this slice

There are no numeric thresholds, periods, or tables in this domain. All conditions are qualitative booleans supplied as atomic inputs. The only "values" are the categorical atoms (ground keys, contract types, sole-operator reasons) and the boolean findings. No monetary thresholds, no date windows, no percentage limits. The sole numeric output is the unmet-condition count (a simple integer derived from the checklist).

### Rules / requirements per ground

| Ground | Conditions (all must be met for the ground to carry) | Type gate |
|---|---|---|
| (a) | `no_suitable_tenders_or_requests_received` AND `initial_conditions_not_substantially_altered` | none |
| (b) | `contract_purely_for_research_experiment_study_or_development` AND `not_for_securing_profit_or_recovering_research_costs` AND `award_does_not_prejudice_competitive_award_of_subsequent_contracts` | none |
| (c) | `only_particular_operator_can_perform` AND (if reason is (i): no further conditions; if reason is (ii) or (iii): `no_reasonable_alternative_or_substitute` AND `absence_of_competition_not_artificially_narrowed`) | none |
| (d) | `extreme_urgency_time_limits_cannot_be_met` AND `urgency_events_unforeseeable_by_contracting_entity` AND `urgency_not_attributable_to_contracting_entity` | none |
| (e) | `additional_deliveries_by_original_supplier` AND `change_of_supplier_would_cause_technical_incompatibility` | supplies only |
| (f) | `repetition_conforms_to_basic_project` AND `original_contract_followed_article_44_1_procedure` AND `basic_project_indicated_extent_and_conditions` AND `possible_use_of_this_procedure_disclosed_at_first_tender` | works or services |
| (g) | `supplies_quoted_and_purchased_on_commodity_market` | supplies only |
| (h) | `bargain_opportunity_available_for_very_short_time` AND `price_considerably_lower_than_normal_market_prices` | supplies only |
| (i) | `particularly_advantageous_conditions_from_winding_up_or_liquidator` AND `supplier_winding_up_or_in_insolvency_procedure` | supplies or services |
| (j) | `contract_follows_directive_design_contest` AND `awarded_to_contest_winner_or_all_winners_invited` | services only |

### Verdict vocabulary (this slice)

- `use_lawful` / `use_unlawful` (status)
- The ten ground atoms + `n_a` (ground)
- The fourteen citation atoms listed above

### Vocabulary shared with kernel.clausal

The contract-type atoms (`works`, `supplies`, `services`) are imported from `eu.procurement.directive_2014_24.vocabulary` and re-exported through the package root via `__init__`. No other vocabulary is shared with another slice (this domain has exactly one determination slice). The kernel provides only the package-level re-export mechanism and the shared `utilities_negotiated_verdict/3` result constructor.
