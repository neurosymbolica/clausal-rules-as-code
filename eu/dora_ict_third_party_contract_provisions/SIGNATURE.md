# SIGNATURE — eu/dora_ict_third_party_contract_provisions

Predicate prefix: `dora_ict_third_party_contract_provisions_`. Shape family: deontic.

Pipeline: `kernel -> citations -> parameters -> dora_ict_third_party_contract_provisions -> queries -> fixtures -> package facade`. The package layout, file names and module names are kept.

## Public query surface

Each of the three called queries takes PROFILE and returns RESULT and CITATIONS. Each yields exactly ONE solution for every input. This is guaranteed by mutually exclusive clause guards and guarded `once/1` defeaters, with no cut, `->` or `*->`.

### Facade

- `decide_dora_ict_third_party_contract_provisions(PROFILE, dora_ict_third_party_contract_provisions_verdict(STATUS, CITATIONS))`: STATUS and CITATIONS are exactly the RESULT and CITATIONS of `contract_provisions_sufficient/3`.
- `dora_ict_third_party_contract_provisions_status(PROFILE, STATUS)`: the same STATUS.

### Profile

PROFILE is an attribute list `[attribute(KEY, VALUE), ...]` read only with `profile_get/3` (presence first, then value). There are no numeric, money or date keys: the pinned text sets no figure or period (reading (11)).

### Totality and determinism

- Every call yields exactly one solution, including on ill-formed input, which gives `input_problems/1`.
- The input check never fails and never raises.
- No predicate returns a float, a string or a record.
- No figure is imported, because none exists. No `constant_value` is declared.

## Verdict STATUS atoms (replacing the placeholders `required, permitted, not_applicable`)

### Final answers

- `required(ELEMENTS)`: arity 1. ELEMENTS is in ELEMENT ORDER (`contract_provisions_required`).
- `sufficient`, `insufficient`: atoms (`contract_provisions_sufficient`; facade STATUS).
- `none_missing`: atom (`contract_provisions_missing`).
- `missing(ELEMENTS)`: arity 1. ELEMENTS is non-empty and in ELEMENT ORDER (`contract_provisions_missing`).

### Status compounds (never final; CITATIONS [])

- `indeterminate([KEY])`: exactly one bare key atom. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(KEY, cite(CITATION)), [inputs_relied_on(PAIRS)])`. PAIRS are `KEY-VALUE` terms for the present keys the query reads, in root_exports order, with values exactly as given:
  - `contract_provisions_required` reads `supports_critical_or_important_function` and `financial_entity_is_microenterprise`;
  - the other two queries read all twenty-four keys.
- `input_problems(PROBLEMS)`: PROBLEMS are `duplicate_key/1`, `wrong_type/1` and `unknown_key/1` terms.

### Result constructors (exported, never called as queries)

`required/1`, `missing/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

### Element atoms (result atoms only, never profile keys)

In ELEMENT ORDER:

1. `termination_for_significant_breach`
2. `termination_for_circumstances_altering_performance`
3. `termination_for_risk_management_weaknesses`
4. `termination_where_supervision_impeded`
5. `single_written_document`
6. `description_of_functions_services_and_subcontracting`
7. `service_and_data_locations`
8. `data_protection_provisions`
9. `data_access_recovery_and_return`
10. `service_level_descriptions`
11. `incident_assistance`
12. `cooperation_with_authorities`
13. `termination_rights_and_notice_periods`
14. `security_awareness_and_training_participation`
15. `full_service_levels_with_performance_targets`
16. `notice_periods_and_reporting_obligations`
17. `contingency_plans_and_security_measures`
18. `threat_led_penetration_testing_participation`
19. `monitoring_rights_of_the_financial_entity`
20. `monitoring_rights_of_the_authorities`
21. `exit_strategy_and_transition_period`

Plus the substitute `monitoring_rights_of_the_financial_entity_or_delegated_assurance`, which stands at position 19 when `financial_entity_is_microenterprise` is true.

The atoms `true` and `false` are never pinned in verdict_vocabulary or root_exports.

## Profile keys (root_exports order = input_contract order)

Type names:

