# SIGNATURE — cn/pipl_handler_duties

Package layout (unchanged): kernel -> citations -> parameters -> pipl_handler_duties -> queries -> fixtures -> package facade.

- **Shape family:** deontic.
- **Manifest:** v2.
- **Test modes:** seven.
- **Determination slice:** one, `pipl_handler_duties.clausal`. It owns the duty ladders, the Art 74 value fact and the content lists.

The contract queries are exported with the exact interface names. The facade predicates keep the scaffold names.

## 1. Result (STATUS) atoms — replace the placeholder `{ required, permitted, not_applicable }`

### duty_status RESULT

**Final results:**
- `required`
- `required_in_advance`
- `required_immediately`
- `required_for_at_least_three_years`
- `notice_may_be_omitted`
- `not_required`
- `not_in_force`
- `pinned_text_not_applicable`

**Non-final results** (always CITATIONS `[]`):
- `indeterminate([KEY])` — exactly one key. The bare atom `indeterminate` is NEVER written.
- `needs_legal_review(open_textured(INPUT, cite(KEY)), [inputs_relied_on(PAIRS)])`.
- `input_problems(PROBLEMS)`.

### Facade STATUS (derived summary; NOTES S4 decision 16)

- `duties_owed` — eligible.
- `no_duties_owed` — ineligible.
- `duties_pending` — indeterminate.
- `not_in_force` — ineligible.
- `pinned_text_not_applicable` — ineligible.
- `input_problems(PROBLEMS)`.

### Problem terms

`duplicate_key(KEY)`, `wrong_type(KEY)`, `unknown_key(KEY)`, `wrong_type(profile)`.

### Result constructors (exported, never queried)

`indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`, `inputs_relied_on/1`, `provenance/2`, `content_item/2`, and the verdict wrapper `pipl_handler_duties_verdict/2`.

## 2. Profile keys (21, root_exports / input_contract order)

PROFILE is `[attribute(KEY, VALUE), ...]`. It is read ONLY with `profile_get/3` (presence first, then value), after the input check passes.

| # | Key | Type |
|---|---|---|
| 1 | `reference_date` | date: ground `date(Year, Month, Day)`, bare integers, Year >= 1, real Gregorian day |
| 2 | `pinned_articles_unamended_on_reference_date` | crisp |
| 3 | `decides_purposes_and_means` | judgement |
| 4 | `processes_on_entrustment` | crisp |
| 5 | `reaches_officer_quantity` | crisp |
| 6 | `handler_located_outside_china` | crisp |
| 7 | `personal_information_of_individuals_in_china` | crisp |
| 8 | `offers_products_or_services_to_individuals_in_china` | judgement |
| 9 | `analyses_or_evaluates_individuals_in_china` | judgement |
| 10 | `other_case_prescribed_by_law` | crisp |
| 11 | `processes_sensitive_personal_information` | crisp |
| 12 | `uses_automated_decision_making` | crisp |
| 13 | `entrusts_processing` | crisp |
| 14 | `provides_to_another_handler` | crisp |
| 15 | `makes_personal_information_public` | crisp |
| 16 | `provides_outside_china` | crisp |
| 17 | `other_significant_impact_processing` | judgement |
| 18 | `incident_occurred_or_possible` | crisp |
| 19 | `harm_effectively_avoided` | judgement |
| 20 | `department_required_individual_notice` | crisp |
| 21 | `important_platform_handler` | judgement |

Value types:
- **crisp:** `true` or `false`.
- **judgement:** `true`, `false` or `unsure`.

All values are bare atoms; there are no strings and no numbers other than the date components. No money or numeric quantities exist, so there are no unit suffixes.

## 3. Citation-key atoms (citation_vocabulary, canonical lexicon scheme; 40)

