# SIGNATURE — eu/dora_register_of_information

## Public query surface

The domain package is laid out as determination slices over a shared kernel, in this order: `kernel` -> `citations` -> `parameters` -> `dora_register_of_information` -> `queries` -> `fixtures` -> package facade.

The three called-contract queries each take `Profile` and return `Result` and `Citations`:

- `register_of_information_duties_required/3`
- `register_of_information_duties_complete/3`
- `register_of_information_duties_outstanding/3`

The input check is `dora_register_of_information_input_problems/2`.

The scaffold facade keeps its names:

- `decide_dora_register_of_information(Profile, dora_register_of_information_verdict(Status, Citations))` delegates to `register_of_information_duties_complete/3`.
- `dora_register_of_information_status(Profile, Status)` projects the status from that verdict.

Guarantees for every public predicate:

- **Totality and determinism:** each public predicate yields exactly ONE solution for every term, including an unbound `Profile`. The scorer counts solutions.
- **Cut-free:** no `!`, `->` or `*->` is used. Ground outputs are folded into clause heads, one clause per disjoint route (C17).
- **Value types:** no float, string or record is ever returned.
- **No imported figures:** this order has no statutory numbers or dates, so nothing is imported and nothing is re-declared as a constant.

## Verdict STATUS atoms (replacing the scaffold placeholders)

The placeholder vocabulary `{ required, permitted, not_applicable }` is replaced by the forms below.

**Final answers:**

- `required(Duties)`: a compound of arity 1, from `register_of_information_duties_required`. `Duties` is a non-empty list of duty atoms in DUTY ORDER.
- `complete` and `incomplete`: atoms, from `register_of_information_duties_complete`.
- `none_outstanding` (an atom) or `outstanding(Duties)` (a compound of arity 1), from `register_of_information_duties_outstanding`. `Duties` is non-empty and in DUTY ORDER.

**Status compounds (never final, always `Citations = []`):**

- `input_problems(Problems)`. Each problem is one of `duplicate_key(Key)`, `wrong_type(Key)` or `unknown_key(Key)`.
- `indeterminate([Key])`: exactly one bare key. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`. An unscored `provenance(Clause, Citations)` item may optionally follow.

**Eligibility labels (query type #2):** `labels(complete, indeterminate, incomplete)`, passed to `assess/6`.

**Compliance-check verdicts (query type #13):**

- `permitted`
- `forbidden`
- `indeterminate([Key])`
- `input_problems(Problems)`

**Result constructors** (exported, never called as queries): `required/1`, `outstanding/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

## Profile keys (forty-two, in root_exports / input_contract order)

`Profile = [attribute(Key, Value), ...]`. It is read only with `profile_get/3`, presence first and then value.

There are no numeric, money or date keys, so no unit suffix and no `date(Year, Month, Day)` term occurs.

### Triggers (type `fact` = boolean: the atoms `true` or `false`)

1. `financial_entity_responsible_for_sub_consolidated_register`
2. `financial_entity_responsible_for_consolidated_register`
3. `competent_authority_requested_register`
4. `entity_plans_arrangement_supporting_critical_or_important_function`
5. `function_has_become_critical_or_important`
6. `entity_uses_ict_services_supporting_critical_or_important_functions`
7. `entity_has_branches_outside_home_country`
8. `ict_service_supply_chain_partly_intra_group`

### Judgement keys (type `judgement` = one_of boolean or unsure: the atoms `true`, `false` or `unsure`)

