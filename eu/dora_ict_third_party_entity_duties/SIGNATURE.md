# SIGNATURE — eu/dora_ict_third_party_entity_duties

## Public query surface

### The four contract queries and the input check

The package exports four contract queries:

- `entity_duties_required/3`
- `entity_duties_complete/3`
- `entity_duties_outstanding/3`
- `ict_third_party_strategy_required/3`

It also exports the input check, `dora_ict_third_party_entity_duties_input_problems/2`.

### The scaffold facade

The facade keeps the scaffold names:

- `decide_dora_ict_third_party_entity_duties(PROFILE, dora_ict_third_party_entity_duties_verdict(STATUS, CITATIONS))`
- `dora_ict_third_party_entity_duties_status(PROFILE, STATUS)`
- `dora_ict_third_party_entity_duties_checklist(PROFILE, CHECKLIST)`
- `dora_ict_third_party_entity_duties_what_if(PROFILE, KEY, VALUE, STATUS)`
- the fixtures

The facade is built on `entity_duties_complete`, which is the compliance check (#13). It is also the eligibility verdict (#2), with `complete` and `incomplete` taking the place of eligible and ineligible.

### Totality and determinism

- Every public predicate yields EXACTLY ONE solution for every PROFILE term, malformed ones included.
- No public predicate fails or raises.
- No public predicate returns a float, a string or a record.

### Figures and dates

No statutory figure or date is read. `parameters.clausal` declares none, so nothing is imported or re-declared.

## Verdict STATUS atoms

These replace the placeholders `required`, `permitted` and `not_applicable`.

### Final answers

- `required(DUTIES)` — an arity-1 compound.
- `complete` and `incomplete` — atoms.
- `none_outstanding` — an atom.
- `outstanding(DUTIES)` — an arity-1 compound.
- `strategy_required` and `strategy_not_required` — atoms.

### Statuses (not final)

- `indeterminate([KEY])` — exactly one bare key. The bare atom `indeterminate` is NEVER written.
- `needs_legal_review(open_textured(KEY, cite(CITATION)), [inputs_relied_on(PAIRS)])`
- `input_problems(PROBLEMS)`, where PROBLEMS holds `duplicate_key(KEY)`, `wrong_type(KEY)` and `unknown_key(KEY)` terms.

### Result constructors

These are exported and never called as queries:

- `required/1`, `outstanding/1`
- `indeterminate/1`
- `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`
- `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`

### Pinning rule

The atoms `true`, `false` and `unsure` are values, never pinned in `verdict_vocabulary` or `root_exports`.

### Duty atoms (result atoms only, in DUTY ORDER)

1. `assessment_of_critical_or_important_function`
2. `assessment_of_supervisory_conditions`
3. `risk_identification_and_assessment`
4. `due_diligence_on_provider`
5. `conflicts_of_interest_assessment`
6. `provider_with_appropriate_information_security_standards`
7. `consideration_of_most_up_to_date_information_security_standards`
8. `predetermined_audit_frequency_and_areas`
9. `verification_of_auditor_skills`
10. `exit_strategy`
11. `exit_without_business_disruption`
12. `exit_without_limiting_regulatory_compliance`
13. `exit_without_detriment_to_client_services`
14. `tested_and_reviewed_exit_plans`
15. `alternative_solutions_and_transition_plans`
16. `contingency_measures`
17. `concentration_risk_consideration`
18. `weighing_of_alternative_solutions`
19. `weighing_of_subcontracting_benefits_and_risks`
20. `consideration_of_insolvency_law_and_data_recovery`
21. `consideration_of_third_country_data_protection_and_enforcement`
22. `assessment_of_subcontracting_chains`

## Profile keys (root_exports order and input_contract order)

### Format

- PROFILE is `[attribute(KEY, VALUE), ...]`.
- It is read only with `profile_get/3`: presence first, then value.
- No key is numeric and no key is a date, so there are no unit suffixes and no `date/4` terms.
- Type `judgement` is one_of boolean or unsure, where boolean means the atoms `true` and `false`.
- Type `fact` is boolean.

### The keys

1. `assessed_whether_arrangement_supports_critical_or_important_function` — judgement
2. `assessed_supervisory_conditions_for_contracting` — judgement
3. `identified_and_assessed_relevant_risks` — judgement
4. `undertook_due_diligence_on_provider` — judgement
5. `identified_and_assessed_conflicts_of_interest` — judgement
6. `provider_complies_with_appropriate_information_security_standards` — judgement
7. `entity_exercises_access_inspection_and_audit_rights` — FACT, trigger
8. `audit_frequency_and_areas_predetermined` — judgement
9. `arrangement_entails_high_technical_complexity` — judgement, trigger (its own trigger is 7)
10. `auditor_skills_and_knowledge_verified` — judgement
11. `supports_critical_or_important_function` — judgement, trigger
12. `considered_most_up_to_date_information_security_standards` — judgement
13. `exit_strategy_in_place` — judgement
14. `able_to_exit_without_business_disruption` — judgement
15. `able_to_exit_without_limiting_regulatory_compliance` — judgement
16. `able_to_exit_without_detriment_to_client_services` — judgement
17. `exit_plans_comprehensive_documented_tested_and_reviewed` — judgement
18. `alternative_solutions_and_transition_plans_in_place` — judgement
19. `contingency_measures_in_place` — judgement
20. `considered_concentration_risk` — judgement
21. `weighed_alternative_solutions` — judgement
22. `considered_insolvency_law_and_data_recovery_constraints` — judgement
23. `arrangement_allows_further_subcontracting` — FACT, trigger (its own trigger is 11)
24. `weighed_subcontracting_benefits_and_risks` — judgement
25. `assessed_impact_of_subcontracting_chains` — judgement
26. `provider_established_in_third_country` — FACT, trigger (its own trigger is 11)
27. `considered_third_country_data_protection_and_enforcement` — judgement
28. `financial_entity_is_article_16_1_entity` — FACT (entity level)
29. `financial_entity_is_microenterprise` — FACT (entity level)

## Citation-key atoms (citation_vocabulary; canonical lexicon; never shortened)

- `eu_reg_2022_2554_art_28_2`
- `eu_reg_2022_2554_art_28_4`
- `eu_reg_2022_2554_art_28_4_a`
- `eu_reg_2022_2554_art_28_4_b`
- `eu_reg_2022_2554_art_28_4_c`
- `eu_reg_2022_2554_art_28_4_d`
- `eu_reg_2022_2554_art_28_4_e`
- `eu_reg_2022_2554_art_28_5`
- `eu_reg_2022_2554_art_28_6`
- `eu_reg_2022_2554_art_28_8`
- `eu_reg_2022_2554_art_28_8_a`
- `eu_reg_2022_2554_art_28_8_b`
- `eu_reg_2022_2554_art_28_8_c`
- `eu_reg_2022_2554_art_29_1`
- `eu_reg_2022_2554_art_29_1_a`
- `eu_reg_2022_2554_art_29_1_b`
- `eu_reg_2022_2554_art_29_2`

`citations.clausal` holds one `citation_text/2` row per atom, with the pinned unit ids. Art 28(1) is quoted in NOTES only and is never emitted.

## Public predicates

- `entity_duties_required(Profile, Result, Citations)`: steps R0 to R3. Reads the five triggers. Returns `required(Duties)`, `indeterminate([Key])`, `needs_legal_review/2` or `input_problems/1`. Citations: Art 28(4) and (5); plus Art 28(6) when audit rights are exercised; plus Art 28(8), Art 29(1) and Art 29(2) when a critical or important function is supported.
- `entity_duties_complete(Profile, Result, Citations)`: steps S0 to S4. Returns `complete` or `incomplete`, citing the fixed six: Art 28(4), (5), (6), (8), Art 29(1) and (2). Otherwise returns a status with `[]`.
- `entity_duties_outstanding(Profile, Result, Citations)`: steps M0 to M3. Returns `none_outstanding` with the fixed six, or `outstanding(Duties)` citing each listed duty's citation keys, each once. Otherwise returns a status with `[]`.
- `ict_third_party_strategy_required(Profile, Result, Citations)`: steps T0 to T4. Returns `strategy_not_required` or `strategy_required`, each citing `[cite(eu_reg_2022_2554_art_28_2)]`. Otherwise returns `indeterminate([financial_entity_is_article_16_1_entity])` or `indeterminate([financial_entity_is_microenterprise])`. Cites Art 28(2).
- `dora_ict_third_party_entity_duties_input_problems(Profile, Problems)`: the input check (see the kernel). Gives `[]` when the profile is well formed. Cites none.
- `decide_dora_ict_third_party_entity_duties(Profile, dora_ict_third_party_entity_duties_verdict(Status, Citations))`: the compliance check (#13) and eligibility verdict (#2). Status and Citations are exactly those of `entity_duties_complete/3`. Cites the fixed six on a final answer.
- `dora_ict_third_party_entity_duties_status(Profile, Status)`: Status from `entity_duties_complete/3`, without citations. Cites none.
- `dora_ict_third_party_entity_duties_checklist(Profile, Checklist)`: the justification query (#7). Gives one `item(Duty, ItemStatus, cite(Key))` per OPEN duty (no trigger false), in duty order, built with `formalize_lib:eval_requirements/4` over `duty_requirement/4`. ItemStatus values:
  - `met` when the duty applies and its key is true;
  - `unmet(not_performed)` when it applies and its key is false;
  - `unknown([Key])` naming the first absent or unsure trigger or key, in root_exports order, that blocks it.

  The citation is the duty's FIRST citation key: for duty 17 it is `eu_reg_2022_2554_art_29_1`, and points (a) and (b) ride in NOTES. On an input problem, Checklist is `[]`.
- `dora_ict_third_party_entity_duties_what_if(Profile, Key, Value, Status)`: replaces Key by Value using `formalize_lib:profile_set/3`, which adds the key when it is absent and replaces every occurrence, then gives the new `dora_ict_third_party_entity_duties_status/2`. `kit/query_combinators:what_if/5` is not used because its `override_key/4` works on dicts, not attribute lists. Cites per `entity_duties_complete`.
- `dora_ict_third_party_entity_duties_fixture(Name, Profile)` and `dora_ict_third_party_entity_duties_expected(Name, Query, Result, Citations)`: the fixtures (fixtures.clausal). Cite none.

## Planned reuse (manifest `uses:`)

### `formalize_lib`

- `profile_get/3` — the only profile reader.
- `not_defeated/3` — duty applicability as a default with a defeater, where the defeater is a false trigger.
- `eval_requirements/4` and `item/3` — the checklist.
- `unmet/1` and `unknown/1` — checklist statuses.
- `memberd/2` and `not_member/2` — deterministic membership in trigger sets.
- `attribute/2` — profile shape.

`check_tri/4` and `check_tri_neg/4` are deliberately NOT used. They give met, unmet or unknown, but this package needs a four-way key state (`absent`, `true`, `false`, `unsure`), because absent and unsure take different routes. The kernel's `key_state/3` is that state classifier, not a Kleene check, so C15 does not apply. The kernel carries a comment saying so.

### `validate_props` (tests only)

- `run_props/1`
- `prop_totality/3`
- `prop_determinism/3`
- `prop_citation_complete/3`
- `prop_missing_key_coverage/3`

### Not used

- `kit/compliance_lib`: Q3 forbids a prohibition modality, and the question is a closed list of duties.
- `kit/deadline_lib` and `date_time`: no deadline and no date (Q16).
- `kit/query_combinators`: dicts only (see what_if).
- `currency_vocab`, `vat_category` and `country`: third country is a caller fact, not a country code.

## Idioms

### Cut-free defeasible logic

A duty applies by default. It is defeated by `duty_defeated(Duty, Profile)`, which holds when some trigger of the duty has state `false`. Each status route is one disjoint clause with the ground verdict in the head (C17). There is no `!`, `->` or `*->`.

### Guarded `once/1`

`once/1` is used ONLY around the 'first key in root_exports order satisfying a condition' searches, and around the duplicate-free collection in the input check. Each guard carries a comment naming the <<DNUM>> single-key rule. Routes stay disjoint by construction:

- an input problem versus none;
- a failing duty exists versus none;
- an absent candidate exists versus none;
- an unsure candidate exists versus none.

Each later route carries the negation of the earlier conditions with `\+`.

### Open texture

Every unsure judgement that can change the answer becomes `needs_legal_review(open_textured(Key, cite(C)), [inputs_relied_on(Pairs)])`, using that key's referral citation.

## Layer files

- `kernel.clausal` holds the shared floor (below).
- `citations.clausal` holds the citation facts.
- `parameters.clausal` holds no statutory figure. It carries a comment that the pinned units set none (Q16), and that the date of application under Article 64 is excluded and not declared.
- `dora_ict_third_party_entity_duties.clausal` is the slice.
- `queries.clausal` re-exports the four contract queries and the input check under their contract names.
- `fixtures.clausal` holds the named profiles and expected answers.
- The package facade holds the five facade predicates above.

## kernel.clausal — the shared floor

These are the only predicates shared across layers.

### `key_state(Profile, Key, State)`

State is `absent`, `true`, `false` or `unsure`. It is read by `profile_get/3`: presence first, then value. There are four disjoint clauses. It is called only after the input check has passed, so each key has at most one occurrence.

### `contract_key(Order, Key, Type)`

There are twenty-nine rows. Order runs from 1 to 29 and Type is `judgement` or `fact`. This is the source of input_contract and root_exports order.

### `dora_ict_third_party_entity_duties_input_problems(Profile, Problems)`

- **Profile shape:** if Profile is not a proper, fully instantiated list whose every element is `attribute(_, _)`, the result is `[wrong_type(profile)]`. An unbound Profile, a partial list or an unbound element all give this.
- **Contract keys:** for each contract key, in order, the check gives `duplicate_key(Key)` if the key occurs at least twice. The duplicate check is done with `==` comparison and reads no value. Otherwise it gives `wrong_type(Key)` if the single value is unbound or outside the type.
- **Unknown keys:** then `unknown_key(Key)` for each non-contract key, including a non-atom or an unbound variable, kept as given. These come in order of first occurrence, deduplicated by `==`.
- **No failure:** the check never fails.

It walks the raw list structurally. This is shape checking, not reading of values. The kernel carries a comment explaining this, so the `profile_get`-only lint is satisfied.

### `inputs_relied_on_pairs(Profile, Keys, Pairs)`

Pairs is the present `Key-Value` pairs of Keys, in root_exports order, with values exactly as given.

## Slice: dora_ict_third_party_entity_duties.clausal

This slice is self-contained for the concept. It owns every value fact below. No figure lives in a shared constants file.

### Value facts it owns

#### `duty(Position, Duty, Key, Citations, Triggers)`

There are twenty-two rows, in DUTY ORDER.

- Rows 1 to 6 have Triggers `[]`.
- Row 7 and rows 10 to 18 have `[supports_critical_or_important_function]`.
- Row 20 also has `[supports_critical_or_important_function]`.
- Row 8 has `[entity_exercises_access_inspection_and_audit_rights]`.
- Row 9 has `[entity_exercises_access_inspection_and_audit_rights, arrangement_entails_high_technical_complexity]`.
- Rows 19 and 22 have `[supports_critical_or_important_function, arrangement_allows_further_subcontracting]`.
- Row 21 has `[supports_critical_or_important_function, provider_established_in_third_country]`.

Citations follow the duty table of the order. Row 17 has `[eu_reg_2022_2554_art_29_1, eu_reg_2022_2554_art_29_1_a, eu_reg_2022_2554_art_29_1_b]`.

#### `trigger(Key, OwnTriggers)`

- `entity_exercises_access_inspection_and_audit_rights` — `[]`
- `arrangement_entails_high_technical_complexity` — `[entity_exercises_access_inspection_and_audit_rights]`
- `supports_critical_or_important_function` — `[]`
- `arrangement_allows_further_subcontracting` — `[supports_critical_or_important_function]`
- `provider_established_in_third_country` — `[supports_critical_or_important_function]`

#### `referral_citation(Key, Citation)`

There are twenty-four rows, one per judgement key, as in THE LIMBS. Note: `supports_critical_or_important_function` is referred under `eu_reg_2022_2554_art_28_4_a`.

#### `fixed_checked_citations(Citations)`

The six paragraph keys: Art 28(4), (5), (6), (8), Art 29(1) and (2).

#### `required_citation_rule(Trigger, Citations)`

This gives the conditional citations of R3.

#### Strategy rows

- `strategy_exemption(financial_entity_is_article_16_1_entity)`
- `strategy_exemption(financial_entity_is_microenterprise)`

These are in asking order, citing `eu_reg_2022_2554_art_28_2`.

#### Arrangement and trigger keys

- `arrangement_key(Key)`: the twenty-seven keys of the arrangement, derived as contract_key Order 1 to 27.
- `trigger_keys(List)`: the five triggers, in root_exports order.

### Derived rules

#### Basic duty states

- `duty_applies(Duty, Profile)`: every trigger is `true`. Uses `not_defeated/3` with `duty_defeated/2`, and requires that no trigger is absent or unsure.
- `duty_open(Duty, Profile)`: no trigger is `false`.
- `duty_fails(Duty, Profile)`: the duty applies and its key state is `false`.
- `under(Duty, Trigger)`: Trigger is a member of the duty's triggers.
- `not_true(State)`: the state is `false`, `unsure` or `absent`.

#### `can_change_answer(Profile, Key)` — the S2 rule

**(a) Duty key.** Key is the key of an open duty D, and there is no other duty E such that:

- E's key is false; and
- each of E's triggers is true, or is in D's triggers.

**(b) Trigger.** Key is a trigger T, and there is some open duty D under T such that:

- D's key is not true; and
- there is no duty E not under T whose key is false and each of whose triggers is true or is in D's triggers other than T.

#### `decides_alone(Profile, Key, ReliedUnsure)`

- **Duty key:** the key of a duty all of whose triggers are true or unsure. ReliedUnsure is the unsure ones.
- **Trigger:** some duty under the trigger has a false key, and its other triggers are true or unsure. ReliedUnsure is those that are unsure. The smallest set is taken; no tie can arise.

#### `behind(Profile, KeyX, KeyY)`

KeyX is behind KeyY when:

- KeyY decides alone relying only on unsure triggers among KeyX's triggers; and
- KeyX does NOT decide alone relying only on unsure triggers among KeyY's triggers.

A duty key's triggers are its duty's triggers. A trigger's triggers are its own triggers.

#### `can_change_list(Profile, Key)` — the M1 rule

Key is the key of an open duty, or Key is a trigger with an open duty under it whose key is not true.

#### Required-query helpers

- `required_candidate(Profile, Key)`: a trigger none of whose own triggers is false.
- `applying_duties(Profile, Duties)`: findall in duty order.
- `failing_duties(Profile, Duties)`: findall in duty order.
- `outstanding_citations(Duties, Citations)`: flattened and deduplicated, keeping first occurrence.

#### `duty_requirement(Duty, Profile, Status, Citation)`

The checklist row predicate. RequirementId comes first, as assess and eval_requirements expect. It has three disjoint clauses: met, unmet and unknown.

### Query routes (one clause per route, verdict in head)

#### `entity_duties_required`

1. **R0:** input problems.
2. **R1:** `once/1` first absent `required_candidate`.
3. **R2:** `once/1` first unsure `required_candidate`, with PAIRS over the five triggers.
4. **R3:** `required(Duties)` with the conditional citations.

#### `entity_duties_complete`

1. **S0:** input problems.
2. **S1:** some duty fails, giving `incomplete` with the fixed six.
3. **S2:** `once/1` first absent key in root_exports order (keys 1 to 27) such that the key can change the answer and is not behind another absent candidate.
4. **S3:** `once/1` first unsure judgement key that can change the answer, with PAIRS over the twenty-seven keys.
5. **S4:** `complete` with the fixed six.

#### `entity_duties_outstanding`

1. **M0:** input problems.
2. **M1:** first absent key that can change the list.
3. **M2:** first unsure key that can change the list.
4. **M3:** `none_outstanding` with the fixed six, or `outstanding(Failing)` with the duty citations.

#### `ict_third_party_strategy_required`

1. **T0:** input problems.
2. **T1:** split into two clauses, kept disjoint: Article 16(1) true; or Article 16(1) not true and microenterprise true. Result `strategy_not_required`.
3. **T2:** Article 16(1) absent and microenterprise not true, giving `indeterminate([financial_entity_is_article_16_1_entity])`.
4. **T3:** Article 16(1) false and microenterprise absent, giving `indeterminate([financial_entity_is_microenterprise])`.
5. **T4:** both false, giving `strategy_required`.

### Verdict atoms of this slice

- `required/1`
- `complete`, `incomplete`
- `none_outstanding`, `outstanding/1`
- `strategy_required`, `strategy_not_required`
- the status compounds

### Shared with another slice

There is no other slice. Only `key_state/3`, `contract_key/3`, the input check and `inputs_relied_on_pairs/3` go to the kernel, because `queries.clausal` and the facade need them too.

### Worked examples the fixtures must carry

Unless an example says otherwise, every other key is true. Where an example's facts leave keys absent, the answers below follow THE LIMBS.

#### `all_true_no_triggers`

Keys 1 to 6 are true. Triggers 7 and 11 are false. Keys 28 and 29 are absent.

- `required([1..6 duties])`, citing Art 28(4) and Art 28(5).
- `complete`, citing the fixed six.
- `none_outstanding`, citing the fixed six.
- Strategy query: `indeterminate([financial_entity_is_article_16_1_entity])`.

#### `full_critical_with_audit`

All twenty-seven keys are true.

- `required` lists all twenty-two duties, citing all six paragraphs.
- `complete`.

#### `exit_strategy_missing_one_false`

Trigger 11 is true, key 13 is false, and key 20 is absent.

- `entity_duties_complete`: `incomplete` (S1).
- `entity_duties_outstanding`: `indeterminate([considered_concentration_risk])`.

#### `d279_behind`

Key 7 is absent, key 8 is absent, trigger 11 is true, and key 13 is absent.

- `entity_duties_complete`: `indeterminate([exit_strategy_in_place])`. Key 7 and key 8 are both BEHIND key 13.

#### `critical_unsure_with_false_dependent`

Key 11 is unsure, key 12 is false, key 23 is absent and key 24 is absent.

- `entity_duties_complete`: `needs_legal_review(open_textured(supports_critical_or_important_function, cite(eu_reg_2022_2554_art_28_4_a)), [inputs_relied_on(Pairs)])`. Neither key 23 nor key 24 can change the answer.

#### `strategy_microenterprise`

Key 28 is false and key 29 is true.

- `strategy_not_required`, citing `[cite(eu_reg_2022_2554_art_28_2)]`.

#### Input-check fixtures

- A duplicated key 13 with differing values gives `[duplicate_key(exit_strategy_in_place)]`.
- `unsure` on key 23 gives `[wrong_type(arrangement_allows_further_subcontracting)]`.
- A string key and an unbound key give `unknown_key` with the term as given.
- A non-attribute element gives `[wrong_type(profile)]`.

### Tests (seven modes)

1. **Per-rule unit tests:** one per duty row and per trigger. Each covers applies, open and fails.
2. **Per-route tests:** each of R0 to R3, S0 to S4, M0 to M3 and T0 to T4.
3. **Counting:** `findall` and `length(_, 1)` on every query and fixture.
4. **Negative tests:** each paired with a positive test over the same case.
5. **Citation tests:** set equality; `[]` on every status.
6. **Exhaustive completion property:** over the trigger subspace and a sampled duty subspace. Wherever all completions agree, the answer is that common answer.
7. **Property tests via `validate_props`:** totality, determinism, citation completeness and missing-key coverage.