- **Art 3(2):** `cn_pipl_art_3_p2`, `cn_pipl_art_3_p2_i1`, `cn_pipl_art_3_p2_i2`, `cn_pipl_art_3_p2_i3`
- **Art 51:** `cn_pipl_art_51_p1`, `cn_pipl_art_51_p1_i1`, `cn_pipl_art_51_p1_i2`, `cn_pipl_art_51_p1_i3`, `cn_pipl_art_51_p1_i4`, `cn_pipl_art_51_p1_i5`, `cn_pipl_art_51_p1_i6`
- **Art 52:** `cn_pipl_art_52_p1`, `cn_pipl_art_52_p2`
- **Art 53:** `cn_pipl_art_53_p1`
- **Art 54:** `cn_pipl_art_54_p1`
- **Art 55:** `cn_pipl_art_55_p1`, `cn_pipl_art_55_p1_i1`, `cn_pipl_art_55_p1_i2`, `cn_pipl_art_55_p1_i3`, `cn_pipl_art_55_p1_i4`, `cn_pipl_art_55_p1_i5`
- **Art 56:** `cn_pipl_art_56_p1`, `cn_pipl_art_56_p1_i1`, `cn_pipl_art_56_p1_i2`, `cn_pipl_art_56_p1_i3`, `cn_pipl_art_56_p2`
- **Art 57:** `cn_pipl_art_57_p1`, `cn_pipl_art_57_p1_i1`, `cn_pipl_art_57_p1_i2`, `cn_pipl_art_57_p1_i3`, `cn_pipl_art_57_p2`
- **Art 58:** `cn_pipl_art_58_p1`, `cn_pipl_art_58_p1_i1`, `cn_pipl_art_58_p1_i2`, `cn_pipl_art_58_p1_i3`, `cn_pipl_art_58_p1_i4`
- **Art 59:** `cn_pipl_art_59_p1`
- **Art 73:** `cn_pipl_art_73_p1_i1`, `cn_pipl_art_73_p1_i2`
- **Art 74:** `cn_pipl_art_74_p1`

Units with no limb (`cn_pipl_art_3_p1`, `cn_pipl_art_73_p1_i3`, `cn_pipl_art_73_p1_i4`) are not in the vocabulary. Never shorten a citation atom.

## 4. Public predicates