9. `register_maintained_and_updated_at_entity_level`
10. `register_maintained_and_updated_at_sub_consolidated_level`
11. `register_maintained_and_updated_at_consolidated_level`
12. `arrangements_documented_distinguishing_critical_or_important_functions`
13. `reported_to_competent_authorities_at_least_yearly`
14. `register_made_available_to_competent_authority_on_request`
15. `competent_authority_informed_of_planned_arrangement`
16. `competent_authority_informed_that_function_has_become_critical_or_important`
17. `rank_assigned_to_each_ict_third_party_service_provider`
18. `templates_include_information_on_all_ict_services_of_direct_providers`
19. `templates_include_information_on_subcontractors_underpinning_critical_or_important_functions`
20. `template_information_meets_data_quality_principles`
21. `template_information_reviewed_regularly_and_errors_corrected`
22. `entity_level_information_consistent_with_sub_consolidated_level`
23. `entity_level_information_consistent_with_consolidated_level`
24. `providers_identified_by_legal_entity_identifier_or_european_unique_identifier`
25. `subcontractors_identified_by_legal_entity_identifier_or_european_unique_identifier`
26. `data_elements_completed_with_single_values`
27. `all_data_elements_completed_at_each_applicable_level`
28. `register_includes_general_information_on_maintaining_entity`
29. `register_includes_general_information_on_entities_in_consolidation`
30. `register_includes_identification_of_branches_outside_home_country`
31. `register_includes_general_information_on_contractual_arrangements`
32. `register_includes_specific_information_on_contractual_arrangements`
33. `register_includes_links_between_intra_group_and_other_arrangements`
34. `register_includes_entities_signing_arrangements_for_receiving_ict_services`
35. `register_includes_providers_signing_arrangements_for_providing_ict_services`
36. `register_includes_entities_providing_ict_services_within_consolidation`
37. `register_includes_entities_making_use_of_ict_services`
38. `register_includes_information_on_direct_providers_and_subcontractors`
39. `register_includes_information_on_ict_service_supply_chain`
40. `register_includes_identification_of_functions`
41. `register_includes_assessment_of_ict_services_supporting_critical_or_important_functions`
42. `register_includes_terminology_and_closed_lists`

### Keys that are not part of this order

`financial_entity_is_article_16_1_entity`, `financial_entity_is_microenterprise` and `dora_entity_type` are not keys of this order. Each is reported as `unknown_key`. The atoms `true` and `false` are never pinned in `verdict_vocabulary` or `root_exports`.

## Citation-key atoms (canonical scheme, `_lexicon/citations.yaml`; `citation_vocabulary`)

**Paragraph keys (THE FIXED CITATIONS, fourteen):**

- `eu_reg_2022_2554_art_28_3`
- `eu_reg_2024_2956_art_2`
- `eu_reg_2024_2956_art_3_1`
- `eu_reg_2024_2956_art_3_2`
- `eu_reg_2024_2956_art_3_3`
- `eu_reg_2024_2956_art_3_4`
- `eu_reg_2024_2956_art_3_5`
- `eu_reg_2024_2956_art_3_6`
- `eu_reg_2024_2956_art_4_1`
- `eu_reg_2024_2956_art_4_2`
- `eu_reg_2024_2956_art_4_3`
- `eu_reg_2024_2956_art_5_1`
- `eu_reg_2024_2956_art_6_1`
- `eu_reg_2024_2956_art_6_2`

**Point keys (seventeen):**

- `eu_reg_2024_2956_art_3_2_a` and `eu_reg_2024_2956_art_3_2_b`
- `eu_reg_2024_2956_art_5_1_a` through `eu_reg_2024_2956_art_5_1_o` (letters a, b, c, d, e, f, g, h, i, j, k, l, m, n, o)

**Paragraph-of mapping:**

- every `eu_reg_2024_2956_art_3_2_X` maps to `eu_reg_2024_2956_art_3_2`;
- every `eu_reg_2024_2956_art_5_1_X` maps to `eu_reg_2024_2956_art_5_1`;
- every other key maps to itself.

No shortened citation atom is ever invented.

## Public predicates

**`register_of_information_duties_required(Profile, Result, Citations)`:** which duties apply. The steps are:

- (R0) input problems;
- (R1) `indeterminate([Trigger])`, naming the first absent trigger in key order;
- (R2) `required(Duties)`, with every applying duty in duty order. The citations are the paragraphs of those duties, each written once.

This query reads no judgement and never refers. Cites DORA Art 28(3) and ITS Arts 2 to 6.

**`register_of_information_duties_complete(Profile, Result, Citations)`:** whether all applying duties are performed. The steps are:

- (S0) input problems;
- (S1) `incomplete`, citing THE FIXED CITATIONS;
- (S2) `indeterminate([Key])`, applying <<DNUM>> behind-ordering;
- (S3) `needs_legal_review`;
- (S4) `complete`, citing THE FIXED CITATIONS.

