# SIGNATURE — eu/ai_act/post_market_monitoring

This is the authoring plan for later phases. The layout is kept exactly as scaffolded:

`kernel -> citations -> parameters -> post_market_monitoring -> queries -> fixtures -> package facade`

The predicate prefix is `post_market_monitoring_`. The shape family is deontic.

## Public query surface (summary)

The CALLED CONTRACT has three predicates, and they are authoritative:

- `post_market_monitoring_duty_status(Profile, AssessmentDate, Result, Citations)`;
- `post_market_monitoring_integration_status(Profile, Result, Citations)`;
- `post_market_monitoring_input_problems(Profile, Problems)`.

RESULT is ONE term: either a result atom, or a bare status compound. CITATIONS is a flat, set-like list of `cite(Key)`, and it is `[]` when the answer is not final.

The scaffold facade names are kept. Each one dispatches on a QUERY term and wraps no status:

- `duty_status(Profile, AssessmentDate)`;
- `integration_status(Profile)`.

The facade verdict functor `post_market_monitoring_verdict/2` is the scaffold's own record. It is produced ONLY by `decide_post_market_monitoring/2`.

**Totality.** Every public predicate yields exactly one solution for every input term. It never fails and never raises. The input check comes first.

**Determinism.** The ladder clauses are mutually exclusive. The status engine selects by list order.

**Figures.** All statutory dates are value facts in `post_market_monitoring.clausal`. Nothing is imported from another domain, and nothing is re-declared.

## Verdict STATUS atoms (replace placeholder `{required, permitted, not_applicable}`)

The duty query uses these result atoms:

- `not_applicable_on_date`
- `not_a_provider`
- `not_a_high_risk_ai_system`
- `compliance_required_by_31_december_2030`
- `existing_system_without_significant_changes_not_covered`
- `compliance_required_by_2_august_2030`
- `duty_applies`

The integration query uses these result atoms:

- `not_a_provider`
- `not_a_high_risk_ai_system`
- `integration_not_available`
- `integration_available`

These are the status compounds for answers that are not final. They are bare, never wrapped, and never listed:

- `indeterminate([Key])`. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)])`. An optional, unscored `provenance(Clause, Citations)` may follow `inputs_relied_on`.
- `input_problems(Problems)`.

These are the problem terms:

- `duplicate_key(Key)`
- `wrong_type(Key)`
- `unknown_key(Key)`
- `wrong_type(profile)`
- `wrong_type(assessment_date)`

These result constructors are exported and never called as queries: `date/3`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1` and `duplicate_key/1`.

## Profile keys (eleven, in root_exports / input_contract order)

`Profile` is `[attribute(Key, Value), ...]`. Values are read ONLY by `profile_get/3`, by presence first and then by value. There are no numeric keys and no money.

**Crisp** keys take `true` or `false`. **Judgement** keys take `true`, `false` or `unsure`.

| # | Key | Type | Read by |
|---|---|---|---|
| 1 | `provider_of_the_system` | crisp | duty, integration |
| 2 | `system_is_a_high_risk_ai_system_listed_in_annex_iii` | crisp | duty, integration |
| 3 | `system_is_a_high_risk_ai_system_under_article_6_1_and_annex_i` | crisp | duty, integration |
| 4 | `component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027` | crisp | duty |
| 5 | `placed_on_the_market_or_put_into_service_before_the_chapter_iii_date` | crisp | duty |
| 6 | `significant_changes_in_design_as_from_the_chapter_iii_date` | judgement | duty |
| 7 | `intended_to_be_used_by_public_authorities` | judgement | duty |
| 8 | `covered_by_union_harmonisation_legislation_listed_in_section_a_of_annex_i` | crisp | integration |
| 9 | `point_5_annex_iii_system_of_a_financial_institution_under_union_financial_services_law` | crisp | integration |
| 10 | `post_market_monitoring_system_and_plan_already_established_under_that_legislation` | crisp | integration |
| 11 | `integration_achieves_an_equivalent_level_of_protection` | judgement | integration |

