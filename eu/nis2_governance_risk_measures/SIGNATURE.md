# SIGNATURE — eu/nis2_governance_risk_measures

Public query surface: five contract queries over one PROFILE, the input check, and the facade. PROFILE is an attribute list `[attribute(KEY, VALUE), ...]` read only with `profile_get/3` (imported from formalize_lib). All queries are total and deterministic: each yields exactly ONE solution, and its answer is a final value or a status compound. No figure is imported. The only statutory value facts are the measure, factor, consideration and duty tables, and they live in the slice file. Predicate prefix: `nis2_governance_risk_measures_`.

## Verdict STATUS atoms (replace scaffold `required / permitted / not_applicable`)

`duties_apply`, `no_duties_apply`, `indeterminate`, `needs_legal_review`, `input_problems`.

The facade verdict is `nis2_governance_risk_measures_verdict(STATUS, CITATIONS)`. Mapping to query #2: `duties_apply` is the eligible analogue, `no_duties_apply` the ineligible one. Result compounds (never bare atoms): `indeterminate(MissingKeys)`, `needs_legal_review(open_textured(Key, cite(Cite)), [inputs_relied_on(Pairs)])`, `input_problems(Problems)`.

Result constructors (exact functors and arities): `duty/2`, `measure/2`, `factor/2`, `consideration/2`, `inputs_relied_on/1`, `open_textured/2`, `provenance/2`, `indeterminate/1`, `needs_legal_review/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

## Profile keys (root_exports and input_contract order)

1. `entity_class`: enumeration `essential_entity`, `important_entity`, `out_of_scope`.
2. `multi_factor_authentication_and_secured_communications_appropriate`: judgement, `true`, `false` or `unsure`.
3. `relevant_european_or_international_standards_apply`: crisp, `true` or `false`.
4. `coordinated_supply_chain_risk_assessment_carried_out`: crisp, `true` or `false`.
5. `non_compliance_with_the_art_21_2_measures_found`: crisp, `true` or `false`.

There are no numeric, money or date keys. Values are atoms, never strings or Python booleans.

## Citation-key atoms

- `eu_dir_2022_2555_art_20_1`
- `eu_dir_2022_2555_art_20_2`
- `eu_dir_2022_2555_art_21_1`
- `eu_dir_2022_2555_art_21_2`
- `eu_dir_2022_2555_art_21_2_a`
- `eu_dir_2022_2555_art_21_2_b`
- `eu_dir_2022_2555_art_21_2_c`
- `eu_dir_2022_2555_art_21_2_d`
- `eu_dir_2022_2555_art_21_2_e`
- `eu_dir_2022_2555_art_21_2_f`
- `eu_dir_2022_2555_art_21_2_g`
- `eu_dir_2022_2555_art_21_2_h`
- `eu_dir_2022_2555_art_21_2_i`
- `eu_dir_2022_2555_art_21_2_j`
- `eu_dir_2022_2555_art_21_3`
- `eu_dir_2022_2555_art_21_4`
- `eu_dir_2022_2555_art_21_5` (deferred, in the vocabulary only, never cited in an answer)

No shortened citation atom may be invented.

## Public predicates

- `decide_nis2_governance_risk_measures(Profile, nis2_governance_risk_measures_verdict(Status, Citations))`: facade verdict, a roll-up of the five queries. Arts 20 and 21.
- `nis2_governance_risk_measures_status(Profile, Status)`: the status atom alone.
- `nis2_governance_risk_measures_checklist(Profile, Checklist)`: one `item(RequirementId, Status, cite(Key))` per query, met items included. Query #7 justification.
- `nis2_governance_risk_measures_what_if(Profile, Key, Value, Result)`: re-decides with one key overridden (query_combinators `what_if/5`).
- `nis2_governance_risk_measures_fixtures(Name, Profile)`: named test profiles, one per branch.
- `nis2_governance_risk_measures_input_problems(Profile, Problems)`: bare flat list, `[]` when well-formed. Order: per contract key `duplicate_key`, else `wrong_type`; then `unknown_key` by first occurrence. A non-attribute-list gives `[wrong_type(profile)]`.
- `management_body_duties(Profile, Duties)`: a flat list of `duty(Duty, cite(Key))`, or `[]` or a status. Art 20(1)-(2).
- `risk_management_measures(Profile, Measures)`: a flat list of `measure(Name, cite(Key))`, or `[]` or a status. Art 21(1)-(2).
- `proportionality_factors(Profile, Factors)`: a flat list of `factor(Name, cite(Key))`, or `[]` or a status. Art 21(1).
- `supply_chain_considerations(Profile, Considerations)`: a flat list of `consideration(Name, cite(Key))`, or `[]` or a status. Art 21(3).
- `corrective_measures_duty(Profile, Result, Citations)`: Result is `must_take_corrective_measures_without_undue_delay`, `no_corrective_measures_duty` or a status. Citations is a flat list of `cite(Key)`, `[]` when not final. Art 21(4).

### Answer-shape rules

- A list element carries its cite inside it.
- A not-final answer is the status compound itself, never inside a list.
- `input_problems(Problems)` wraps only in answer positions.
- `indeterminate/1` holds a flat non-empty list of bare keys in root_exports order.
- Never write a bare `indeterminate` atom.
- `inputs_relied_on(Pairs)` holds `Key-Value` pairs of the PRESENT judgement keys the query reads, unsure included, optionally followed by one `provenance(Clause, Citations)`.

## Determination slice: nis2_governance_risk_measures.clausal

The whole domain is ONE slice, `nis2_governance_risk_measures.clausal`. It is self-contained and owns every value fact below.

**Statutory value facts (tables)**

- `management_body_duty_table`, in order:
  - `approve_the_cybersecurity_risk_management_measures` -> `art_20_1`
  - `oversee_the_implementation_of_the_measures` -> `art_20_1`
  - `can_be_held_liable_for_infringements_of_article_21` -> `art_20_1`
  - `members_of_the_management_bodies_follow_training` -> `art_20_2`
- `risk_management_measure_table`, 12 rows in the order of THE LIMBS:
  - `take_appropriate_and_proportionate_measures` -> `art_21_1`
  - `based_on_an_all_hazards_approach` -> `art_21_2`
  - the ten areas (a) to (j) -> `art_21_2_a` to `art_21_2_j`
  - Row (j) is `multi_factor_or_continuous_authentication_and_secured_communications`, conditional on the judgement key being `true`.
- `proportionality_factor_table`, 7 rows:
  - `state_of_the_art`
  - `relevant_european_and_international_standards`, conditional on the crisp key
  - `cost_of_implementation`
  - `degree_of_exposure_to_risks`
  - `entity_size`
  - `likelihood_of_incidents`
  - `severity_of_incidents_including_societal_and_economic_impact`
  - All cite `art_21_1`.
- `supply_chain_consideration_table`, 3 rows:
  - `vulnerabilities_specific_to_each_direct_supplier_and_service_provider`
  - `overall_quality_of_products_and_cybersecurity_practices_of_suppliers_and_service_providers`
  - `results_of_the_coordinated_security_risk_assessments_of_critical_supply_chains`, conditional on the crisp key
  - All cite `art_21_3`.
- The corrective-measures result atoms are `must_take_corrective_measures_without_undue_delay` and `no_corrective_measures_duty`, both citing `art_21_4`.

**Rules and requirements (checklist ids, one per query)**

- `input_check`
- `management_body_duties_listed`
- `risk_management_measures_listed`
- `proportionality_factors_listed`
- `supply_chain_considerations_listed`
- `corrective_measures_duty_decided`

Each is a three-clause requirement `requirement(RequirementId, Profile, Status, Citation)`, with mutually exclusive met, unmet and unknown clauses. There is no cut, no if-then-else, and no default for a missing key. The ground verdict is folded into the clause head, one clause per disjoint route.

**Verdict atoms:** as above. Roll-up order is input problems, then entity_class absent, then out_of_scope as `no_duties_apply`, then the first non-final answer among the five queries, else `duties_apply`.

**Shared predicates:** none. kernel.clausal holds only the exported result constructors and the profile contract. Parameters hold no numeric facts.

**Counting:** each list query yields its one answer exactly once. Build lists with a single clause per route, with the conditional rows resolved by head-folded route clauses and not by findall over alternatives.

**Step order:** as THE LIMBS. Input problems, then entity_class (absent, then out_of_scope), then the query's needed key (absent, then unsure), then the answer.

## Planned reuse (manifest `uses:`)

- `formalize_lib`:
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_keys/2`, `missing_keys/3`
  - `check_true/4`, `check_false/4`, `check_eq/5`
  - `assess/6`, `eval_requirements/4`, `decide_labeled/3`, `memberd/2`, `not_member/2`
  - `item/3`, `unmet/1`, `unknown/1`, `labels/3`
  - The assess closure is the name `requirement` with the RequirementId first.
- `kit.query_combinators`: `what_if/5` for the what_if predicate and `diff_checklists/3`.
- `validate_props`: `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `prop_boundary_coverage/2`.
- Not used: currency_vocab, vat_category, country, library(datetime), deadline_lib, rolling_window, compliance_lib. This skeleton has no money, dates, windows or compliance verdicts, and compliance_lib would imply an adequacy verdict this order deliberately omits.