Cites DORA Art 28(3) and ITS Arts 2 to 6.

**`register_of_information_duties_outstanding(Profile, Result, Citations)`:** which applying duties are not performed. The steps are:

- (M0) input problems;
- (M1) `indeterminate([Key])`;
- (M2) `needs_legal_review`;
- (M3) `none_outstanding`, citing THE FIXED CITATIONS, or `outstanding(Duties)`, citing the duty-table citations of those duties, each written once.

Cites DORA Art 28(3) and ITS Arts 2 to 6.

**`dora_register_of_information_input_problems(Profile, Problems)`:** the input check against the typed `input_contract`. It is the INPUT CHECK of the order and never fails or raises.

**`decide_dora_register_of_information(Profile, Verdict)`:** the facade verdict. `Verdict = dora_register_of_information_verdict(Status, Citations)`, where `Status` and `Citations` are those of `register_of_information_duties_complete/3`. This serves query types #2 and #7 together with the checklist. Cites THE FIXED CITATIONS when the status is final.

**`dora_register_of_information_status(Profile, Status)`:** the status projection of the facade verdict. Cites as above.

**`dora_register_of_information_checklist(Profile, Checklist)`:** the justification view (query type #7).

- The checklist is the `assessment(Subject, Decision, Checklist)` built by `assess/6` over the open duties, with `labels(complete, indeterminate, incomplete)`.
- One `item(DutyAtom, Status, cite(ReferralCitationKey))` is produced per duty that is not defeated.
- `Status` is `met` when the key is true, and `unmet(not_performed(Key))` when the key is false and the duty applies.
- `Status` is `unknown([Key])` when the key is absent or unsure. It is `unknown([Trigger])` when the trigger is absent.
- Duties whose trigger is false are defeated and omitted.
- This is an explanatory view only; the scored verdict is `decide_dora_register_of_information/2`.

Cites the referral citation of each item.

**`dora_register_of_information_eligibility(Profile, Assessment)`:** query type #2. It returns the same `assess/6` assessment, where `Decision` is one of `complete`, `indeterminate` or `incomplete` and the checklist carries `cite(...)` on every item. Input problems give `Assessment = input_problems(Problems)`.

**`dora_register_of_information_compliance_check(Profile, Action, Verdict)`:** query type #13.

- `Action` is `leave_unperformed(DutyAtom)`.
- Each duty is `nm(DutyAtom, obligatory)`, and leaving an applying obligatory duty unperformed is `forbidden`.
- If the duty is defeated (its trigger is false), the action is `permitted`.
- If the duty is open on an absent trigger, the verdict is `indeterminate([Trigger])`.
- An unknown duty atom gives `input_problems([unknown_key(DutyAtom)])`.

Implemented with `kit/compliance_lib` `compliance_check/7`, with the closure `duty_applies_to(Profile)` and a deny-overrides combining world. Cites the duty's citations.

**`dora_register_of_information_what_if(Profile, Key, Value, Result)`:** recomputes the facade status with `Key` set to `Value` (replacing, never duplicating, an existing entry). It uses `kit/query_combinators` `what_if/5`, with Decide = `dora_register_of_information_status`. Cites as the facade.

**`dora_register_of_information_fixture(FixtureName, Profile)`:** the named fixture profiles in `fixtures.clausal`, listed below.

## Planned reuse (manifest `uses:`)

**`formalize_lib`:**

- profile access: `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`;
- the defeater guard: `not_defeated/3`;
- the checklist engine and its terms: `assess/6`, `labels/3`, `item/3`, `unmet/1`, `unknown/1`, `assessment/3`;
- list helpers: `memberd/2`, `not_member/2`.

The local requirement predicate is passed as the closure `dora_register_of_information_requirement`, called as `requirement(DutyAtom, Profile, Status, Citation)` with the requirement id first. It has exactly three mutually exclusive clauses: met, unmet and unknown.

**`kit.query_combinators`:** `what_if/5`.

**`kit.compliance_lib`:** `nm/2`, `compliance_check/7`.

**`validate_props`** (tests only): `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `bad_citation/1`.

**Modules not used, and why:**

- `kit.deadline_lib`, `library(datetime)` and `kit.rolling_window`: no date is read.
- `currency_vocab`, `vat_category`, `country` and ratio helpers: there is no money, rate or country.
- `check_tri/4`: tri-state reading is done per duty against its condition, because the outcome depends on the trigger, so it does not apply directly.

**Family backbone (`_common`, deontic):** none required beyond formalize_lib. The duty-list pattern is local (see NOTES.md, Reuse notes).

**Defeasible idiom:**

```
duty_applies(Duty, Profile) :-
    duty_row(_, Duty, _, _, _),
    not_defeated(Duty, Profile, duty_condition_defeater).
```

The defeater `duty_condition_defeater(Duty, Profile)` holds when the row condition is `trigger(Trigger)` and `once(profile_get(Profile, Trigger, false))`. This is a guarded `once/1` defeater: cut-free, and safe because duplicates are rejected first by the input check.

---

## Slice: kernel.clausal (shared floor)

The kernel holds only predicates that more than one later file needs: the slice, `queries.clausal` and the facade.

**VALUE facts:**

- `contract_key(Position, Key, Type)`: forty-two rows. `Type` is `fact` for keys 1 to 8 and `judgement` for keys 9 to 42. These rows are the order of `input_contract` and `root_exports`.

**Shared predicates:**

- `dora_register_of_information_input_problems(Profile, Problems)`: the full INPUT CHECK.
  - A non-attribute-list `Profile` (an unbound variable, a partial list, an unbound element, or any element that is not `attribute(Key, Value)`) gives `[wrong_type(profile)]` alone.
  - Otherwise each contract key is checked in contract order. It gives `duplicate_key(Key)` if it occurs more than once, using `==` and reading no values. Otherwise it gives `wrong_type(Key)` if a present value is not in its type: an unbound value, a number, a string, or `unsure` on a trigger.
  - Then `unknown_key(Key)` is added once per non-contract key, in first-occurrence order, comparing keys with `==`.
  - A variable key is reported as that same variable, and a non-atom key is reported as given.
  - The check yields exactly one solution and never raises.
- `key_type_value(Type, Value)`: the type test. `fact` accepts `true` and `false`; `judgement` accepts `true`, `false` and `unsure`. It is guarded against unbound values with a groundness test.
- `present_pairs(Profile, Pairs)`: every `Key-Value` pair present in `Profile`, in contract order, with each value exactly as given. This is the single statement of the PAIRS rule.
- `first_in_key_order(Keys, Key)`: the first of a non-empty key set in contract order. It is deterministic via `contract_key/3` position ordering, without a cut.

## Slice: citations.clausal

**VALUE facts:**

- `citation_vocabulary(Key)`: thirty-one rows, as in the Citation-key list above.
- `paragraph_of(CitationKey, ParagraphKey)`: thirty-one rows.
- `fixed_citations(Citations)`: one row holding the fourteen `cite(...)` terms in the order listed above.

## Slice: parameters.clausal

There are no statutory figures: no threshold, period, amount or date is read (readings (10) and (18)). The file declares no `constant_value/2` and states why in a comment. It is kept for layout.

## Slice: dora_register_of_information.clausal (the one determination slice)

This slice is self-contained for the legal concept 'the register-of-information duties of one financial entity under DORA Art 28(3) and ITS Arts 2 to 6'.

### VALUE facts owned here (the duty table)

The table is `duty_row(Position, DutyAtom, ProfileKey, Condition, Citations)`.

- `Condition` is `always` or `trigger(TriggerKey)`.
- `Citations` is a list of `cite(Key)` terms, and the first element is the referral citation.

| # | DutyAtom | ProfileKey | Condition | Citations |
|---|---|---|---|---|
| 1 | register_at_entity_level | register_maintained_and_updated_at_entity_level | always | 28_3, 3_1 |
| 2 | register_at_sub_consolidated_level | register_maintained_and_updated_at_sub_consolidated_level | trigger(financial_entity_responsible_for_sub_consolidated_register) | 28_3, 3_1, 6_1, 6_2 |
| 3 | register_at_consolidated_level | register_maintained_and_updated_at_consolidated_level | trigger(financial_entity_responsible_for_consolidated_register) | 28_3, 3_1, 6_1, 6_2 |
| 4 | documentation_distinguishing_critical_or_important_functions | arrangements_documented_distinguishing_critical_or_important_functions | always | 28_3 |
| 5 | yearly_report_to_competent_authorities | reported_to_competent_authorities_at_least_yearly | always | 28_3 |
| 6 | register_made_available_on_request | register_made_available_to_competent_authority_on_request | trigger(competent_authority_requested_register) | 28_3 |
| 7 | information_on_planned_arrangement | competent_authority_informed_of_planned_arrangement | trigger(entity_plans_arrangement_supporting_critical_or_important_function) | 28_3 |
| 8 | information_on_function_become_critical_or_important | competent_authority_informed_that_function_has_become_critical_or_important | trigger(function_has_become_critical_or_important) | 28_3 |
| 9 | ranking_of_providers | rank_assigned_to_each_ict_third_party_service_provider | always | 2 |
| 10 | information_on_ict_services_of_direct_providers | templates_include_information_on_all_ict_services_of_direct_providers | always | 3_2_a |
| 11 | information_on_subcontractors_underpinning_critical_or_important_functions | templates_include_information_on_subcontractors_underpinning_critical_or_important_functions | trigger(entity_uses_ict_services_supporting_critical_or_important_functions) | 3_2_b |
| 12 | data_quality | template_information_meets_data_quality_principles | always | 3_3, 3_4 |
| 13 | regular_review_and_correction | template_information_reviewed_regularly_and_errors_corrected | always | 3_3 |
| 14 | consistency_with_sub_consolidated_level | entity_level_information_consistent_with_sub_consolidated_level | trigger(financial_entity_responsible_for_sub_consolidated_register) | 3_3 |
| 15 | consistency_with_consolidated_level | entity_level_information_consistent_with_consolidated_level | trigger(financial_entity_responsible_for_consolidated_register) | 3_3 |
| 16 | identifiers_of_providers | providers_identified_by_legal_entity_identifier_or_european_unique_identifier | always | 3_5 |
| 17 | identifiers_of_subcontractors | subcontractors_identified_by_legal_entity_identifier_or_european_unique_identifier | trigger(entity_uses_ict_services_supporting_critical_or_important_functions) | 3_6 |
| 18 | single_value_per_data_element | data_elements_completed_with_single_values | always | 4_1, 4_2 |
| 19 | all_data_elements_completed | all_data_elements_completed_at_each_applicable_level | always | 4_3 |
| 20 | general_information_on_maintaining_entity | register_includes_general_information_on_maintaining_entity | always | 5_1_a |
| 21 | general_information_on_entities_in_consolidation | register_includes_general_information_on_entities_in_consolidation | always | 5_1_b |
| 22 | identification_of_branches_outside_home_country | register_includes_identification_of_branches_outside_home_country | trigger(entity_has_branches_outside_home_country) | 5_1_c |
| 23 | general_information_on_contractual_arrangements | register_includes_general_information_on_contractual_arrangements | always | 5_1_d |
| 24 | specific_information_on_contractual_arrangements | register_includes_specific_information_on_contractual_arrangements | always | 5_1_e |
| 25 | links_between_intra_group_and_other_arrangements | register_includes_links_between_intra_group_and_other_arrangements | trigger(ict_service_supply_chain_partly_intra_group) | 5_1_f |
| 26 | entities_signing_arrangements_for_receiving_ict_services | register_includes_entities_signing_arrangements_for_receiving_ict_services | always | 5_1_g |
| 27 | providers_signing_arrangements_for_providing_ict_services | register_includes_providers_signing_arrangements_for_providing_ict_services | always | 5_1_h |
| 28 | entities_providing_ict_services_within_consolidation | register_includes_entities_providing_ict_services_within_consolidation | always | 5_1_i |
| 29 | entities_making_use_of_ict_services | register_includes_entities_making_use_of_ict_services | always | 5_1_j |
| 30 | direct_providers_and_subcontractors | register_includes_information_on_direct_providers_and_subcontractors | always | 5_1_k |
| 31 | ict_service_supply_chain | register_includes_information_on_ict_service_supply_chain | always | 5_1_l |
| 32 | identification_of_functions | register_includes_identification_of_functions | always | 5_1_m |
| 33 | assessment_of_ict_services_supporting_critical_or_important_functions | register_includes_assessment_of_ict_services_supporting_critical_or_important_functions | trigger(entity_uses_ict_services_supporting_critical_or_important_functions) | 5_1_n |
| 34 | terminology_and_closed_lists | register_includes_terminology_and_closed_lists | always | 5_1_o |

In the Citations column, the shorthand `28_3` stands for `cite(eu_reg_2022_2554_art_28_3)`, and `N_M[_x]` stands for `cite(eu_reg_2024_2956_art_N_M[_x])`. The authored file writes the full atoms. The referral citation of a key is its row's first citation; for example, `data_elements_completed_with_single_values` refers with `cite(eu_reg_2024_2956_art_4_1)`.

### Rules owned here

**Duty state.** For every row, the condition is evaluated as follows:

- `holds`: the condition is `always`, or its trigger is present and `true`.
- `fails`: the trigger is present and `false`. This is expressed as the defeater, through `not_defeated/3` and a guarded `once/1`.
- `open_condition`: the trigger is absent.

The resulting duty states are:

- **applies:** the condition holds.
- **open:** the condition does not fail.
- **fails:** the duty applies and its key is `false`.

The key value is one of `true`, `false`, `unsure` or `absent`.

**`duties_required/2`** (R1 and R2):

- R1: if any trigger is absent, the result is `indeterminate([FirstAbsentTrigger])`. Every trigger governs at least one open duty.
- R2: otherwise the result is the applying duties in position order, cited by their paragraphs through `paragraph_of/2`, each written once in first-occurrence order.

**`duties_complete/2`** (S1 to S4):

- **S1:** some duty fails, giving `incomplete`.
- **S2:** candidates are the absent keys that can still change the answer. Each duty has at most one condition, and S1 has not fired, so the general LIMBS tests reduce to the two below.
  - (a) The key of an open duty D is a candidate if D applies. It is also a candidate if D is under an absent trigger X and no other duty under X has a `false` key.
  - (b) A trigger X is a candidate if it is absent and some duty under X has a key that is not `true`.
  - A key DECIDES ALONE if it is the key of an applying duty, or if it is a trigger X with some duty under X whose key is `false`.
  - Named key: if any candidate decides alone, name the first decides-alone candidate in key order. Otherwise name the first candidate. This is the <<DNUM>> behind-rule.
  - Result: `indeterminate([Key])`.
  - The general LIMBS definitions remain the specification. The reduction is asserted by a property test that compares the reduced rule with the general definition over generated profiles.
- **S3:** the first `unsure` key of an open duty that passes test (a). At S3 every such duty applies. The result is `needs_legal_review(open_textured(Key, ReferralCite), [inputs_relied_on(Pairs)])`, with `Pairs` from `present_pairs/2`.
- **S4:** `complete`.

**`duties_outstanding/2`** (M1 to M3):

- **M1:** the first absent key in key order among (i) keys of open duties, including those under absent triggers, and (ii) absent triggers carrying an open duty whose key is not `true`. A `false` key does not stop this step.
- **M2:** the first `unsure` key of an open duty, giving `needs_legal_review`.
- **M3:** the duties that fail, in position order. An empty list gives `none_outstanding`. Otherwise the result is `outstanding(Duties)` with the union of their row citations, each written once.

**Requirement closure for the checklist and eligibility:** `dora_register_of_information_requirement(DutyAtom, Profile, Status, Citation)`, with three mutually exclusive clauses:

- met: the key is `true`;
- unmet: the key is `false` and the duty applies;
- unknown: the key is absent or `unsure`, or the trigger is absent.

### Verdict atoms of the slice

- `required/1`, `complete`, `incomplete`, `none_outstanding`, `outstanding/1`
- the statuses `indeterminate/1` and `needs_legal_review/2` with `open_textured/2`

### Predicates shared with other files (and therefore in kernel)

The slice uses these from the kernel: `contract_key/3`, `present_pairs/2`, `first_in_key_order/2` and the input check. It shares nothing else; the duty table stays in this slice.

### Per-rule tests, checklist and verdict tests in this slice

- One positive and one paired negative test per duty: it applies or does not apply on its trigger, and it fails on `false`.
- The S1 precedence: a `false` key beats absent and unsure keys.
- The <<DNUM>> cases:
  - an absent always-duty key is named before an absent trigger;
  - a trigger with a `false` duty under it is named first;
  - a duty key under an absent trigger is never named while the trigger is absent and decides alone.
- The <<DNUM>> case: an absent key is named before an unsure key is referred.
- Citation tests: fixed citations for `complete`, `incomplete` and `none_outstanding`; paragraph citations for `required`; point citations for `outstanding`.
- Single-solution tests, which count solutions via `findall` plus `length`.

## queries.clausal

The three called-contract predicates. Each has the step-0 input check (via the kernel), then delegates to the slice. Each produces exactly one solution through mutually exclusive clause heads keyed on `Problems = []` versus `[_|_]`.

## fixtures.clausal

Fixtures are `dora_register_of_information_fixture(FixtureName, Profile)`:

| Fixture | Expected result |
|---|---|
| `solo_entity_all_performed` | all triggers `false`, the twenty-two always-keys `true`; `complete` and `none_outstanding` |
| `group_parent_all_performed` | both group triggers `true`, all keys `true`; `complete` |
| `yearly_report_missed` | key 13 `false`; `incomplete` and `outstanding([yearly_report_to_competent_authorities])` |
| `triggers_missing` | `indeterminate([financial_entity_responsible_for_sub_consolidated_register])` |
| `data_quality_unsure` | `needs_legal_review(open_textured(template_information_meets_data_quality_principles, cite(eu_reg_2024_2956_art_3_3)), [inputs_relied_on(...)])` |
| `false_trigger_with_unread_duty_key` | duty key under a `false` trigger is present but ignored |
| `microenterprise_key_given` | `input_problems([unknown_key(financial_entity_is_microenterprise)])` |
| `unsure_trigger` | `input_problems([wrong_type(competent_authority_requested_register)])` |
| `duplicate_judgement` | `input_problems([duplicate_key(data_quality_key...)])`, written in full with the real key atom |
| `not_an_attribute_list` | `[wrong_type(profile)]` |
| `critical_function_entity_subcontractor_failure` | trigger 6 `true`, key 25 `false`; `outstanding([identifiers_of_subcontractors])` |
| `branches_and_intra_group_applying` | triggers 7 and 8 `true`; `required(...)` includes duties 22 and 25 |

## Package facade (dora_register_of_information.clausal at package root / facade module)

The facade re-exports:

- the three queries and the input check;
- `decide_dora_register_of_information/2`, `dora_register_of_information_status/2`, `dora_register_of_information_checklist/2`, `dora_register_of_information_eligibility/2`, `dora_register_of_information_compliance_check/3`, `dora_register_of_information_what_if/4`;
- `dora_register_of_information_fixture/2`;
- the result constructors.

## Test modes (seven) and v2 manifest

**Test modes:**

1. load
2. unit (per duty)
3. precedence (S, M and R steps; <<DNUM>>, <<DNUM>>)
4. input check (every problem form, including variable keys and float values)
5. properties (validate_props: totality, determinism, citation completeness, missing-key coverage)
6. fixtures (expected results)
7. facade (decide, status, checklist, eligibility, compliance check, what-if)

**v2 manifest:**

- `uses:` lists formalize_lib, kit.query_combinators, kit.compliance_lib and validate_props.
- `root_exports` lists the forty-two keys in contract order.
- `verdict_vocabulary` is `required`, `complete`, `incomplete`, `none_outstanding`, `outstanding`, `indeterminate`, `needs_legal_review`, `input_problems`. It never lists `true` or `false`.
- `citation_vocabulary` lists the thirty-one keys.