- `duty_status(Duty, Profile, Result, Citations)`: the ladder of THE LIMBS for one of the twelve duty atoms. Exactly one solution. Citations are as in section 6. Cites PIPL Arts 3(2), 51 to 59, 73 items (1) and (2), and 74.
- `duty_contents(Topic, Items)`: one fixed list of `content_item(Name, cite(Key))` for `compliance_measures`, `impact_assessment`, `breach_notice` or `large_platform_obligations`. Single solution; one fact per topic, list in the head. Cites PIPL Art 51 items (1)-(6), 56(1) items (1)-(3), 57(1) items (1)-(3), 58 items (1)-(4).
- `pipl_handler_duties_input_problems(Profile, Problems)`: the typed input check. Never fails, never raises, one solution. Problems is `[]` when the profile is well-formed. Contract-level; no article cited.
- `decide_pipl_handler_duties(Profile, pipl_handler_duties_verdict(Status, Checklist))`: the eligibility verdict (query type #2) over the twelve duties.
  - Status is as in section 1.
  - Checklist is `[]` on input problems. Otherwise it is twelve `item(Duty, Result, cite(PrimaryKey))` in duty order (query type #7). Every item carries a citation.
  - Cites each duty's primary unit.
- `pipl_handler_duties_status(Profile, Status)`: projection of the verdict status. One solution.
- `pipl_handler_duties_checklist(Profile, Checklist)`: projection of the verdict checklist. One solution.
- `pipl_handler_duties_what_if(Profile, Key, Value, Verdict)`: sets `attribute(Key, Value)` with `profile_set/3`, then runs `decide_pipl_handler_duties/2`. One solution. Citations as the verdict.
- `pipl_handler_duties_fixture(Name, Profile, Duty, ExpectedResult, ExpectedCitations)` (fixtures module): named cases, at least one per ladder step per duty. They include:
  - date boundaries 2021-10-31, 2021-11-01 and 2021-09-30;
  - leap days 2000-02-29 (valid), 1900-02-29 (wrong_type), 2023-02-29 (wrong_type);
  - every input-problem shape;
  - each referral row.

Duty primary keys for the facade checklist:

| Duty | Primary key |
|---|---|
| compliance_measures | `cn_pipl_art_51_p1` |
| protection_officer | `cn_pipl_art_52_p1` |
| officer_contact_details | `cn_pipl_art_52_p2` |
| china_representative | `cn_pipl_art_53_p1` |
| compliance_audit | `cn_pipl_art_54_p1` |
| impact_assessment | `cn_pipl_art_55_p1` |
| assessment_record_retention | `cn_pipl_art_56_p2` |
| breach_remedial_measures | `cn_pipl_art_57_p1` |
| breach_notice_to_department | `cn_pipl_art_57_p1` |
| breach_notice_to_individuals | `cn_pipl_art_57_p2` |
| large_platform_obligations | `cn_pipl_art_58_p1` |
| entrusted_party_safeguards | `cn_pipl_art_59_p1` |

## 5. Planned reuse (manifest `uses:`)

- **formalize_lib**
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2`: profile access.
  - `profile_set/3`: what-if.
  - `eval_requirements/4`: builds the facade checklist. It is called with the closure `pipl_handler_duties_requirement`, whose clause is `pipl_handler_duties_requirement(Duty, Profile, Result, cite(PrimaryKey))`. Using it avoids an R1 clone of a findall over item rows.
  - `attribute/2`, `item/3`: constructors.
  - `assess/6`, `decide_labeled/3`, `check_tri/4`: NOT used. The results are duty atoms, not met/unmet. The kernel's tri-state helpers return key states (absent / true / false / unsure), not met/unmet statuses, so they are not a check_tri clone (C15).
- **kit/deadline_lib**
  - `month_last_day/3`: Gregorian day-of-month validity in the input check.
- **validate_props** (tests)
  - `run_props/1`, `prop_totality/3`, `prop_determinism/3`: one solution per duty and profile.
  - `prop_citation_complete/3`: every final result cites, every citation is in the vocabulary, and non-final results cite `[]`.
  - `prop_missing_key_coverage/3`, `prop_boundary_coverage/2`: the Art 74 day boundaries.
- **Not used**
  - library(datetime): no date arithmetic; the input stays a compound `date/3`.
  - compliance_lib, rolling_window, query_combinators.
  - The query_combinators `what_if/5` overrides dicts, while this profile is an attribute list, so `profile_set/3` is used instead.

## 6. Slice: pipl_handler_duties.clausal

### Value facts owned by this slice

- **Entry into force (Art 74):**
  - `:- constant_value(pipl_entry_into_force_year, 2021).`
  - `:- constant_value(pipl_entry_into_force_month, 11).`
  - `:- constant_value(pipl_entry_into_force_day, 1).`
- `before_entry_into_force(Profile)` compares integer components only: year less; or year equal and month less; or year and month equal and day less. It never uses standard order on a date compound.
- **Three-year minimum (Art 56(2)):** carried by the result atom `required_for_at_least_three_years`. No end day is computed, so no constant is read.
- **Content lists:** four `duty_contents/2` facts, exactly as specified in the interface. They hold 6, 3, 3 and 4 items, in text order, and no two items share an atom.

### Citation sets (fixed per final result, set-like; Q15)

- **NotInForce** = `[cite(cn_pipl_art_74_p1)]`, used by every duty.
- **Compliance** = `[cite(cn_pipl_art_51_p1), cite(cn_pipl_art_73_p1_i1)]`.
- **Officer** = `[cite(cn_pipl_art_52_p1), cite(cn_pipl_art_73_p1_i1)]`.
- **Contact** = `[cite(cn_pipl_art_52_p1), cite(cn_pipl_art_52_p2), cite(cn_pipl_art_73_p1_i1)]`.
- **Representative** = `[cite(cn_pipl_art_53_p1), cite(cn_pipl_art_3_p2), cite(cn_pipl_art_3_p2_i1), cite(cn_pipl_art_3_p2_i2), cite(cn_pipl_art_3_p2_i3), cite(cn_pipl_art_73_p1_i1)]`.
- **Audit** = `[cite(cn_pipl_art_54_p1), cite(cn_pipl_art_73_p1_i1)]`.
- **Occasions** = `[cite(cn_pipl_art_55_p1), cite(cn_pipl_art_55_p1_i1) .. cite(cn_pipl_art_55_p1_i5), cite(cn_pipl_art_73_p1_i1), cite(cn_pipl_art_73_p1_i2)]`.
  - Used for `not_required` of both assessment duties.
  - **AssessmentRequired** = Occasions plus `cite(cn_pipl_art_56_p1)`.
  - **RetentionRequired** = Occasions plus `cite(cn_pipl_art_56_p2)`.
- **Breach** = `[cite(cn_pipl_art_57_p1), cite(cn_pipl_art_73_p1_i1)]`, for remedial measures and the department notice.
- **Individuals** = `[cite(cn_pipl_art_57_p1), cite(cn_pipl_art_57_p2), cite(cn_pipl_art_73_p1_i1)]`.
- **Platform** = `[cite(cn_pipl_art_58_p1), cite(cn_pipl_art_73_p1_i1)]`.
- **Entrusted** = `[cite(cn_pipl_art_59_p1)]`.

Within each duty, `not_required` and the owed result share the duty's set. The two assessment duties are the exception, as stated above.

### Ladder mechanics (C17; no cut, no if-then-else)

1. `duty_status/4` first runs the input check.
   - On a non-empty PROBLEMS list, it gives `input_problems(PROBLEMS)` with CITATIONS `[]`.
   - On an empty list, it runs the ladder.
2. Each step is a numbered `duty_step(Duty, Step, Profile)` condition.
   - The result is folded into the head of a per-step result clause.
   - A step fires only if no lower-numbered step of that duty fires, tested with negation as failure (`\\+`).
3. Conditions are ground tests that succeed at most once. Duplicates are already excluded by the input check.
   - 'not true' means absent, false or unsure.
   - 'not false' means absent, true or unsure.
   - 'all of ... false' means every named key is present and false.
   - 'none of ... true' means no named key is present as true.
4. needs_legal_review results build PAIRS with a pair collector: the referral row's inputs, present only, in root order, as `Key-Value`.

### Common steps (every duty)

| Step | Condition | Result | Citations |
|---|---|---|---|
| 1 | reference_date before 2021-11-01 | `not_in_force` | NotInForce |
| 2 | reference_date absent | `indeterminate([reference_date])` | `[]` |
| 3 | pinned_articles_unamended_on_reference_date absent | `indeterminate([pinned_articles_unamended_on_reference_date])` | `[]` |
| 4 | pinned_articles_unamended_on_reference_date false | `pinned_text_not_applicable` | `[]` |

### Per-duty ladders (steps 5 onward, first firing step decides)

**compliance_measures** (Art 51)
- 5: decides_purposes_and_means false → `not_required` [Compliance].
- 6: decides_purposes_and_means absent → `indeterminate([decides_purposes_and_means])`.
- 7: decides_purposes_and_means unsure → `needs_legal_review(open_textured(decides_purposes_and_means, cite(cn_pipl_art_73_p1_i1)), [inputs_relied_on(PAIRS)])`, row handler_for_handler_duties.
- 8: otherwise → `required` [Compliance].

**compliance_audit** (Art 54)
- The same ladder as compliance_measures, with the Audit citations.

**protection_officer** (Art 52(1))
- 5: decides_purposes_and_means false → `not_required` [Officer].
- 6: reaches_officer_quantity false → `not_required` [Officer].
- 7: decides_purposes_and_means absent → indeterminate.
- 8: reaches_officer_quantity absent → indeterminate.
- 9: decides_purposes_and_means unsure → referral, row handler_for_handler_duties.
- 10: otherwise → `required` [Officer].

**officer_contact_details** (Art 52(2) with 52(1))
- The same ladder as protection_officer, with the Contact citations.

**china_representative** (Art 53 with Art 3(2))
- 5: decides_purposes_and_means false → `not_required` [Representative].
- 6: handler_located_outside_china false → `not_required` [Representative].
- 7: personal_information_of_individuals_in_china false → `not_required` [Representative].
- 8: all of offers_products_or_services_to_individuals_in_china, analyses_or_evaluates_individuals_in_china and other_case_prescribed_by_law false → `not_required` [Representative].
- 9: decides_purposes_and_means absent → indeterminate.
- 10: handler_located_outside_china absent → indeterminate.
- 11: personal_information_of_individuals_in_china absent → indeterminate.
- 12: offers_products_or_services_to_individuals_in_china absent, and analyses_or_evaluates_individuals_in_china not true, and other_case_prescribed_by_law not true → indeterminate.
- 13: analyses_or_evaluates_individuals_in_china absent, and offers_products_or_services_to_individuals_in_china not true, and other_case_prescribed_by_law not true → indeterminate.
- 14: other_case_prescribed_by_law absent, and offers_products_or_services_to_individuals_in_china not true, and analyses_or_evaluates_individuals_in_china not true → indeterminate.
- 15: decides_purposes_and_means unsure → referral, row handler_for_representative.
- 16: offers_products_or_services_to_individuals_in_china unsure, and analyses_or_evaluates_individuals_in_china not true, and other_case_prescribed_by_law false → referral with `cite(cn_pipl_art_3_p2_i1)`, row products_or_services_purpose.
- 17: analyses_or_evaluates_individuals_in_china unsure, and offers_products_or_services_to_individuals_in_china false, and other_case_prescribed_by_law false → referral with `cite(cn_pipl_art_3_p2_i2)`, row analysis_or_evaluation.
- 18: otherwise → `required` [Representative].

**impact_assessment** (Art 55)
- The seven occasion keys, in root order: processes_sensitive_personal_information, uses_automated_decision_making, entrusts_processing, provides_to_another_handler, makes_personal_information_public, provides_outside_china, other_significant_impact_processing.
- 5: decides_purposes_and_means false → `not_required` [Occasions].
- 6: all seven occasion keys false → `not_required` [Occasions].
- 7: decides_purposes_and_means absent → indeterminate.
- 8 to 14: each occasion key in root order, if absent while none of the other six is true → `indeterminate([that key])`.
- 15: decides_purposes_and_means unsure → referral, row handler_for_impact_assessment.
- 16: other_significant_impact_processing unsure and the other six all false → referral with `cite(cn_pipl_art_55_p1_i5)`, row other_significant_impact.
- 17: otherwise → `required_in_advance` [AssessmentRequired].

**assessment_record_retention** (Art 56(2) with Art 55)
- The same ladder as impact_assessment.
- Step 17 instead gives `required_for_at_least_three_years` [RetentionRequired].
- Steps 5 and 6 give `not_required` [Occasions].

**breach_remedial_measures** (Art 57(1))
- 5: decides_purposes_and_means false → `not_required` [Breach].
- 6: incident_occurred_or_possible false → `not_required` [Breach].
- 7: decides_purposes_and_means absent → indeterminate.
- 8: incident_occurred_or_possible absent → indeterminate.
- 9: decides_purposes_and_means unsure → referral, row handler_for_handler_duties.
- 10: otherwise → `required_immediately` [Breach].

**breach_notice_to_department** (Art 57(1))
- The same ladder as breach_remedial_measures.
- Step 10 instead gives `required` [Breach].

**breach_notice_to_individuals** (Art 57(1) and (2))
- 5: decides_purposes_and_means false → `not_required` [Individuals].
- 6: incident_occurred_or_possible false → `not_required` [Individuals].
- 7: decides_purposes_and_means absent → indeterminate.
- 8: incident_occurred_or_possible absent → indeterminate.
- 9: decides_purposes_and_means true and department_required_individual_notice true → `required` [Individuals].
- 10: decides_purposes_and_means true and harm_effectively_avoided false → `required` [Individuals].
- 11: harm_effectively_avoided absent and department_required_individual_notice not true → indeterminate.
- 12: department_required_individual_notice absent and harm_effectively_avoided not false → indeterminate.
- 13: decides_purposes_and_means unsure → referral, row handler_for_individual_notice.
- 14: harm_effectively_avoided unsure → referral with `cite(cn_pipl_art_57_p2)`, row harm_effectively_avoided.
- 15: otherwise → `notice_may_be_omitted` [Individuals].

**large_platform_obligations** (Art 58)
- 5: decides_purposes_and_means false → `not_required` [Platform].
- 6: important_platform_handler false → `not_required` [Platform].
- 7: decides_purposes_and_means absent → indeterminate.
- 8: important_platform_handler absent → indeterminate.
- 9: decides_purposes_and_means unsure → referral, row handler_for_large_platform.
- 10: important_platform_handler unsure → referral with `cite(cn_pipl_art_58_p1)`, row important_platform.
- 11: otherwise → `required` [Platform].

**entrusted_party_safeguards** (Art 59; decides_purposes_and_means is not read)
- 5: processes_on_entrustment false → `not_required` [Entrusted].
- 6: processes_on_entrustment absent → indeterminate.
- 7: otherwise → `required` [Entrusted].

### Referral rows (PAIRS inputs, in root order)

| Row | Inputs |
|---|---|
| handler_for_handler_duties | decides_purposes_and_means |
| handler_for_representative | decides_purposes_and_means, offers_products_or_services_to_individuals_in_china, analyses_or_evaluates_individuals_in_china |
| products_or_services_purpose | the same three as handler_for_representative |
| analysis_or_evaluation | the same three as handler_for_representative |
| handler_for_impact_assessment | decides_purposes_and_means, other_significant_impact_processing |
| other_significant_impact | decides_purposes_and_means, other_significant_impact_processing |
| handler_for_individual_notice | decides_purposes_and_means, harm_effectively_avoided |
| harm_effectively_avoided | decides_purposes_and_means, harm_effectively_avoided |
| handler_for_large_platform | decides_purposes_and_means, important_platform_handler |
| important_platform | decides_purposes_and_means, important_platform_handler |

No optional provenance item is emitted.

### Slice tests (per rule)

- One test per ladder step per duty, checking both RESULT and CITATIONS.
- A `findall` count of 1 for every query.
- Every negative test is paired with a positive test over the same case.

## 7. Kernel (kernel.clausal) — only what must be shared

- **Key-state readers over `profile_get/3` and `profile_lacks/2`:**
  - `key_absent/2`, `key_true/2`, `key_false/2`, `key_unsure/2`;
  - `key_not_true/2`, `key_not_false/2`;
  - `all_keys_false/2`, `no_key_true/2`.
- **Pair collector:** `relied_on_pairs(Profile, Keys, Pairs)`.
- These are shared by the slice, the facade summary and the fixtures. Nothing statutory lives here.

## 8. Other scaffold files (names unchanged)

- **citations.clausal** — `citation_vocabulary/1` (the 40 keys) and `duty_primary_citation/2` (the 12 rows in section 4).
- **parameters.clausal** — the input contract only:
  - `input_contract_key/2` gives the 21 keys in order, with types date / crisp / judgement.
  - It holds no statutory figure; those live in the slice.
- **Input check** — `pipl_handler_duties_input_problems/2`, guarded by var / atom / integer / is_list tests so it never raises.
  - `wrong_type(profile)` for:
    - an unbound profile;
    - a partial list;
    - a list with an unbound element;
    - a list with any element that is not `attribute(KEY, VALUE)`.
  - Then, per contract key in order: `duplicate_key(KEY)` if it repeats, which reads no values. Else `wrong_type(KEY)`:
    - for an unbound value;
    - for a value outside its type;
    - for a date that is not ground, has non-integer components, has Year < 1 or a Month outside 1-12, or has a Day outside 1 to `month_last_day`.
  - Then `unknown_key(KEY)` once per non-contract key, in order of first occurrence, compared with `==`. A key that is not an atom is reported as given.
- **queries.clausal** — `duty_status/4` and `duty_contents/2` re-exported, plus the facade summary rules (NOTES S4 decision 16), one clause per disjoint route.
- **fixtures.clausal** — `pipl_handler_duties_fixture/5`.
- **Package facade** — `decide_pipl_handler_duties/2`, `pipl_handler_duties_status/2`, `pipl_handler_duties_checklist/2`, `pipl_handler_duties_what_if/4`, the fixtures, and the contract queries.

## 9. Claims

- **Totality:** every query yields exactly one solution for every DUTY or TOPIC atom and every PROFILE term. The input check never fails or raises.
- **Determinism:** no duplicate answers, checked with `findall` and `length` 1.
- **No invented figures:** no hour, day or quantity limit exists; the Art 74 day is the only statutory value.