`AssessmentDate` is a ground term `date(Year, Month, Day)` of integers. It must be a real calendar day, with Year from 1 to 9999. It is not a profile key.

The query keys, in decision order, are:

- **Duty:** keys 1 to 7.
- **Integration:** keys 1, 2, 3, 8, 9, 10 and 11.

## Citation-key atoms (canonical lexicon scheme; never shortened)

- `eu_reg_2024_1689_art_72_1`
- `eu_reg_2024_1689_art_72_3`
- `eu_reg_2024_1689_art_72_4`
- `eu_reg_2024_1689_art_111_1`
- `eu_reg_2024_1689_art_111_2`
- `eu_reg_2024_1689_art_113_c`
- `eu_reg_2024_1689_art_113_c_i`
- `eu_reg_2024_1689_art_113_c_ii`

These are the referral row citations:

- `significant_changes_in_design_as_from_the_chapter_iii_date` cites `eu_reg_2024_1689_art_111_2`.
- `intended_to_be_used_by_public_authorities` cites `eu_reg_2024_1689_art_111_2`.
- `integration_achieves_an_equivalent_level_of_protection` cites `eu_reg_2024_1689_art_72_4`.

`citations.clausal` holds `citation_vocabulary/1` rows for these eight atoms, plus a `citation_unit/2` mapping to the pinned unit ids. For example, `eu_reg_2024_1689_art_72_1` maps to `02024R1689-20260727#parag_072.001`.

## Public predicates

### Contract

- `post_market_monitoring_duty_status(Profile, AssessmentDate, Result, Citations)`: the ladder steps (0) to (8) under THE STATUS RULE, over duty keys 1 to 7. Cites Art 72(1), 72(3), 111(1), 111(2), 113(c), (c)(i) and (c)(ii).
- `post_market_monitoring_integration_status(Profile, Result, Citations)`: the ladder steps (0) to (4) under THE STATUS RULE, over integration keys 1, 2, 3, 8, 9, 10 and 11. Cites Art 72(4).
- `post_market_monitoring_input_problems(Profile, Problems)`: the typed input check. `Problems` is a bare list in contract key order, then unknown keys in order of first occurrence. Cites no provision; it is the input contract.

### Query type #14, obligation surfacing

`post_market_monitoring_obligations(Profile, AssessmentDate, Obligations)`: what the provider must do on the given day.

- When the duty status is `duty_applies`, it gives the list `[establish_post_market_monitoring_system, document_post_market_monitoring_system, base_system_on_post_market_monitoring_plan, keep_plan_in_technical_documentation]`. This rests on Art 72(1) and Art 72(3).
- When the duty status is `compliance_required_by_31_december_2030` or `compliance_required_by_2_august_2030`, it gives `[bring_system_into_compliance_by_deadline]`. This rests on Art 111(1) or Art 111(2).
- When the duty status is any other final atom, it gives `[]`.
- When the answer is not final, it gives the status compound itself.

### Query type #15, deadline

`post_market_monitoring_deadline(Profile, AssessmentDate, Deadline, Citations)`: when the duty must be met.

- It gives `date(2030, 12, 31)` for `compliance_required_by_31_december_2030` (Art 111(1)).
- It gives `date(2030, 8, 2)` for `compliance_required_by_2_august_2030` (Art 111(2)).
- It gives the system's applicable start date for `not_applicable_on_date`, when the case decides it: `date(2027, 12, 2)` (Art 113(c)(i)) or `date(2028, 8, 2)` (Art 113(c)(ii)). Otherwise it gives `no_deadline`.
- It gives `already_due` for `duty_applies`.

The consequence of missing the deadline is documented as follows. From the deadline day onward, `post_market_monitoring_duty_status/4` answers `duty_applies`. The deadline is never shifted by a computed day.

### Query type #13, compliance check

`post_market_monitoring_action_permitted(Profile, AssessmentDate, Action, Verdict)`. `Action` is one of two atoms:

- `integrate_into_existing_system_and_plan`: permitted only if the integration status is `integration_available` AND the duty status is final (Art 72(4)).
- `meet_duty_under_article_72_alone`: always permitted when the duty status is `duty_applies` (Art 72(1) and Art 72(3)).

`Verdict` is `permitted`, `not_permitted`, or the controlling status compound. This uses norms `nm(article_72_4_integration_choice, permission)` and `nm(article_72_1_duty, obligation)` through `kit/compliance_lib` `compliance_check/7`.

### Query type #7, justification

`post_market_monitoring_checklist(Query, Checklist)`. `Checklist` is a list of `item(RequirementId, Status, cite(Key))`, and every item carries provenance. Status is `met`, `unmet(Reason)` or `unknown(Keys)`. The checklist is built with `formalize_lib` `eval_requirements/4`.

For the duty query, the requirement closure is `duty_requirement(AssessmentDate)`. For the integration query, it is `integration_requirement`.

### Facade

- `decide_post_market_monitoring(Query, post_market_monitoring_verdict(Status, Citations))`: dispatches `duty_status/2` or `integration_status/1` to the contract predicate. `Status` is the RESULT term unchanged.
- `post_market_monitoring_status(Query, Status)`: the same, without citations.
- `post_market_monitoring_what_if(Query, Key, Value, Result)`: overrides one profile key with `formalize_lib` `profile_set/3` and re-runs the query. `Result` is the new RESULT term.
- `post_market_monitoring_fixture(Name, Query, ExpectedResult, ExpectedCitations)`: the fixture rows in `fixtures.clausal`, used by every test mode.

## Planned reuse (manifest `uses:`)

- **`formalize_lib`**:
  - `profile_get/3` is the only value reader.
  - `profile_set/3` overrides keys for what-if.
  - `eval_requirements/4`, `item/3`, `unmet/1` and `unknown/1` build the checklist.
  - `check_tri/4` and `check_tri_neg/4` handle the judgement-key checklist items, with no hand-rolled tri-state.
  - `check_true/4` and `check_false/4` handle the crisp items.
  - `not_defeated/3` handles the defeasible default.
  - `memberd/2` and `not_member/2` handle list membership in the input check.
- **`kit/deadline_lib`**: `month_last_day/3`, for the real-calendar-day test only. Its `date_before/2` is NOT used for ladder tests, because the order requires an integer (Y, M, D) comparison on `date/3` compounds. A local `calendar_day_before/2` compares integers lexicographically.
- **`kit/compliance_lib`**: `nm/2` and `compliance_check/7`, for query type #13.
- **`kit/query_combinators`**: `diff_checklists/3`, so that the what-if tests report changed items.
- **`validate_props`**, in tests:
  - `run_props/1`;
  - `prop_totality/3`;
  - `prop_determinism/3`;
  - `prop_citation_complete/3`;
  - `prop_boundary_coverage/2`;
  - `prop_missing_key_coverage/3`;
  - `bad_citation/1`.
- **Vocabulary atoms**: `met`, `applicable`, `inapplicable`.
- **Not used**: `library(datetime)`. Its `date/3` does not exist yet. ASSESSMENT_DATE is the caller's `date(Y, M, D)` compound and is compared by integers only. No day arithmetic is needed.

## Shared floor — kernel.clausal (generic; holds only what more than one module needs)

- `post_market_monitoring_calendar_day(Date)`: true when Date is a ground `date(Y, M, D)` of integers with Y from 1 to 9999, M from 1 to 12, and D from 1 to the value of `month_last_day/3`. The query modules and the facade use it.
- `post_market_monitoring_calendar_day_before(Earlier, Later)`: an integer lexicographic comparison on (Y, M, D). It is three disjoint clauses, with no `@<`.
- `post_market_monitoring_check_profile(Profile, KeyTypes, Problems)`: the generic typed attribute-list check. It is total and cut-free.
  - A non-list, a partial list, an unbound term, or an element that is not `attribute(_, _)` gives `[wrong_type(profile)]`.
  - Otherwise it walks the contract keys in order, giving duplicate_key, then wrong_type.
  - Then it gives `unknown_key` for keys outside the contract, in order of first occurrence, deduplicated. Keys that are not atoms are treated as unknown, as given.
  - The raw list is traversed structurally here only. Values for decisions are always read with `profile_get/3`.
