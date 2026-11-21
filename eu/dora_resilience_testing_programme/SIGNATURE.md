# SIGNATURE — eu/dora_resilience_testing_programme

Shape family: **deontic**. Predicate prefix: `dora_resilience_testing_programme_`.

Layout: `kernel -> citations -> parameters -> dora_resilience_testing_programme -> queries -> fixtures -> package facade`. No file or module is renamed.

Instrument: Regulation (EU) 2022/2554 (DORA), Arts 24 and 25, pinned text 32022R2554 (original OJ text).

## 1. Public query surface

### Contract predicates (scored)

These four predicates are scored. Each yields EXACTLY ONE solution per call, for every PROFILE.

- `resilience_testing_duties_required(Profile, Result, Citations)`: which duties of Arts 24 and 25 apply. Cites `eu_reg_2022_2554_art_24_1`..`art_24_6`, `art_25_1`, `art_25_2`, `art_25_3` as its list requires.
- `resilience_testing_duties_complete(Profile, Result, Citations)`: whether every applicable duty is performed. On `complete` or `incomplete` it cites the fixed nine keys.
- `resilience_testing_duties_outstanding(Profile, Result, Citations)`: which applicable duties are not performed. On `none_outstanding` it cites the fixed nine keys; on `outstanding(D)` it cites the key of each duty in `D`.
- `dora_resilience_testing_programme_input_problems(Profile, Problems)`: the typed input check (INTERFACE - THE INPUT CHECK). It never fails and never raises. Citation: none (structural).

### Facade (scaffold names kept)