- `judgement`: `one_of boolean or unsure`, meaning the atoms `true`, `false` or `unsure`.
- `fact`: `boolean`, meaning the atoms `true` or `false` only.

| # | key | type | referral citation |
|---|-----|------|-------------------|
| 1 | `contract_provides_termination_for_significant_breach` | judgement | `eu_reg_2022_2554_art_28_7_a` |
| 2 | `contract_provides_termination_for_circumstances_altering_performance` | judgement | `eu_reg_2022_2554_art_28_7_b` |
| 3 | `contract_provides_termination_for_risk_management_weaknesses` | judgement | `eu_reg_2022_2554_art_28_7_c` |
| 4 | `contract_provides_termination_where_supervision_impeded` | judgement | `eu_reg_2022_2554_art_28_7_d` |
| 5 | `contract_is_single_written_document` | judgement | `eu_reg_2022_2554_art_30_1` |
| 6 | `contract_provides_description_of_functions_services_and_subcontracting` | judgement | `eu_reg_2022_2554_art_30_2_a` |
| 7 | `contract_provides_service_and_data_locations` | judgement | `eu_reg_2022_2554_art_30_2_b` |
| 8 | `contract_provides_data_protection_provisions` | judgement | `eu_reg_2022_2554_art_30_2_c` |
| 9 | `contract_provides_data_access_recovery_and_return` | judgement | `eu_reg_2022_2554_art_30_2_d` |
| 10 | `contract_provides_service_level_descriptions` | judgement | `eu_reg_2022_2554_art_30_2_e` |
| 11 | `contract_provides_incident_assistance` | judgement | `eu_reg_2022_2554_art_30_2_f` |
| 12 | `contract_provides_cooperation_with_authorities` | judgement | `eu_reg_2022_2554_art_30_2_g` |
| 13 | `contract_provides_termination_rights_and_notice_periods` | judgement | `eu_reg_2022_2554_art_30_2_h` |
| 14 | `contract_provides_security_awareness_and_training_participation` | judgement | `eu_reg_2022_2554_art_30_2_i` |
| 15 | `supports_critical_or_important_function` | judgement | `eu_reg_2022_2554_art_30_3` |
| 16 | `contract_provides_full_service_levels_with_performance_targets` | judgement | `eu_reg_2022_2554_art_30_3_a` |
| 17 | `contract_provides_notice_periods_and_reporting_obligations` | judgement | `eu_reg_2022_2554_art_30_3_b` |
| 18 | `contract_provides_contingency_plans_and_security_measures` | judgement | `eu_reg_2022_2554_art_30_3_c` |
| 19 | `contract_provides_threat_led_penetration_testing_participation` | judgement | `eu_reg_2022_2554_art_30_3_d` |
| 20 | `contract_provides_monitoring_rights_of_the_authorities` | judgement | `eu_reg_2022_2554_art_30_3_e` |
| 21 | `contract_provides_exit_strategy_and_transition_period` | judgement | `eu_reg_2022_2554_art_30_3_f` |
| 22 | `contract_provides_monitoring_rights_of_the_financial_entity` | judgement | `eu_reg_2022_2554_art_30_3_e` |
| 23 | `financial_entity_is_microenterprise` | fact | (crisp; never referred) |
| 24 | `contract_provides_delegated_access_inspection_and_audit` | judgement | `eu_reg_2022_2554_art_30_3` |

Key groups:

- BASE keys: 1 to 14.
- Critical-or-important key: 15.
- PLAIN Art 30(3) keys: 16 to 21.
- MONITORING CHAIN: 22 to 24.

## Citation-key atoms (citation_vocabulary; canonical lexicon scheme; never shortened)

Paragraph keys:

- `eu_reg_2022_2554_art_28_7`
- `eu_reg_2022_2554_art_30_1`
- `eu_reg_2022_2554_art_30_2`
- `eu_reg_2022_2554_art_30_3`

Point keys:

- `eu_reg_2022_2554_art_28_7_a`, `eu_reg_2022_2554_art_28_7_b`, `eu_reg_2022_2554_art_28_7_c`, `eu_reg_2022_2554_art_28_7_d`
- `eu_reg_2022_2554_art_30_2_a`, `eu_reg_2022_2554_art_30_2_b`, `eu_reg_2022_2554_art_30_2_c`, `eu_reg_2022_2554_art_30_2_d`, `eu_reg_2022_2554_art_30_2_e`, `eu_reg_2022_2554_art_30_2_f`, `eu_reg_2022_2554_art_30_2_g`, `eu_reg_2022_2554_art_30_2_h`, `eu_reg_2022_2554_art_30_2_i`
- `eu_reg_2022_2554_art_30_3_a`, `eu_reg_2022_2554_art_30_3_b`, `eu_reg_2022_2554_art_30_3_c`, `eu_reg_2022_2554_art_30_3_d`, `eu_reg_2022_2554_art_30_3_e`, `eu_reg_2022_2554_art_30_3_f`

Where they are used:

- `citations.clausal` holds them as `citation(Key, Unit, Text)` facts. The units are `32022R2554#parag_028.007`, `32022R2554#point_028.007_a` and so on.
- Art 28(1)(b) and Art 28(2) are quoted in NOTES for reading (5) only. They get no citation atom, because no limb cites them.

## Public predicates

### The called contract (queries.clausal)