- `post_market_monitoring_resolve_status(QueryKeys, Profile, LadderClosure, Result, Citations)`: THE STATUS RULE engine.
  - It enumerates the completions over the absent query keys and the unsure query judgements, with values `[true, false]`.
  - It calls `LadderClosure` with `(CompletedProfile, Result, Citations)` on each completion.
  - Citations are compared as sets, by sorting.
  - It applies S1 (settled), then S2 (the first absent key that matters and is not behind another absent key), then S3 (the first unsure judgement that matters).
  - It gets the referral citation from `referral_citation/2`, and builds PAIRS from the present judgement keys of the query, in root_exports order.
  - It yields exactly one solution. Every selection walks the fixed key list. Guarded `once/1` is used only over ground finite sets.
  - There are at most 2^7 completions per query.

## Parameters — parameters.clausal

- `post_market_monitoring_contract_key(Key, Type)`: eleven rows in root_exports order. Type is `crisp` or `judgement`.
- `post_market_monitoring_query_keys(duty, Keys)` and `post_market_monitoring_query_keys(integration, Keys)`: the decision-order lists.
- `post_market_monitoring_judgement_key(Key)`, derived from the contract rows.
- `post_market_monitoring_referral_citation(Key, Citation)`: the three referral rows.

No statutory figure lives here. The dates live in the slice.

## Determination slice — post_market_monitoring.clausal

This slice is self-contained. It holds both ladders, the value facts, the checklist requirements and the per-rule tests.

### Statutory VALUE facts (owned here)

Each statutory date is declared once:

- `post_market_monitoring_statutory_date(annex_iii_chapter_three_application, date(2027, 12, 2), eu_reg_2024_1689_art_113_c_i)`.
- `post_market_monitoring_statutory_date(annex_i_chapter_three_application, date(2028, 8, 2), eu_reg_2024_1689_art_113_c_ii)`.
- `post_market_monitoring_statutory_date(annex_x_compliance_deadline, date(2030, 12, 31), eu_reg_2024_1689_art_111_1)`.
- `post_market_monitoring_statutory_date(public_authorities_compliance_deadline, date(2030, 8, 2), eu_reg_2024_1689_art_111_2)`.

Two dates are documented as named and NOT read by any limb:

- `general_application`, `date(2026, 8, 2)`, from the second paragraph of Art 113;
- the Annex X market cut-off, `date(2027, 8, 2)`, which is folded into key 4.

### Rules (ladder; complete profile; each a defeater of the default under guarded `once/1`)

These are the named tests:

- **`not_high_risk_test`**: keys 2 and 3 are both false.
- **`annex_i_only_test`**: key 2 is false and key 3 is true.
- **`annex_x_test`**: key 4 is true, and the date is before `date(2030, 12, 31)`.
- **`existing_system_test`**: key 4 is false, key 5 is true, and key 6 is false.
- **`not_covered_test`**: `existing_system_test` holds, and key 7 is false.
- **`public_authorities_test`**: `existing_system_test` holds, key 7 is true, and the date is before `date(2030, 8, 2)`.
- **`integration_test`**: key 8 or key 9 is true, key 10 is true, and key 11 is true.

`post_market_monitoring_duty_ladder(AssessmentDate, Profile, Result, Citations)` takes these steps in order:

| Step | Test | Result | Citations |
|---|---|---|---|
| (1) | Date before `date(2027, 12, 2)` | `not_applicable_on_date` | Art 113(c), (c)(i), (c)(ii) |
| (2) | Key 1 is false | `not_a_provider` | Art 72(1) |
| (3) | `not_high_risk_test` | `not_a_high_risk_ai_system` | Art 72(1) |
| (4) | `annex_i_only_test` and date before `date(2028, 8, 2)` | `not_applicable_on_date` | Art 113(c), (c)(ii) |
| (5) | `annex_x_test` | `compliance_required_by_31_december_2030` | Art 111(1), 72(1), 72(3) |
| (6) | `not_covered_test` | `existing_system_without_significant_changes_not_covered` | Art 111(2) |
| (7) | `public_authorities_test` | `compliance_required_by_2_august_2030` | Art 111(2), 72(1), 72(3) |
| (8) | Default | `duty_applies` | Art 72(1), 72(3) |

Each step is one clause, with the ground result folded into the head (C17). A step's body requires that every earlier step's test is FAILED, written as explicit disjoint failure literals, so routes stay mutually exclusive without `!` or `->`.

`post_market_monitoring_integration_ladder(Profile, Result, Citations)` takes these steps in order. Every step cites Art 72(4).

| Step | Test | Result |
|---|---|---|
| (1) | Key 1 is false | `not_a_provider` |
| (2) | `not_high_risk_test` | `not_a_high_risk_ai_system` |
| (3) | NOT `integration_test` | `integration_not_available` |
| (4) | Default | `integration_available` |

The contract predicates in this slice take these steps:

- `post_market_monitoring_duty_status/4`:
  1. The input check, plus the date check. On problems it gives `input_problems(ProfileProblems ++ [wrong_type(assessment_date)])`, with `[]` citations.
  2. Otherwise it calls `post_market_monitoring_resolve_status(DutyKeys, Profile, post_market_monitoring_duty_ladder(AssessmentDate), Result, Citations)`.
- `post_market_monitoring_integration_status/3`: the input check, then `resolve_status` with `post_market_monitoring_integration_ladder`.

### Checklist requirements (`requirement(Id, Profile, Status, cite(Key))`, three disjoint clauses each)

**Duty**, through the closure `duty_requirement(AssessmentDate)`:

- `chapter_three_date_reached`: the date is reached for the system's route. Cites Art 113(c).
- `provider_role`: `check_true` on key 1. Cites Art 72(1).
- `high_risk_classification`: key 2 or key 3. Cites Art 72(1).
- `not_annex_x_transitional`: cites Art 111(1).
- `not_existing_unchanged_system`: uses `check_tri_neg` on key 6, combined with key 5. Cites Art 111(2).
- `not_public_authorities_transitional`: uses `check_tri` on key 7. Cites Art 111(2).
- `plan_in_technical_documentation`: met whenever the duty applies. Cites Art 72(3).

**Integration**:

- `provider_role`: cites Art 72(4).
- `high_risk_classification`: cites Art 72(4).
- `integration_route`: key 8 or key 9. Cites Art 72(4).
- `existing_system_and_plan`: key 10. Cites Art 72(4).
- `equivalent_protection`: `check_tri` on key 11. Cites Art 72(4).

The checklist explains the ladder. The ladder and THE STATUS RULE decide the answer.

### Verdict atoms of this slice

The slice uses all the duty and integration result atoms listed above, plus the three status compounds.

### Predicates SHARED with other modules (live in kernel.clausal only)

- `post_market_monitoring_calendar_day/1`
- `post_market_monitoring_calendar_day_before/2`
- `post_market_monitoring_check_profile/3`
- `post_market_monitoring_resolve_status/5`

Nothing else is shared.

### Per-rule tests and fixtures (boundary set; every negative paired with a positive)

**Date and step gates (duty):**

| Fixture | Profile | Date | Expected result |
|---|---|---|---|
| `before_annex_iii_date` | empty profile | `date(2027, 12, 1)` | `not_applicable_on_date`, Art 113(c), (c)(i), (c)(ii). Settled with every key absent. |
| `annex_iii_first_day` | provider true, key 2 true, keys 3 to 7 false | `date(2027, 12, 2)` | `duty_applies`, Art 72(1), 72(3) |
| `annex_i_only_day_before` | Annex I only | `date(2028, 8, 1)` | `not_applicable_on_date`, Art 113(c), (c)(ii) |
| `annex_i_only_first_day` | Annex I only | `date(2028, 8, 2)` | `duty_applies` |
| `not_a_provider` | provider false | `date(2029, 1, 1)` | `not_a_provider` |
| `not_high_risk` | keys 2 and 3 false | `date(2029, 1, 1)` | `not_a_high_risk_ai_system` |

