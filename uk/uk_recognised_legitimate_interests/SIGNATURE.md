# SIGNATURE — uk/uk_recognised_legitimate_interests

## Public query surface

The query surface is the contract predicates (A)-(G) plus the scaffold facade.
- Every query yields exactly ONE solution. The scorer collects all solutions, so a duplicate is a refutation.
- Determinism comes from disjoint guards. No `!`, `->`, `*->` or `once/1` is used.
- Ground outputs are folded into clause heads (C17).
- Set-like citation lists are built with `findall` + `sort/2`.
- PROFILE is `[attribute(KEY, VALUE), ...]`, read only with `profile_get/3` (and `profile_has/2` / `profile_lacks/2` for presence).
- Keys and values are bare atoms. There are no strings and no Python booleans.
- There are no imported statutory figures, no numeric thresholds and no dates. The order has no date argument and answers for processing from 5 February 2026.

## Verdict STATUS atoms (replacing `required / permitted / not_applicable`)

**Final answers by query:**

| Query | Final atoms |
|---|---|
| `recognised_legitimate_interest/3` | `recognised_legitimate_interest_applies`, `recognised_legitimate_interest_does_not_apply` |
| `uk_legitimate_interests/3`, `eu_legitimate_interests/3` | `legitimate_interests_applies`, `legitimate_interests_does_not_apply` |
| `uk_legitimate_interest_basis/3` and both sides of the comparison | `legitimate_interest_basis_available`, `legitimate_interest_basis_not_available` |
| comparison DIFFERENCE | `same`, `differs`, `not_comparable` |
| `uk_right_to_object/3` | `objection_right_not_engaged`, `controller_must_no_longer_process`, `controller_may_continue_processing` |

**Not-final compounds:**
- `indeterminate([KEY])`: exactly one bare key atom. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(KEY, cite(CITE)), [inputs_relied_on(PAIRS)])`, with PAIRS written `KEY-VALUE`.
- `input_problems(PROBLEMS)`.
- A not-final answer has CITATIONS `[]` and CHANGED_BY `[]`.

**Constructors.** These are exported, never queried: `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

## Profile keys (root_exports / input_contract order — SEVENTEEN)

| # | Key | Type | Provision |
|---|---|---|---|
| 1 | `processing_by_a_public_authority_in_the_performance_of_its_tasks` | judgement | UK and EU Art 6(1) second subparagraph |
| 2 | `processing_necessary_for_a_disclosure_in_response_to_a_request` | judgement | Annex 1 para 1(a) |
| 3 | `request_states_need_for_article_6_1_e_processing_with_article_6_3_basis` | crisp | Annex 1 para 1(b) |
| 4 | `processing_necessary_for_national_security_public_security_or_defence` | judgement | Annex 1 para 2 |
| 5 | `event_is_an_emergency_within_part_2_of_the_civil_contingencies_act_2004` | judgement | Annex 1 para 4 |
| 6 | `processing_necessary_for_responding_to_the_emergency` | judgement | Annex 1 para 3 |
| 7 | `processing_necessary_for_detecting_investigating_or_preventing_crime_or_apprehending_or_prosecuting_offenders` | judgement | Annex 1 para 5 |
| 8 | `processing_necessary_for_safeguarding_an_individual` | judgement | Annex 1 paras 6, 7, 8(a) |
| 9 | `individual_aged_under_18` | crisp | Annex 1 para 7 |
| 10 | `controller_has_reasonable_cause_to_suspect_the_individual_is_at_risk` | judgement | Annex 1 para 8(b) |
| 11 | `legitimate_interest_pursued_by_the_controller_or_a_third_party` | judgement | Art 6(1)(f) UK/EU |
| 12 | `processing_necessary_for_that_legitimate_interest` | judgement | Art 6(1)(f) UK/EU |
| 13 | `interests_overridden_by_data_subject_interests_or_fundamental_rights` | judgement | Art 6(1)(f) UK/EU |
| 14 | `basis_relied_on` | enumeration | UK Art 21(1) |
| 15 | `objection_on_grounds_relating_to_particular_situation` | judgement | UK Art 21(1) |
| 16 | `controller_demonstrates_compelling_legitimate_grounds_that_override` | judgement | UK Art 21(1) |
| 17 | `processing_for_establishment_exercise_or_defence_of_legal_claims` | judgement | UK Art 21(1) |