- `decide_dora_resilience_testing_programme(Profile, dora_resilience_testing_programme_verdict(Status, Citations))`: the eligibility-style verdict. `Status` and `Citations` are exactly the `Result` and `Citations` of `resilience_testing_duties_complete/3`. Cites DORA Art 24(1)-(6) and Art 25(1)-(3).
- `dora_resilience_testing_programme_status(Profile, Status)`: `Status` only, from the same call. Cites DORA Arts 24 and 25.
- `dora_resilience_testing_programme_checklist(Profile, Checklist)`: the justification view (query type #7). It is `assess/6` over the eleven duty ids with the slice's `requirement/4` closure and `labels(complete, indeterminate, incomplete)`. Every item is `item(Duty, Status, cite(Key))`, and every item carries cite provenance, met items included. Cites the duty's own paragraph key.
- `dora_resilience_testing_programme_what_if(Profile, Key, Value, Result)`: re-decides `resilience_testing_duties_complete` with `Key` set to `Value`, via `kit/query_combinators` `what_if/5` with the closure `decide_complete_result`. Cites as the re-decided verdict.
- `dora_resilience_testing_programme_compliance_check(Profile, Action, Verdict)`: query type #13.
  - `Action` is `omit(DutyAtom)`.
  - The predicate uses `kit/compliance_lib` `compliance_check/7`, with an `Applies` closure over the slice's duty applicability and the norm `nm(DutyAtom, obligatory)`.
  - Omitting a duty that applies is forbidden; omitting one that does not apply is permitted.
  - Unknown applicability fires no norm, under the kit's open-world `CombiningWorld` atom (to be confirmed against kit/compliance_lib in P2).
  - `Verdict` is the kit's `verdict/5` term. Cites the duty's paragraph key.
- `dora_resilience_testing_programme_fixture(Name, Profile)`: fixtures (named profiles for the seven test modes). No citation.

Result constructors are exported and never called as queries: `required/1`, `outstanding/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

## 2. Verdict STATUS atoms (replacing the placeholders `required, permitted, not_applicable`)

### Final answers

- `required(Duties)`, arity 1, from `resilience_testing_duties_required`.
- `complete` and `incomplete`, from `resilience_testing_duties_complete` and the facade `Status`.
- `none_outstanding` and `outstanding(Duties)`, arity 1, from `resilience_testing_duties_outstanding`.

### Status compounds (never final; `Citations` is always `[]`)

- `indeterminate([Key])`: exactly one bare key atom. The bare atom `indeterminate` is NEVER written.
- `needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)])`: may be followed by one unscored `provenance(Clause, Citations)`.
- `input_problems(Problems)`.

### Duty atoms (result atoms only, in DUTY ORDER)

`resilience_testing_programme`, `range_of_assessments_and_tests`, `risk_based_testing_approach`, `independent_testers`, `internal_tester_resources_and_conflicts_of_interest`, `issue_prioritisation_classification_and_remedy`, `internal_validation_methodologies`, `yearly_testing_of_critical_ict_systems`, `execution_of_appropriate_tests`, `vulnerability_assessments_before_deployment`, `microenterprise_risk_based_planned_testing`.

### Input problem terms

`duplicate_key(Key)`, `wrong_type(Key)`, `unknown_key(Key)`, and `wrong_type(profile)`.

The atoms `true` and `false` are never pinned in verdict_vocabulary or root_exports.

## 3. Profile keys (root_exports / input_contract order)

`Profile` is `[attribute(Key, Value), ...]`, read ONLY with `profile_get/3`: by presence first, then by value. There are no numeric keys (so no unit suffixes) and no date keys (reading (16): no date is read).

| # | Key | Type | Values |
|---|---|---|---|
| 1 | `financial_entity_is_microenterprise` | fact | `true` / `false` |
| 2 | `dora_entity_type` | entity_type | one of 29 atoms (below) |
| 3 | `tests_undertaken_by_internal_tester` | fact | `true` / `false` |
| 4 | `resilience_testing_programme_established_maintained_and_reviewed` | judgement | `true` / `false` / `unsure` |
| 5 | `programme_includes_range_of_assessments_and_tests` | judgement | tri-state |
| 6 | `programme_conducted_on_risk_based_approach` | judgement | tri-state |
| 7 | `tests_undertaken_by_independent_parties` | judgement | tri-state |
| 8 | `internal_tester_resourced_and_conflicts_of_interest_avoided` | judgement | tri-state |
| 9 | `procedures_to_prioritise_classify_and_remedy_issues_established` | judgement | tri-state |
| 10 | `internal_validation_methodologies_established` | judgement | tri-state |
| 11 | `critical_ict_systems_tested_at_least_yearly` | judgement | tri-state |
| 12 | `programme_provides_for_appropriate_tests` | judgement | tri-state |
| 13 | `vulnerability_assessments_performed_before_deployment` | judgement | tri-state |
| 14 | `microenterprise_tests_risk_based_and_planned` | judgement | tri-state |

The 29 `dora_entity_type` atoms are:

`credit_institution`, `institution_exempted_pursuant_to_directive_2013_36`, `payment_institution`, `exempted_payment_institution`, `account_information_service_provider`, `electronic_money_institution`, `exempted_electronic_money_institution`, `investment_firm`, `crypto_asset_service_provider`, `issuer_of_asset_referenced_tokens`, `central_securities_depository`, `central_counterparty`, `trading_venue`, `trade_repository`, `manager_of_alternative_investment_funds`, `management_company`, `data_reporting_service_provider`, `insurance_undertaking`, `reinsurance_undertaking`, `insurance_intermediary`, `reinsurance_intermediary`, `ancillary_insurance_intermediary`, `institution_for_occupational_retirement_provision`, `credit_rating_agency`, `administrator_of_critical_benchmarks`, `crowdfunding_service_provider`, `securitisation_repository`, `ict_third_party_service_provider`, `none_of_the_listed_types`.

In the typed input_contract:

- `judgement` is `one_of(boolean, unsure)`.
- `fact` is `boolean`, meaning the atoms `true` and `false`, never Python booleans.
- `entity_type` is the enum of the 29 atoms.

## 4. Citation-key atoms (canonical lexicon scheme, `_lexicon/citations.yaml`; never shortened)

- `eu_reg_2022_2554_art_24_1`: DORA Art 24(1), the testing programme.
- `eu_reg_2022_2554_art_24_2`: DORA Art 24(2), the range.
- `eu_reg_2022_2554_art_24_3`: DORA Art 24(3), the risk-based approach.
- `eu_reg_2022_2554_art_24_4`: DORA Art 24(4), independent testers and the internal tester (both sentences).
- `eu_reg_2022_2554_art_24_5`: DORA Art 24(5), remedy procedures and internal validation (both limbs).
- `eu_reg_2022_2554_art_24_6`: DORA Art 24(6), yearly tests.
- `eu_reg_2022_2554_art_25_1`: DORA Art 25(1), appropriate tests.
- `eu_reg_2022_2554_art_25_2`: DORA Art 25(2), CSD/CCP vulnerability assessments.
- `eu_reg_2022_2554_art_25_3`: DORA Art 25(3), microenterprises.

All nine are declared in `citations.clausal` (citation_vocabulary). They are used only as `cite(Key)`.

## 5. File responsibilities

- **`kernel.clausal`** (the shared floor; only what the slice, the queries and the facade all need):
  - `contract_key/2` (position, key) in root_exports order.
  - `key_type/2` (key, `fact` | `judgement` | `entity_type`).
  - `entity_type_atom/1` (the 29 atoms).
  - `value_has_type/2`.
  - `dora_resilience_testing_programme_input_problems/2`. This covers duplicate detection by `==`, the per-key wrong_type check, `unknown_key` in first-occurrence order, `wrong_type(profile)` for non-attribute-lists, partial lists, unbound elements and unbound profiles, and the rule that an unbound value is `wrong_type(Key)`.
  - `present_pairs/2`, which builds `Key-Value` pairs of every present contract key in root_exports order. This is PAIRS.
- **`citations.clausal`**: the nine citation keys above.
- **`parameters.clausal`**: no statutory figures. The order has no thresholds, periods or amounts. It records only, as a comment, that the application date (Art 64, 17 January 2025) is not read. Nothing is re-declared elsewhere.
- **`dora_resilience_testing_programme.clausal`**: the determination slice (section 6).
- **`queries.clausal`**: the three contract queries, each a thin, deterministic call into the slice's step predicates, plus the facade predicates of section 1.
- **`fixtures.clausal`**: `dora_resilience_testing_programme_fixture/2`.

## 6. Slice — `dora_resilience_testing_programme.clausal`

### 6.1 Statutory value facts (owned here, not in a shared constants file)

- `duty/5` gives each duty's position, atom, citation key, profile key and applicability condition, in DUTY ORDER:
  1. `duty(1, resilience_testing_programme, eu_reg_2022_2554_art_24_1, resilience_testing_programme_established_maintained_and_reviewed, not_microenterprise)`
  2. `duty(2, range_of_assessments_and_tests, eu_reg_2022_2554_art_24_2, programme_includes_range_of_assessments_and_tests, not_microenterprise)`
  3. `duty(3, risk_based_testing_approach, eu_reg_2022_2554_art_24_3, programme_conducted_on_risk_based_approach, not_microenterprise)`
  4. `duty(4, independent_testers, eu_reg_2022_2554_art_24_4, tests_undertaken_by_independent_parties, not_microenterprise)`
  5. `duty(5, internal_tester_resources_and_conflicts_of_interest, eu_reg_2022_2554_art_24_4, internal_tester_resourced_and_conflicts_of_interest_avoided, not_microenterprise_with_internal_tester)`
  6. `duty(6, issue_prioritisation_classification_and_remedy, eu_reg_2022_2554_art_24_5, procedures_to_prioritise_classify_and_remedy_issues_established, not_microenterprise)`
  7. `duty(7, internal_validation_methodologies, eu_reg_2022_2554_art_24_5, internal_validation_methodologies_established, not_microenterprise)`
  8. `duty(8, yearly_testing_of_critical_ict_systems, eu_reg_2022_2554_art_24_6, critical_ict_systems_tested_at_least_yearly, not_microenterprise)`
  9. `duty(9, execution_of_appropriate_tests, eu_reg_2022_2554_art_25_1, programme_provides_for_appropriate_tests, not_microenterprise)`
  10. `duty(10, vulnerability_assessments_before_deployment, eu_reg_2022_2554_art_25_2, vulnerability_assessments_performed_before_deployment, not_microenterprise_central_depository_or_counterparty)`
  11. `duty(11, microenterprise_risk_based_planned_testing, eu_reg_2022_2554_art_25_3, microenterprise_tests_risk_based_and_planned, microenterprise)`
- `central_depository_or_counterparty_type/1`: `central_securities_depository`, `central_counterparty`. Every other atom of the 29 is an OTHER TYPE.
- `always_duty_key/1`: the keys of duties 1-4 and 6-9.
- `referral_row(Key, cite(Citation), Inputs)`: one row per judgement key. `Citation` is the duty's citation key (`internal_tester_...` gives `art_24_4`; `microenterprise_tests_...` gives `art_25_3`). `Inputs` is all fourteen contract keys.
- `checked_citations/1`: the fixed nine `cite(...)` list for `complete`, `incomplete` and `none_outstanding` (reading (18)).

### 6.2 Rules and requirements

Here 'not true' means `false`, `unsure` or absent. Every predicate is cut-free: no `!`, `->` or `*->`. Constant verdicts are folded into clause heads (C17), one clause per disjoint route.

#### Defeasible applicability

- The Art 24/25(1)/25(2) duties are DEFEATED by `financial_entity_is_microenterprise` true.
- Duty 11 is defeated by it being false.
- Duty 5 is defeated by `tests_undertaken_by_internal_tester` false.
- Duty 10 is defeated by an OTHER TYPE.
- These are written as `defeater/3` rows, checked with `formalize_lib` `not_defeated/3`. Each defeater lookup is guarded by `once/1` so that a defeater proven twice yields one answer (cut-free).
- `duty_applies(Profile, Duty)` and `duty_inapplicable(Profile, Duty)` are disjoint, and both fail while the deciding fact key is absent.

#### The branch (duties 1-10)

- `branch_fails(Profile)` holds when any of these is true:
  - an always-duty key is false;
  - key 8 is false and `tests_undertaken_by_internal_tester` is true;
  - key 13 is false and the type is CSD or CCP.
- `branch_passes(Profile)` holds when all of these are true:
  - every always-duty key is true;
  - key 8 is true or the internal-tester key is false;
  - key 13 is true or the type is an other type.
- So an absent internal-tester key or type does not block passing when its duty key is true.
- The two are mutually exclusive, and both may fail.

#### `can_change(Profile, Key)` (S5 rule)

A key can still change the answer when it is:

- an always-duty key; or
- `tests_undertaken_by_internal_tester`, while key 8 is not true; or
- key 8, while the internal-tester key is not false; or
- `dora_entity_type`, while key 13 is not true; or
- key 13, while the type is not an other type (absent, or CSD/CCP).

#### `strong_key(Profile, Key)`

A key is strong when it is:

- an always-duty key; or
- key 8, with the internal-tester key true; or
- key 13, with a CSD/CCP type; or
- the internal-tester key, with key 8 false; or
- `dora_entity_type`, with key 13 false.

#### First-key selection

- `first_absent_strong/2`, `first_absent_changing/2` and `first_unsure_changing/2` each scan `contract_key/2` in position order with disjoint clauses.
- Each yields exactly one key or fails. There is no findall-then-head on multiple witnesses.

#### `resilience_testing_duties_required` (reads the three fact keys only)

- **R0** Problems are non-empty: `input_problems(P)`, `[]`.
- **R1** The microenterprise key is absent: `indeterminate([financial_entity_is_microenterprise])`, `[]`.
- **R2** It is true: `required([microenterprise_risk_based_planned_testing])`, `[cite(eu_reg_2022_2554_art_25_3)]`.
- **R3** It is false and the type is absent: `indeterminate([dora_entity_type])`, `[]`.
- **R4** The internal-tester key is absent: `indeterminate([tests_undertaken_by_internal_tester])`, `[]`.
- **R5** Otherwise: `required(D)`.
  - `D` is the always-duties, plus duty 5 if the internal tester is true, plus duty 10 if the type is CSD/CCP, all in duty order.
  - It cites Art 24(1)-(6) and Art 25(1), plus Art 25(2) when the type is CSD/CCP.

#### `resilience_testing_duties_complete`

- **S0** Input problems: `input_problems(P)`, `[]`.
- **S1** `incomplete` with the fixed nine citations, when one of these holds:
  - micro is true and key 14 is false; or
  - micro is false and `branch_fails`; or
  - micro is absent, key 14 is false and `branch_fails`.
- **S2** `complete` with the fixed nine citations, in the same three shapes with key 14 true and `branch_passes`.
- **S3** Micro is absent: `indeterminate([financial_entity_is_microenterprise])`.
- **S4** Micro is true:
  - key 14 absent gives `indeterminate([microenterprise_tests_risk_based_and_planned])`;
  - key 14 unsure gives `needs_legal_review(open_textured(microenterprise_tests_risk_based_and_planned, cite(eu_reg_2022_2554_art_25_3)), [inputs_relied_on(Pairs)])`.
- **S5** Micro is false: `indeterminate([K])`. `K` is the first absent strong key in root_exports order, else the first absent key that can change the answer.
- **S6** Otherwise: `needs_legal_review(open_textured(K, cite(C)), [inputs_relied_on(Pairs)])`. `K` is the first unsure duty key of the branch that can change the answer, and `C` comes from its referral row.

#### `resilience_testing_duties_outstanding`

- **M0** Input problems.
- **M1** Micro is absent:
  - if key 14 is true and `branch_passes`: `none_outstanding` with the fixed nine;
  - otherwise: `indeterminate([financial_entity_is_microenterprise])`.
- **M2** Micro is true, by the value of key 14:
  - absent gives `indeterminate([...14])`;
  - unsure gives `needs_legal_review(... art_25_3 ...)`;
  - false gives `outstanding([microenterprise_risk_based_planned_testing])` with `[cite(eu_reg_2022_2554_art_25_3)]`;
  - true gives `none_outstanding` with the fixed nine.
- **M3** Micro is false: the first absent key that can change the list, in root_exports order. A false key does not end the query, and there is no strong/weak ordering here.
- **M4** The first unsure branch duty key that can change the list: `needs_legal_review`.
- **M5** Final answer. `Outstanding` is each applicable branch duty whose key is false, in duty order.
  - Empty: `none_outstanding` with the fixed nine.
  - Otherwise: `outstanding(Outstanding)`, citing each duty's citation key once (`art_24_4` and `art_24_5` deduplicated).

#### Pairs

`Pairs` is `present_pairs/2` from the kernel: every present `Key-Value` in root_exports order, with values exactly as given.

#### Checklist `requirement/4` (closure for `assess/6`)

The closure is `requirement(Duty, Profile, Status, cite(Key))`. It has exactly three disjoint clause families:

- `met`: the duty applies and its key is true, or the duty is inapplicable.
- `unmet(not_performed)`: the duty applies and its key is false.
- `unknown([K])`: the key is absent or unsure, or applicability is undecided. `K` is the deciding fact key while applicability is undecided.

The checklist is justification only. The scored verdict is the contract query.

### 6.3 Verdict atoms of this slice

- Final answers: `required/1`, `complete`, `incomplete`, `none_outstanding`, `outstanding/1`.
- Status compounds: `indeterminate/1`, `needs_legal_review/2` with `open_textured/2`, `input_problems/1`.
- Checklist statuses: `met`, `unmet/1`, `unknown/1`.

### 6.4 Predicates shared with another slice (kernel only)

There is no other determination slice. The only cross-file predicates live in `kernel.clausal`: `contract_key/2`, `key_type/2`, `entity_type_atom/1`, `dora_resilience_testing_programme_input_problems/2` and `present_pairs/2`. All are used by the slice, `queries.clausal` and the facade. Nothing domain-legal is placed in the kernel.

### 6.5 Per-rule tests (seven modes)

1. **Unit, per limb.** At least one case for each of R0-R5, S0-S6 and M0-M5.
2. **Counting.** `findall` over each query, then `length(L, 1)` for every fixture.
3. **Totality.** Completion over the 14 keys × {absent, true, false, unsure / type CSD, other} sample yields one solution each.
4. **Consistency.** `complete` iff `none_outstanding`; `incomplete` implies `outstanding(_)` or a status. This holds whenever both queries are final.
5. **Citation completeness.** Every final result's citations are within citation_vocabulary; every status has `[]`.
6. **Missing-key coverage.** Each key is named by some indeterminate result.
7. **Input check.** Duplicates (equal and unequal values), wrong types (`unsure` on fact keys, numbers, floats, unbound values), unknown, non-atom and unbound keys, non-list, partial-list and unbound-element profiles.

Each `fail` test is paired with a positive test on the same case.

## 7. Planned reuse (manifest `uses:`)

- **`formalize_lib`:** `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`, `check_tri/4` (for the true/false/absent axis of a duty key; `unsure` is separated first by `profile_get/3` and routed to referral), `not_defeated/3`, `assess/6`, `eval_requirements/4`, `item/3`, `unmet/1`, `unknown/1`, `labels/3`, `assessment/3`, `memberd/2`, `not_member/2`, `attribute/2`.
- **`kit/query_combinators`:** `what_if/5`, `override_key/4`, `diff_checklists/3`.
- **`kit/compliance_lib`:** `nm/2`, `compliance_check/7`, `verdict/5`, `permitted_action/6`.
- **`validate_props`:** `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_consistency/4`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `bad_citation/1`.
- **Not used:**
  - `kit/deadline_lib`, `kit/rolling_window`, `library(datetime)`: no date is read.
  - `currency_vocab`, `country`, `vat_category`: no money, country or VAT.
  - `ratio_bps/4`, `check_gte/5`: no numbers.
- No hand-rolled clone of `check_tri`, `ratio_bps` or `eval_requirements`.