**Transitional rules (duty):**

| Fixture | Profile | Date | Expected result |
|---|---|---|---|
| `annex_x_day_before` | Annex X component | `date(2030, 12, 30)` | `compliance_required_by_31_december_2030` |
| `annex_x_day` | Annex X component | `date(2030, 12, 31)` | `duty_applies` |
| `annex_x_public_authorities` | Annex X component, key 7 true | `date(2030, 9, 1)` | `compliance_required_by_31_december_2030` (Q5) |
| `existing_unchanged` | existing system, keys 6 and 7 false | — | `existing_system_without_significant_changes_not_covered` |
| `existing_public_day_before` | existing system, public | `date(2030, 8, 1)` | `compliance_required_by_2_august_2030` |
| `existing_public_day` | existing system, public | `date(2030, 8, 2)` | `duty_applies` |
| `existing_changed_public` | key 6 true, key 7 true | `date(2029, 1, 1)` | `duty_applies` (Q6) |

**Statuses (duty):**

| Fixture | Profile | Date | Expected result |
|---|---|---|---|
| `missing_provider` | provider absent | `date(2029, 1, 1)` | `indeterminate([provider_of_the_system])` |
| `behind_placed_on_market` | key 4 absent, key 5 absent | `date(2029, 1, 1)` | `indeterminate([component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027])`. Key 5 is behind key 4. |
| `referral_significant_changes` | key 6 unsure, key 7 false | — | `needs_legal_review(open_textured(significant_changes_in_design_as_from_the_chapter_iii_date, cite(eu_reg_2024_1689_art_111_2)), [inputs_relied_on([significant_changes_in_design_as_from_the_chapter_iii_date-unsure, intended_to_be_used_by_public_authorities-false])])` |
| `missing_before_referral` | key 6 unsure, key 7 absent | — | `indeterminate([intended_to_be_used_by_public_authorities])` |

**Integration:**

| Fixture | Profile | Expected result |
|---|---|---|
| `integration_annex_i_available` | keys 8, 10 and 11 true | `integration_available` |
| `integration_annex_iii_covered` | key 2 true, key 8 true, keys 10 and 11 true | `integration_available` (Q10) |
| `integration_financial_without_plan` | key 9 true, key 10 false | `integration_not_available` (Q11) |
| `integration_not_equivalent` | key 11 false | `integration_not_available` |
| `integration_referral` | key 11 unsure, all else satisfied | `needs_legal_review(open_textured(integration_achieves_an_equivalent_level_of_protection, cite(eu_reg_2024_1689_art_72_4)), [inputs_relied_on([integration_achieves_an_equivalent_level_of_protection-unsure])])` |

**Input check:**

| Fixture | Input | Expected problems |
|---|---|---|
| `duplicate_key_value_ignored` | key 1 twice, with values true and maybe | `[duplicate_key(provider_of_the_system)]` |
| `crisp_unsure` | key 2 given unsure | `[wrong_type(system_is_a_high_risk_ai_system_listed_in_annex_iii)]` |
| `unknown_key_once` | an unknown key given twice | `[unknown_key(Key)]` |
| `not_attribute_list` | a list holding `foo` | `[wrong_type(profile)]` |
| `unbound_profile` | an unbound variable | `[wrong_type(profile)]` |
| `bad_date` | `date(2027, 2, 30)` | `input_problems([wrong_type(assessment_date)])` |
| `unbound_date` | an unbound variable | `input_problems([wrong_type(assessment_date)])` |
| `profile_and_date_problems` | profile problems plus a bad date | profile problems first, then `wrong_type(assessment_date)` |

**Counting.** Every fixture asserts `findall` length 1, and that the single answer equals the expected one.