**Value types:**
- judgement: `true | false | unsure`.
- crisp: `true | false`.
- `basis_relied_on`: `public_task | recognised_legitimate_interest | legitimate_interests | other_basis`.

## Citation-key atoms (canonical lexicon; never shortened)

- `uk_gdpr_art_6_1`
- `uk_gdpr_art_6_1_ea`
- `uk_gdpr_art_6_5`
- `uk_gdpr_annex_1_para_1`
- `uk_gdpr_annex_1_para_2`
- `uk_gdpr_annex_1_para_3`
- `uk_gdpr_annex_1_para_4`
- `uk_gdpr_annex_1_para_5`
- `uk_gdpr_annex_1_para_6`
- `uk_gdpr_annex_1_para_7`
- `uk_gdpr_annex_1_para_8`
- `uk_gdpr_art_6_1_f`
- `uk_gdpr_art_21_1`
- `eu_reg_2016_679_art_6_1`
- `eu_reg_2016_679_art_6_1_f`

`citations.clausal` maps each atom to its pinned unit id and file sha256 as provenance facts. The deferred S.I. 2026/82 and DUAA 2025 s.142 units get no atom.

## Public predicates

**Contract queries (A)-(G):**
- `recognised_legitimate_interest(Profile, Result, Citations)`: UK Art 6(1)(ea) via Art 6(5) and Annex 1, limb steps (0)-(5). Cites `uk_gdpr_art_6_1`, `uk_gdpr_art_6_1_ea`, `uk_gdpr_art_6_5` and `uk_gdpr_annex_1_para_1`..`uk_gdpr_annex_1_para_8`.
- `uk_legitimate_interests(Profile, Result, Citations)`: UK Art 6(1)(f) with the public-authority bar, steps (6)-(10). Cites `uk_gdpr_art_6_1_f`, `uk_gdpr_art_6_1`.
- `uk_legitimate_interest_basis(Profile, Result, Citations)`: (ea) or (f), steps (11)-(14) incl. (12a). Cites the union of the citations of the applying or failing sides.
- `eu_legitimate_interests(Profile, Result, Citations)`: EU Art 6(1)(f) with the EU bar, steps (15)-(19). Cites `eu_reg_2016_679_art_6_1_f`, `eu_reg_2016_679_art_6_1`.
- `compare_uk_eu_legitimate_interest_basis(Profile, UkResult, EuResult, Difference, ChangedBy)`: comparison, steps (20)-(22). ChangedBy is the RLI citations only when `differs`. This serves query type #5.
- `uk_right_to_object(Profile, Result, Citations)`: UK Art 21(1), steps (23)-(27). Cites `uk_gdpr_art_21_1`.
- `uk_recognised_legitimate_interests_input_problems(Profile, Problems)`: THE INPUT CHECK. Problems is the bare list, ordered as follows:
  1. per contract key in order, `duplicate_key(K)`, else `wrong_type(K)`;
  2. then `unknown_key(K)` in first-occurrence order.
  - A non-attribute list, unbound term, partial list or unbound element gives `[wrong_type(profile)]`.
  - The check is total: it never fails and never raises.