- `contract_provisions_required(Profile, Result, Citations)`: the list of required elements in ELEMENT ORDER (R0 to R5). Reads keys 15 and 23 only. Cites Art 28(7), 30(1), 30(2), and also 30(3) when the arrangement supports a critical or important function.
- `contract_provisions_sufficient(Profile, Result, Citations)`: `sufficient` / `insufficient` or a status compound (S0 to S4). This is the compliance check (#13) for the deontic obligation in Art 28(7) and Art 30(1) to (3). Cites the fixed four paragraph keys on a final answer.
- `contract_provisions_missing(Profile, Result, Citations)`: `none_missing` / `missing(Elements)` or a status compound (M0 to M3).
  - `none_missing` cites the four paragraph keys.
  - `missing(Elements)` cites the point key of each listed element. The derogation atom cites both `eu_reg_2022_2554_art_30_3_e` and `eu_reg_2022_2554_art_30_3`.
- `dora_ict_third_party_contract_provisions_input_problems(Profile, Problems)`: THE INPUT CHECK. Cites the input contract; no citation is returned.

### Package facade (scaffold names kept)

- `decide_dora_ict_third_party_contract_provisions(Profile, Verdict)`: Verdict is `dora_ict_third_party_contract_provisions_verdict(Status, Citations)`, with Status and Citations taken from `contract_provisions_sufficient/3`. Cites Art 28(7), 30(1), 30(2), 30(3).
- `dora_ict_third_party_contract_provisions_status(Profile, Status)`: the Status projection of decide. This is the eligibility verdict (#2). Its labels map onto `labels(sufficient, indeterminate, insufficient)`. Status is one of `sufficient`, `insufficient`, `indeterminate([Key])`, `needs_legal_review(...)` or `input_problems(...)`. Cites Art 28(7), 30(1), 30(2), 30(3).
- `dora_ict_third_party_contract_provisions_checklist(Profile, Checklist)`: the justification query (#7).
  - Checklist is a list of `item(Element, ItemStatus, cite(Key))`, one per element that applies under the profile, in ELEMENT ORDER.
  - If key 15 is absent or unsure, only the fourteen base items are listed, plus an item `item(critical_or_important_function_question, ItemStatus, cite(eu_reg_2022_2554_art_30_3))`.
  - ItemStatus is one of:
    - `met`;
    - `unmet(judged_absent(Key))`;
    - `unknown([Key])` when the key is absent;
    - `unknown([Key])` with a referral note when the key is unsure.
  - Every item carries `cite(...)`, met items included. The derogation item cites `eu_reg_2022_2554_art_30_3`.
  - Built with `formalize_lib:eval_requirements/4` over `requirement/4`.
- `dora_ict_third_party_contract_provisions_what_if(Profile, Key, Value, Verdict)`: re-decides with Key overridden to Value. Uses `kit/query_combinators:what_if/5` with the closure `decide_dora_ict_third_party_contract_provisions`. Cites as decide.

### Fixtures (fixtures.clausal)

- `dora_ict_third_party_contract_provisions_fixture(Name, Profile)`: named example profiles. At least:
  - `all_base_met_not_critical` gives sufficient / none_missing / required with 14 elements;
  - `critical_all_met` gives sufficient / required with 21 elements;
  - `microenterprise_delegation` gives sufficient, with the derogation atom in required;
  - `base_breach_false` gives insufficient and `missing([termination_for_significant_breach])`;
  - `critical_unsure` gives `needs_legal_review` on key 15 in required, after key 23 is present;
  - `critical_absent` gives `indeterminate([supports_critical_or_important_function])`;
  - `microenterprise_monitoring_failed` gives `missing([monitoring_rights_of_the_financial_entity_or_delegated_assurance])`;
  - `duplicate_and_unknown_keys` gives `input_problems([...])`.
- `dora_ict_third_party_contract_provisions_fixture_expected(Name, Query, Result, Citations)`: the expected answer for each fixture and query.

## Planned reuse (manifest `uses:`)

### `formalize_lib`

- `profile_get/3`: the only profile reader.
- `profile_has/2`, `profile_lacks/2`, `profile_keys/2`.
- `check_tri/4`: tri-valued Kleene check per element; never hand-rolled (C15).
- `not_defeated/3`: the derogation defeater on `monitoring_rights_of_the_financial_entity`.
- `eval_requirements/4`: the checklist; never a hand-rolled findall row helper (R1).
- `assess/6` and `labels/3`: the eligibility verdict shape.
- `item/3`, `unmet/1`, `unknown/1`, `attribute/2`.
- `member_matching/2`, `memberd/2`, `not_member/2`.
- `and_status/2`, `or_status/2`: the met/unmet/open status of the monitoring requirement and of the Art 30(3) requirements.
- Vocabulary: `met`.

### `kit/query_combinators`

- `what_if/5`: the what_if facade.
- `override_key/4`: test mutations.

### `validate_props` (tests only)

- `run_props/1`.
- `prop_totality/3`, `prop_determinism/3`: one solution per query over the fixture and generated profiles.
- `prop_citation_complete/3`: every final answer and checklist item carries `cite/1` from citation_vocabulary.
- `prop_missing_key_coverage/3`: each of the 24 keys, when absent, is named by some query on some profile.
- `prop_consistency/4`.

### Not used

`kit/compliance_lib` is NOT used. Its deny-overrides modality lattice answers 'is an action permitted', whereas this order's compliance check is a contract-content minimum with ordered referrals. Query type #13 is served by `contract_provisions_sufficient/3`, and the reason is recorded in NOTES.

Also not used:

- `kit/deadline_lib`, `date_time`, `kit/rolling_window`: no periods or dates (reading (11)).
- `currency_vocab`, `vat_category`, `country`.

## Structural idioms

- **Defeasible logic, cut-free.**
  - Strict rule: an element is required when its group applies. The base group always applies; the Art 30(3) group applies when key 15 is true.
  - Defeasible rule: `monitoring_rights_of_the_financial_entity` must be met by the rights themselves.
  - Defeater: `microenterprise_delegation_defeater(Profile)` holds when key 23 and key 24 are both true. It is called as `once(microenterprise_delegation_defeater(Profile))` behind a ground guard, and consumed via `not_defeated/3`.
  - The atom substitution for a microenterprise is a separate clause pair guarded by key 23 true / false.
- **Open texture handed to the user.** Every element is a tri-state caller judgement. unsure leads to `needs_legal_review(open_textured(Key, cite(Citation)), ...)`. No crisp test is invented.
- **Ground verdicts folded into clause heads (C17).** One clause per disjoint route. No `!`, `->` or `*->`. One goal per line. Full-word identifiers and CamelCase variables.

## Slices

### kernel.clausal — the shared floor (only what more than one module needs)

- `dora_ict_third_party_contract_provisions_key(Index, Key, Type)`: the 24 contract keys in root_exports order. Type is `judgement` or `fact`. Shared by the input check, the PAIRS builder and the slice.
- `dora_ict_third_party_contract_provisions_value_has_type(Type, Value)`: Value is ground and in the type.
  - judgement accepts the atoms `true`, `false` and `unsure`.
  - fact accepts the atoms `true` and `false`.
  - An unbound value is checked with `var/1` first and is never unified.
- `dora_ict_third_party_contract_provisions_input_problems(Profile, Problems)`: THE INPUT CHECK.
  - A non-list, an unbound value, a partial list, or any element that is not `attribute(K, V)` gives `[wrong_type(profile)]`.
  - Otherwise, for each contract key in key order: `duplicate_key(K)` if it occurs more than once (values not read); else `wrong_type(K)` if its value is outside its type.
  - Then `unknown_key(K)` for each key outside the 24, in order of first occurrence, once each. A non-atom key is reported as given, an unbound key as that same variable; compared with `==`, never unified.
  - Never fails, never raises, one solution.
- `dora_ict_third_party_contract_provisions_pairs(Profile, ReadKeys, Pairs)`: the `Key-Value` pairs of present keys in ReadKeys, in key order, with values as given.

### dora_ict_third_party_contract_provisions.clausal — the single determination slice (self-contained)

#### VALUE facts owned here

There are no numeric thresholds, periods or tables (reading (11)) and no `constant_value`. The slice owns the statutory element table:

- `element(Position, ElementAtom, ProfileKey, PointCitationKey, Group)`, with Group `base` or `critical_or_important`. There are 21 rows, as in the table above. Positions 19 and 20 both cite `eu_reg_2022_2554_art_30_3_e`.
- `derogation_element(monitoring_rights_of_the_financial_entity, monitoring_rights_of_the_financial_entity_or_delegated_assurance, [eu_reg_2022_2554_art_30_3_e, eu_reg_2022_2554_art_30_3])`.
- `paragraph_citations(base, [eu_reg_2022_2554_art_28_7, eu_reg_2022_2554_art_30_1, eu_reg_2022_2554_art_30_2])`.
- `paragraph_citations(all, [eu_reg_2022_2554_art_28_7, eu_reg_2022_2554_art_30_1, eu_reg_2022_2554_art_30_2, eu_reg_2022_2554_art_30_3])`.
- `referral_citation(Key, CitationKey)`: 23 rows, one per judgement key, as in the key table.
- Key groups: `base_keys/1` (1 to 14), `plain_critical_keys/1` (16 to 21), `monitoring_chain_keys/1` (22 to 24).

#### Rules / requirements

Each requirement has exactly three mutually exclusive clauses: met / unmet / unknown. The value states used are:

- `key_state(Profile, Key, State)`: State is `true`, `false`, `unsure` or `absent`. Implemented as one clause per state, via `profile_has/2` / `profile_lacks/2` and `profile_get/3`.
- not_false: `true`, `unsure` or `absent`.

The rules:

1. **`requirement(Element, Profile, Status, cite(PointKey))`** for each `element/5` row, via `check_tri/4` on its key. RequirementId comes first, as assess/6 and eval_requirements/4 require.
2. **`monitoring_requirement_state(Profile, State)`** with State `met`, `failed` or `open`, exactly per THE LIMBS:
   - met: key 22 true, or key 23 true and key 24 true (the defeater, via `not_defeated/3` / guarded `once/1`);
   - failed: key 22 false and key 23 false, or key 22 false and key 24 false;
   - otherwise open.
3. **`critical_requirements_state(Profile, State)`** with State `all_met`, `one_fails` or `open`:
   - all_met: all six plain keys true and the monitoring requirement met;
   - one_fails: a plain key false or the monitoring requirement failed;
   - otherwise open.
4. **`required_elements(Profile, Elements)`**:
   - key 15 false: the 14 base atoms;
   - key 15 true: all 21, with the derogation atom at position 19 when key 23 is true.
5. **`sufficiency_decisive_false(Profile)`** (S1): a base key is false, or key 15 is true and the state is `one_fails`.
6. **`sufficiency_relevant_key(Profile, Key)`** (S2/S3): the relevant-key list of THE LIMBS, enumerated in key order.
   - Every base key.
   - Key 15 unless the state is `all_met`.
   - While key 15 is not_false and the state is not `one_fails`:
     - every plain key;
     - key 22 unless keys 23 and 24 are both true;
     - key 23 if key 22 is not true and key 24 is not_false;
     - key 24 if key 22 is not true and key 23 is not_false.
7. **`missing_relevant_key(Profile, Key)`** (M1/M2): the same list, except:
   - the plain-key and chain rows are gated only by key 15 not_false, not by the state;
   - key 23 is relevant whenever key 22 is not true.
8. **`first_absent_relevant(RelevantPredicate, Profile, Key)`** and **`first_unsure_relevant(RelevantPredicate, Profile, Key)`**: the first in key order. Each is called inside a guarded `once/1` over a key-ordered generator; its no-solution side is tested with `\+`. This gives <<DNUM>> single naming; <<DNUM>> is ensured by the gating in rules 6 and 7.
9. **`missing_elements(Profile, Elements)`** (M3):
   - base elements whose key is false;
   - if key 15 is true: plain elements whose key is false, plus the monitoring element if the state is `failed`, named with the derogation atom when key 23 is true;
   - in ELEMENT ORDER.
10. **`missing_citations(Elements, Citations)`**: each element's point key(s) as `cite/1`, de-duplicated with `memberd/2`, so position 19 and position 20 share `eu_reg_2022_2554_art_30_3_e` once.

#### Verdict atoms produced by this slice

- `required/1`, `sufficient`, `insufficient`, `none_missing`, `missing/1`.
- `indeterminate/1`, `needs_legal_review/2`, with `open_textured/2` and `inputs_relied_on/1`.
- `input_problems/1`, delegated from the kernel.

The slice exports the three query predicates, which `queries.clausal` re-exports, and `requirement/4` for the checklist.

#### Limb clauses

There is one clause per disjoint route, with the ground verdict in the head.

**required:**

- R0: problems non-empty.
- R1: key 15 false.
- R2: key 15 absent.
- R3: key 15 true or unsure, and key 23 absent.
- R4: key 15 unsure and key 23 present.
- R5: key 15 true and key 23 present.

**sufficient:**

- S0: problems non-empty.
- S1: decisive false.
- S2: no decisive false, and a first absent relevant key exists.
- S3: no decisive false, no absent relevant key, and a first unsure relevant key exists.
- S4: none of the above.

**missing:**

- M0: problems non-empty.
- M1: a first absent relevant key exists.
- M2: no absent relevant key, and a first unsure relevant key exists.
- M3a: none of the above, and the missing list is empty, giving `none_missing`.
- M3b: none of the above, and the missing list is non-empty, giving `missing(List)`.

#### Predicates shared with another slice

There is only one determination slice. The only shared predicates are the kernel ones above (key table, type check, input check, pairs), used by this slice, `queries.clausal` and the facade checklist.

#### Per-rule tests (tests/)

Each test is paired positive and negative over the same case. Answers are collected with findall, and each query is asserted to give exactly one solution (`length(Results, 1)`).

**Rules R0 to R5, S0 to S4 and M0 to M3:** one test each.

**Precedence:**

- A false base key beats an absent key (S1 before S2).
- An absent key 23 is named before key 15 unsure is referred (R3 before R4).
- Key 15 false makes keys 16 to 24 unread.
- In S2, key 23 is not named while key 22 is absent and key 24 is false. Key 24 false then makes key 23 irrelevant, unless key 22 is still open; in that case key 22 is named first.

**Derogation:**

- The microenterprise substitution atom appears in both required and missing.
- Its citations are `eu_reg_2022_2554_art_30_3_e` and `eu_reg_2022_2554_art_30_3`, each written once.

**Input check:**

- `duplicate_key` without `wrong_type`.
- `unknown_key` for an unbound key, reported as that variable.
- `[wrong_type(profile)]` for a partial list and for a non-attribute element.
- `wrong_type(financial_entity_is_microenterprise)` for `unsure`.

**Determinism and totality:** the validate_props totality and determinism properties.