**Scaffold facade:**
- `decide_uk_recognised_legitimate_interests(Profile, Verdict)`: Verdict is `uk_recognised_legitimate_interests_verdict(Status, Citations)`. Status and Citations are exactly those of `recognised_legitimate_interest/3`. This is the headline determination (#3), citing Art 6(1), (ea), 6(5) and Annex 1.
- `uk_recognised_legitimate_interests_status(Profile, Status)`: Status is the Result of `recognised_legitimate_interest/3`. This is status determination (#3).
- `uk_recognised_legitimate_interests_checklist(Profile, Checklist)`: justification (#7). It returns `assessment(Profile, Decision, Items)` built with `assess/6` over `requirement/4`.
  - Items are `item(RequirementId, Status, cite(Key))`, one per requirement:
    - `public_authority_bar` (`uk_gdpr_art_6_1`);
    - `annex_1_condition_1` (`uk_gdpr_annex_1_para_1`) through `annex_1_condition_5` (`uk_gdpr_annex_1_para_6`).
  - Met items carry cite too. Status is `met`, `unmet(Reason)` or `unknown([Key])`. An `unsure` key gives `unknown([Key])`, and the verdict query (not the checklist) owns the referral.
  - It is informational: the contract answer is always that of `recognised_legitimate_interest/3`.
- `uk_recognised_legitimate_interests_what_if(Profile, Key, Value, Verdict)`: re-runs the headline decision on the profile with `attribute(Key, Value)` set by `profile_set/3`. Verdict is the `uk_recognised_legitimate_interests_verdict/2` term.
- `uk_recognised_legitimate_interests_fixture(Name, Profile)`: named fixtures, listed below.

## Planned reuse (manifest `uses:`)

**`formalize_lib`:**
- `profile_get/3`, `profile_has/2`, `profile_lacks/2` for presence, then value.
- `profile_set/3` for what_if.
- `assess/6`, `eval_requirements/4`, `item/3`, `unmet/1`, `unknown/1`, `labels/3`, `assessment/3` for the checklist.
- `memberd/2` and `not_member/2` for the enumeration and the contract-key membership tests in the input check.

**`validate_props`:**
- `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `bad_citation/1`.
- These cover the property test mode: exactly one solution on generated profiles, every cite atom in the vocabulary, and every key covered by an indeterminate case.

**`kit/query_combinators`:** `what_if/5` with the closure `decide_uk_recognised_legitimate_interests`, for the what_if facade.

**Not used:** `check_tri/4` / `check_tri_neg/4`. Their Kleene status has no `unsure` referral and no first-absent naming. The tri-state referral logic is local; the working notes (not published) records it as a recurring-pattern candidate.

**No family `_common` predicate is needed.** No currency, VAT, date, deadline or compliance module is used.

## Package layers

**kernel.clausal** holds only what the slice, queries and facade share:
- `root_key_order/1`: the seventeen keys in order.
- `judgement_key/1`, `crisp_key/1`, `enumeration_key_value/2`.
- The input check `uk_recognised_legitimate_interests_input_problems/2` and its total, cut-free attribute-list walker. It uses `var/1`/`nonvar/1` guards in disjoint clauses.
- `key_value_state/3`, which returns `absent | value(V)` without failing.
- `first_in_root_order/2`: the first of a key set in `root_key_order`.
- `present_pairs/3`: Key-Value pairs of the present keys of a row, in root order.
- The constructor exports.

**citations.clausal** holds the citation vocabulary facts `citation_key/1` and `citation_unit/3` (atom, unit id, sha256).

**parameters.clausal** holds the pin metadata only: `pin_fetch_date_iso('2026-11-13')` and `in_force_from_iso('2026-02-05')`, as documentation atoms. They are read by no rule, there are no numeric constants, and no date terms are built.

**queries.clausal** holds the public query wrappers that apply step (0), input problems first, and then delegate to the slice.

## Determination slice — `uk_recognised_legitimate_interests.clausal`

The slice is self-contained for the whole order.

### VALUE facts it owns

There are no thresholds, periods or money. The tables are:

**`annex_condition(ConditionId, Keys, MetCitations)`:**

| ConditionId | Keys | MetCitations |
|---|---|---|
| `annex_1_condition_1` | keys 2, 3 | `[cite(uk_gdpr_annex_1_para_1)]` |
| `annex_1_condition_2` | key 4 | `[cite(uk_gdpr_annex_1_para_2)]` |
| `annex_1_condition_3` | keys 5, 6 | `[cite(uk_gdpr_annex_1_para_3), cite(uk_gdpr_annex_1_para_4)]` |
| `annex_1_condition_4` | key 7 | `[cite(uk_gdpr_annex_1_para_5)]` |
| `annex_1_condition_5` | keys 8, 9, 10 | `[cite(uk_gdpr_annex_1_para_6), cite(uk_gdpr_annex_1_para_7), cite(uk_gdpr_annex_1_para_8)]` |

**`referral_row(Query, Key, Citation, Inputs)`.** The `citation` and the `inputs` used for PAIRS are as follows.

- **recognised_legitimate_interest.** Inputs are keys 1-10.
  - `uk_gdpr_art_6_1`: key 1.
  - `uk_gdpr_annex_1_para_1`: key 2.
  - `uk_gdpr_annex_1_para_2`: key 4.
  - `uk_gdpr_annex_1_para_4`: key 5.
  - `uk_gdpr_annex_1_para_3`: key 6.
  - `uk_gdpr_annex_1_para_5`: key 7.
  - `uk_gdpr_annex_1_para_6`: key 8.
  - `uk_gdpr_annex_1_para_8`: key 10.
- **uk_legitimate_interests.** Inputs are keys 1, 11, 12, 13.
  - `uk_gdpr_art_6_1`: key 1.
  - `uk_gdpr_art_6_1_f`: keys 11-13.
- **eu_legitimate_interests.** Inputs are keys 1, 11, 12, 13.
  - `eu_reg_2016_679_art_6_1`: key 1.
  - `eu_reg_2016_679_art_6_1_f`: keys 11-13.
- **uk_right_to_object.** Inputs are keys 14-17.
  - `uk_gdpr_art_21_1`: keys 15, 16, 17.
- PAIRS are the present keys of the row's Inputs, with their values, in root order.

**`engaging_basis/1`:** `public_task`, `recognised_legitimate_interest`, `legitimate_interests`.

### Rules / requirements

**Condition state.** `condition_state(Profile, ConditionId, State)` gives State `met | fails | open`. It uses disjoint clauses and is exactly one per condition.
- **C1**: `met` when both keys are true; `fails` when either key is false; otherwise `open`.
- **C2**: `met` when key 4 is true; `fails` when it is false; otherwise `open`.
- **C3**: `met` when both keys are true; `fails` when either key is false; otherwise `open`.
- **C4**: `met` when key 7 is true; `fails` when it is false; otherwise `open`.
- **C5**: `met` when key 8 is true and (key 9 is true or key 10 is true).
- **C5**: `fails` when key 8 is false, or keys 9 and 10 are both false.
- **C5**: otherwise `open`.

**`keys_that_can_still_matter(Profile, ConditionId, Keys)`.** These are the not-true keys of an open condition. For C5, key 9 is dropped when key 10 is true, and key 10 is dropped when key 9 is true.

**RLI steps (1)-(5).** The answers, in step order:
1. Key 1 true: `does_not_apply`, citing `[cite(uk_gdpr_art_6_1)]`.
2. Otherwise all five conditions fail: `does_not_apply`, citing `[ea, 6_5]`.
3. Otherwise key 1 false and some condition met: `applies`, citing `[ea, 6_5]` ∪ the citations of every met condition, via sort/2.
4. Otherwise NEEDED is not empty: `indeterminate([first of NEEDED])`.
   - When some condition is met, NEEDED is key 1 if absent.
   - When none is met, NEEDED is key 1 if absent, plus the absent keys that can still matter of the open conditions.
5. Otherwise: referral on the first unsure key. The candidates are key 1, plus the matter-keys of open conditions when none is met.

**UK (f), steps (6)-(10), and EU (f), steps (15)-(19).** These are identical in shape and differ only in citation atoms.
- Bar true: `does_not_apply`.
- Otherwise key 11 false, or key 12 false, or key 13 true: `does_not_apply`.
- Otherwise all settled the right way: `applies`.
- Otherwise the first absent of keys 1, 11, 12, 13: indeterminate.
- Otherwise the first unsure of those keys: referral.

**Basis, steps (11)-(14).**
- **(11)**: `available`, citing only the applying sides.
- **(12)**: `not_available`, citing CA ∪ CF.
- **(12a)**: key 1 is absent or unsure and one side would apply if it were false. Then:
  - key 1 absent gives `indeterminate([key 1])`;
  - key 1 unsure copies that side's referral on key 1, RA first.
- **(13)**: `indeterminate` naming the first key in root order among RA's and RF's named keys.
- **(14)**: the first referral of RA, then RF, copied unchanged.

**Comparison, steps (20)-(22).**
- EU legitimate interests results are mapped onto the basis atoms; a status compound is copied as itself.
- DIFFERENCE is decided by guards on the shape of each side.
- ChangedBy is the RLI citations when `differs`, else `[]`.
- With input problems: both sides are `input_problems(P)`, `not_comparable`, `[]`.

**Right to object, steps (23)-(27).** The answers, in step order:
1. Key 14 is `other_basis` or key 15 is false: `objection_right_not_engaged`.
2. Engaging basis, key 15 true, and key 16 or key 17 true: `controller_may_continue_processing`.
3. Engaging basis, key 15 true, keys 16 and 17 false: `controller_must_no_longer_process`.
4. Otherwise the first absent key, in this order:
   - key 14;
   - key 15;
   - key 16, unless key 17 is true;
   - key 17, unless key 16 is true.
5. Otherwise the first unsure key among keys 15, 16 and 17, with the same exceptions: referral citing `uk_gdpr_art_21_1`.

**Checklist `requirement/4`.** Arguments are in the order `requirement(RequirementId, Profile, Status, Citation)`. There are exactly three disjoint clauses per check: met / unmet / unknown.

### Verdict atoms

The slice uses all the final atoms listed under 'Verdict STATUS atoms' above, plus the not-final compounds.

### Shared predicates (kernel only)

The slice uses these from the kernel: `root_key_order/1`, `key_value_state/3`, `first_in_root_order/2`, `present_pairs/3`, the input check, and the constructors. Nothing else leaves the slice.

## Fixtures (`fixtures.clausal`) and expected answers

**RLI:**
- `public_authority_bar`: key 1 true gives RLI `does_not_apply` `[uk_gdpr_art_6_1]`, UK (f) `does_not_apply` and EU (f) `does_not_apply` `[eu_reg_2016_679_art_6_1]`.
- `all_conditions_fail`: every condition fails and key 1 is absent, giving RLI `does_not_apply` `[ea, 6_5]`.
- `crime_condition_met`: key 1 false, key 7 true, gives RLI `applies` `[ea, 6_5, para_5]`.
- `safeguarding_child`: key 8 true, key 9 true, key 10 absent, gives `applies` with paras 6-8.
- `safeguarding_adult_unsure_risk`: key 8 true, key 9 false, key 10 unsure, the rest failing, key 1 false, gives a referral on key 10 citing `uk_gdpr_annex_1_para_8`.
- `emergency_missing`: key 5 true, key 6 absent, the others failing, gives `indeterminate([processing_necessary_for_responding_to_the_emergency])`.
- `met_condition_authority_unsure`: key 4 true, key 1 unsure, gives a referral on key 1 citing `uk_gdpr_art_6_1`.

**Comparison:**
- `uk_differs_from_eu`: key 1 false, key 7 true, key 11 false, gives UK `available`, EU `not_available`, `differs`, ChangedBy the RLI citations.
- `same_via_f`: key 1 false, keys 11 and 12 true, key 13 false, all conditions failing, gives both `available` and `same`.
- `child_weight_in_balance`: key 13 false gives EU (f) `applies`. Q5: no separate child bar.

**Basis (12a):** `basis_12a`: key 1 unsure, a condition met, key 11 absent, gives the copied RLI referral on key 1.

**Right to object:**
- `object_not_engaged`: key 14 `other_basis` gives `objection_right_not_engaged`.
- `object_must_stop`: key 14 `recognised_legitimate_interest`, key 15 true, keys 16 and 17 false, gives `controller_must_no_longer_process`.
- `object_legal_claims`: key 17 true, key 16 absent, gives `controller_may_continue_processing`.

**Input check:**
- `bad_input_duplicate_and_unknown`: key 9 twice plus `foo(1)` gives `[duplicate_key(individual_aged_under_18)]` followed by `unknown_key` for the extra key.
- `not_a_list`: gives `[wrong_type(profile)]`.

## Totality and determinism claims

- For every term given as PROFILE, each of the seven queries yields exactly one solution.
- This is verified by `prop_totality/3` and `prop_determinism/3` over generated profiles: all tri-state combinations of the read keys, absence, duplicates, wrong types, and non-lists.
- Each citation is in `citation_key/1` (`prop_citation_complete/3`).
