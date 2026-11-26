# SIGNATURE — ae/uae_pdpl_lawful_processing_and_consent

This package answers three PDPL questions about one processing of personal data on one processing date, and adds a facade over the lawful-basis question.

## Contract surface

**The three called queries.** Each is `QUERY(Profile, Result, Citations)`:

- `pdpl_processing_lawful_basis/3`
- `pdpl_consent_valid/3`
- `pdpl_processing_controls/3`

**The input check.** `uae_pdpl_lawful_processing_and_consent_input_problems(Profile, Problems)`.

**Determinism and totality.**
- Every query yields EXACTLY ONE solution for every profile.
- Ladders are disjoint, one clause per route, and verdict constants are folded into clause heads (C17).
- There is no `!`, `->` or `*->`.
- The input check yields exactly one solution for every term, and never fails or raises.

**Imported figures.** None. The only statutory value is the commencement date, which the slice owns.

## Verdict STATUS atoms (replace the scaffold placeholders)

The scaffold placeholder `{ required, permitted, not_applicable }` is replaced.

**pdpl_processing_lawful_basis RESULT:**
- `allowed_with_consent`
- `allowed_without_consent(CASE)`, where CASE is one of: `public_interest`, `data_made_public_by_data_subject`, `legal_claims_and_judicial_or_security_procedures`, `occupational_or_preventive_medicine_and_health_or_social_care`, `public_health`, `archival_scientific_historical_or_statistical_purposes`, `interests_of_data_subject`, `employment_social_security_and_social_protection`, `contract_with_data_subject`, `obligations_under_other_laws`
- `not_allowed`
- `not_in_force`

**pdpl_consent_valid RESULT:**
- `valid`
- `not_valid(ATOM)`, where ATOM is one of: `consent_not_given`, `consent_not_specific_clear_and_unambiguous`, `controller_cannot_prove_consent`, `consent_not_clear_simple_and_easily_accessible`, `consent_omits_easy_withdrawal_right`, `consent_withdrawn`
- `not_in_force`

**pdpl_processing_controls RESULT:**
- `meets_listed_controls`
- `fails_control(ATOM)`, where ATOM is one of: `control_1_fair_transparent_and_lawful`, `control_2_specific_and_clear_purpose`, `control_2_no_incompatible_later_processing`, `control_3_sufficient_and_limited`, `control_4_accurate_and_updated`, `control_5_incorrect_data_deleted_or_corrected`, `control_6_kept_securely`, `control_7_not_kept_after_purpose_exhausted`
- `not_in_force`

**Status compounds (non-final), shared by all three queries; CITATIONS is always `[]`:**
- `indeterminate([KEY])`: exactly one key. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(KEY, cite(C)), [inputs_relied_on([KEY-unsure])])`
- `input_problems(PROBLEMS)`, where PROBLEMS holds `duplicate_key(K)`, `wrong_type(K)`, `unknown_key(K)` or `wrong_type(profile)`.

**Facade eligibility labels (query type #2):** `labels(eligible, indeterminate, ineligible)`. They are used by the checklist assessment only.

**Result constructors** (exported, never called as queries): `allowed_without_consent/1`, `not_valid/1`, `fails_control/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`, `inputs_relied_on/1`, `provenance/2`.

## Profile keys

The profile is `[attribute(KEY, VALUE), ...]`, read only with `profile_get/3`. There are 25 keys, listed below in root_exports and input_contract order.

| # | Key | Short | Type |
|---|---|---|---|
| 1 | `processing_date` | D | `date(Year, Month, Day)`: integers, a real Gregorian day, years 1 to 9999 |
| 2 | `consent_given` | CG | crisp: true / false |
| 3 | `consent_specific_clear_and_unambiguous` | CD | judgement: true / false / unsure |
| 4 | `controller_able_to_prove_consent` | CP | crisp |
| 5 | `consent_clear_simple_unambiguous_and_easily_accessible` | CC | judgement |
| 6 | `consent_includes_right_to_withdraw_easily` | CW | judgement |
| 7 | `consent_withdrawn_before_processing` | WD | crisp |
| 8 | `necessary_to_protect_public_interest` | E1 | judgement |
| 9 | `personal_data_made_available_and_known_to_all_by_data_subject` | E2 | judgement |
| 10 | `necessary_for_legal_claims_defence_of_rights_or_judicial_or_security_procedures` | E3 | judgement |
| 11 | `necessary_for_occupational_or_preventive_medicine_or_health_or_social_care` | E4 | judgement |
| 12 | `necessary_to_protect_public_health` | E5 | judgement |
| 13 | `necessary_for_archival_purposes_or_scientific_historical_or_statistical_studies` | E6 | judgement |
| 14 | `necessary_to_protect_interests_of_data_subject` | E7 | judgement |
| 15 | `necessary_for_employment_social_security_or_social_protection_obligations_and_rights` | E8 | judgement |
| 16 | `necessary_for_contract_with_data_subject` | E9 | judgement |
| 17 | `necessary_for_specific_obligations_of_controller_under_other_laws` | E10 | judgement |
| 18 | `processed_fairly_transparently_and_lawfully` | K1 | judgement |
| 19 | `collected_for_specific_and_clear_purpose` | K2 | judgement |
| 20 | `later_processing_compatible_with_purpose` | K3 | judgement |
| 21 | `sufficient_and_limited_to_what_is_necessary` | K4 | judgement |
| 22 | `accurate_correct_and_updated` | K5 | judgement |
| 23 | `measures_taken_to_delete_or_correct_incorrect_data` | K6 | judgement |
| 24 | `kept_securely` | K7 | judgement |
| 25 | `not_kept_after_purpose_exhausted` | K8 | judgement |

The profile has no numeric or money keys and no attested envelopes.

## Citation-key atoms (canonical lexicon scheme, citations.clausal)

**Load-bearing** (cited by some result):
- `uae_pdpl_art_31`
- `uae_pdpl_art_1_consent`
- `uae_pdpl_art_4`, and `uae_pdpl_art_4_1` to `uae_pdpl_art_4_10`
- `uae_pdpl_art_5`, and `uae_pdpl_art_5_1` to `uae_pdpl_art_5_7`
- `uae_pdpl_art_6_1`, `uae_pdpl_art_6_1_a`, `uae_pdpl_art_6_1_b`, `uae_pdpl_art_6_1_c`, `uae_pdpl_art_6_2`

**Deferred** (in the vocabulary, never in a result):
- `uae_pdpl_art_1`
- `uae_pdpl_art_1_personal_data`, `uae_pdpl_art_1_sensitive_personal_data`, `uae_pdpl_art_1_data_subject`, `uae_pdpl_art_1_controller`, `uae_pdpl_art_1_processing`, `uae_pdpl_art_1_anonymization`
- `uae_pdpl_art_4_11`
- `uae_pdpl_art_5_8`
- `uae_pdpl_art_6`
- `uae_pdpl_art_28`, `uae_pdpl_art_29`

No shortened citation atom is ever invented.

## Public predicates (one line each)

- `pdpl_processing_lawful_basis(Profile, Result, Citations)`: whether Art 4 allows the processing, reading consent first and then the ten cases. Art 4 items 1 to 10, Art 6, Art 1 Consent, Art 31.
- `pdpl_consent_valid(Profile, Result, Citations)`: the six consent conditions, naming the first unmet one. Art 1 Consent, Art 6(1)(a) to (c), Art 6(2), Art 31.
- `pdpl_processing_controls(Profile, Result, Citations)`: the eight control conditions, naming the first one failed. Art 5 items 1 to 7, Art 31.
- `uae_pdpl_lawful_processing_and_consent_input_problems(Profile, Problems)`: the typed input check, scored in order. It is total and has one solution. Contract only; it cites nothing.
- `decide_uae_pdpl_lawful_processing_and_consent(Profile, Verdict)`: Verdict is `uae_pdpl_lawful_processing_and_consent_verdict(Result, Citations)`, the answer of `pdpl_processing_lawful_basis/3`. Art 4 with Art 6, Art 1 Consent, Art 31.
- `uae_pdpl_lawful_processing_and_consent_status(Profile, Status)`: Status is the lawful-basis RESULT alone. It is also the Decide closure for what-if. Art 4, Art 31.
- `uae_pdpl_lawful_processing_and_consent_checklist(Profile, Assessment)`: the eligibility verdict with a cited checklist (query types #2 and #7). It is described in full in its own subsection below. Art 1 Consent, Art 6.
- `uae_pdpl_lawful_processing_and_consent_what_if(Profile, Key, Value, Result)`: Result is the lawful-basis RESULT after Key is overridden with Value. It uses `what_if/5` with the closure `uae_pdpl_lawful_processing_and_consent_status`. It cites what the RESULT cites.
- `uae_pdpl_lawful_processing_and_consent_fixture(Name, Profile)` and `uae_pdpl_lawful_processing_and_consent_fixture_expected(Name, Query, Result)`: named fixture profiles and their expected answers.

### The checklist predicate

- **Output.** `Assessment = assessment(lawful_basis_consent, Decision, Items)`.
- **How it is built.** `assess/6` runs over the six consent requirement ids with the closure `uae_pdpl_lawful_processing_and_consent_requirement` and `labels(eligible, indeterminate, ineligible)`.
- **Items.** Each item has the form `item(RequirementId, Status, cite(Key))`.
- **Status of an item.**
  - Crisp keys use `check_true/4`, or `check_false/4` for WD.
  - Judgements use `check_tri/4`.
  - An unsure judgement gives the item status unknown.
- **Precedence.** The checklist explains the answer; it does not decide it. Where the checklist decision differs from the query RESULT, the RESULT governs. This happens because the first-failure ladders apply <<DNUM>> precedence and the checklist does not.

## Planned reuse (manifest `uses:`)

From `formalize_lib`:
- `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`
- `check_true/4`, `check_false/4`, `check_tri/4`
- `assess/6`, `eval_requirements/4`
- `attribute/2`, `item/3`, `unmet/1`, `unknown/1`, `labels/3`, `assessment/3`

From `kit/deadline_lib`:
- `month_last_day/3`, which gives the last day of a month, leap years included. It is used for the real-Gregorian date check.

From `kit/query_combinators`:
- `what_if/5`, for the what-if facade.

From `validate_props`:
- `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`, `bad_citation/1`, used in tests.

**Native datetime.** Dates are `date(Year, Month, Day)` terms in the profile, validated against the real calendar through `month_last_day/3`.
- The commencement comparison is a field-wise integer comparison, which the contract requires. No `date_add`, no day arithmetic and no string dates are used.
- `@<` on compounds is NOT used, to avoid the compound-order trap.

**Not used:** `compliance_lib`, `rolling_window`, `currency_vocab`, `vat_category`, `country`. The domain has no money, no deadline, no planning and no country vocabulary.

## Module layout

The layout is unchanged: kernel, then citations, then parameters, then the slice, then queries, then fixtures, then the package facade.

- **kernel.clausal:** the shared floor, unchanged. With a single slice, NO domain predicate has to be shared, so nothing domain-specific is added.
- **citations.clausal:** `citation_vocabulary/1` facts for all load-bearing and deferred keys above, each with its unit id, for example `ae-pdpl-fdl-45-2021-en-uaelegislation#art4_9`.
- **parameters.clausal:** declares no statutory figures, because the commencement date is owned by the slice. It keeps its scaffold export surface with the TODO removed.
- **queries.clausal:** re-exports the three queries and the input check from the slice.
- **fixtures.clausal:** named profiles. There is at least one per route of every ladder, plus these boundary cases:
  - dates 2022-01-01 and 2022-01-02;
  - 2021-12-31;
  - year 1 and year 9999;
  - 2024-02-29 valid, 2023-02-29 wrong_type;
  - year 0 and year 10000 wrong_type.
- **Facade:** decide, status, checklist, what_if, fixtures.

## Slice: uae_pdpl_lawful_processing_and_consent.clausal

### Value facts owned (declared here, nowhere else)

- **Commencement date (Art 31).**
  - `:- constant_value(pdpl_commencement_year, 2022).`
  - `:- constant_value(pdpl_commencement_month, 1).`
  - `:- constant_value(pdpl_commencement_day, 2).`
- **Date bounds (added check of this order).**
  - `:- constant_value(minimum_year, 1).`
  - `:- constant_value(maximum_year, 9999).`
- **Consent conditions.** Six table facts, in walk order, of the form `consent_condition(Position, Key, MetValue, FailingValue, FailureAtom, Citations)`:
  1. `consent_given`, met true, fails false: `consent_not_given`, `[cite(uae_pdpl_art_1_consent), cite(uae_pdpl_art_6_1)]`
  2. `consent_specific_clear_and_unambiguous`, met true, fails false: `consent_not_specific_clear_and_unambiguous`, `[cite(uae_pdpl_art_1_consent)]`
  3. `controller_able_to_prove_consent`, met true, fails false: `controller_cannot_prove_consent`, `[cite(uae_pdpl_art_6_1), cite(uae_pdpl_art_6_1_a)]`
  4. `consent_clear_simple_unambiguous_and_easily_accessible`, met true, fails false: `consent_not_clear_simple_and_easily_accessible`, `[cite(uae_pdpl_art_6_1), cite(uae_pdpl_art_6_1_b)]`
  5. `consent_includes_right_to_withdraw_easily`, met true, fails false: `consent_omits_easy_withdrawal_right`, `[cite(uae_pdpl_art_6_1), cite(uae_pdpl_art_6_1_c)]`
  6. `consent_withdrawn_before_processing`, met false, fails true: `consent_withdrawn`, `[cite(uae_pdpl_art_6_2)]`
- **Cases.** Ten table facts, in walk order, of the form `exception_case(ItemNumber, Key, CaseAtom, ItemCitation)`:
  1. E1, `public_interest`, `uae_pdpl_art_4_1`
  2. E2, `data_made_public_by_data_subject`, `uae_pdpl_art_4_2`
  3. E3, `legal_claims_and_judicial_or_security_procedures`, `uae_pdpl_art_4_3`
  4. E4, `occupational_or_preventive_medicine_and_health_or_social_care`, `uae_pdpl_art_4_4`
  5. E5, `public_health`, `uae_pdpl_art_4_5`
  6. E6, `archival_scientific_historical_or_statistical_purposes`, `uae_pdpl_art_4_6`
  7. E7, `interests_of_data_subject`, `uae_pdpl_art_4_7`
  8. E8, `employment_social_security_and_social_protection`, `uae_pdpl_art_4_8`
  9. E9, `contract_with_data_subject`, `uae_pdpl_art_4_9`
  10. E10, `obligations_under_other_laws`, `uae_pdpl_art_4_10`
- **Controls.** Eight table facts, in walk order, of the form `control_condition(Position, Key, FailureAtom, Citations)`. All are met by true and fail on false. Each cites `uae_pdpl_art_5` with its item:
  1. K1: item 1
  2. K2: item 2
  3. K3: item 2
  4. K4: item 3
  5. K5: item 4
  6. K6: item 5
  7. K7: item 6
  8. K8: item 7
- **Referral citations.** Facts of the form `referral_citation(Key, CitationKey)`:
  - CD: `uae_pdpl_art_1_consent`
  - CC: `uae_pdpl_art_6_1_b`
  - CW: `uae_pdpl_art_6_1_c`
  - E1 to E10: `uae_pdpl_art_4_1` to `uae_pdpl_art_4_10`
  - K1: `uae_pdpl_art_5_1`
  - K2 and K3: `uae_pdpl_art_5_2`
  - K4 to K8: `uae_pdpl_art_5_3` to `uae_pdpl_art_5_7`
- **Key typing.** Facts `contract_key(Position, Key, Type)` with Type one of `date`, `crisp`, `judgement`, in the 25-key order.

### Final citation sets

- **not_in_force:** `[cite(uae_pdpl_art_31)]`
- **valid:** `[art_1_consent, art_6_1, art_6_1_a, art_6_1_b, art_6_1_c, art_6_2]` (each as `cite(uae_pdpl_...)`)
- **allowed_with_consent:** `[art_4, art_1_consent, art_6_1, art_6_1_a, art_6_1_b, art_6_1_c, art_6_2]`
- **allowed_without_consent(CASE):** `[cite(uae_pdpl_art_4), cite(uae_pdpl_art_4_N)]`
- **not_allowed:** `[art_4, art_4_1 ... art_4_10]`
- **meets_listed_controls:** `[art_5, art_5_1 ... art_5_7]`
- **not_valid and fails_control:** the citations of that condition in the tables above.

### Rules / requirements (the ladders)

**Step 0: input check, common to all three queries.** `input_problems(Problems)` with Problems non-empty gives the RESULT `input_problems(Problems)` with CITATIONS `[]`. The checking rules are:
- **Profile shape.** `wrong_type(profile)` when the profile is unbound, a partial list, holds an unbound element, or holds any element that is not `attribute(_, _)`.
- **Per contract key, in order.** For each contract key: if it occurs two or more times (term identity), `duplicate_key(K)`, and no value is read. Otherwise, if it occurs once with a value outside its type (an unbound value included), `wrong_type(K)`.
- **Unknown keys.** Then `unknown_key(K)` once per distinct non-contract key, by first occurrence. Distinctness is decided by `==`, so variable keys are kept as given. Values are never checked.
- **Date type.** `integer(Y)`, Y from 1 to 9999; `integer(M)`, M from 1 to 12; `integer(D)`, D from 1 to LastDay, where `month_last_day(Y, M, LastDay)` gives LastDay.
- **Total and deterministic.** The check is built only from tests that fail rather than raise: type tests come before any arithmetic, and complementary clauses use `\+`/`==`/`\==`.

**Shared helpers inside the slice (not exported).**
- `before_commencement(date(Y, M, D))` holds in two cases:
  - Y < `#pdpl_commencement_year`;
  - Y =:= the commencement year, M =:= 1 and D =:= 1.
- `on_or_after_commencement/1` is its exact complement. Both are written as disjoint clauses.
- **Condition walk.** `condition_walk(Profile, Conditions, Outcome)` takes the conditions in order and skips those that are met. At the first condition not met:
  1. a failing value gives `failed(Atom, Citations)`;
  2. an absent key gives `missing(Key)`;
  3. an unsure value starts the look-ahead: scan the following conditions up to, but not including, the first one present with its failing value; the first absent key gives `missing(Key)`, otherwise `refer(Key)`.
  4. If every condition is met, the outcome is `all_met`.
- **Exception walk.** `exception_walk(Profile, Outcome)` runs over E1 to E10 and skips false cases:
  1. a true case gives `holds(CaseAtom, ItemCitation)`;
  2. an absent case gives `missing(Key)`;
  3. an unsure case starts the look-ahead up to, but not including, the first true case; the first absent key gives `missing(Key)`, otherwise `refer(Key)`;
  4. all ten false give `none_holds`.
- **Head folding.** Every outcome is mapped to the public RESULT by head-folded clauses, one per outcome functor.

**pdpl_consent_valid.**
1. A present date before commencement gives `not_in_force`.
2. An absent date gives `indeterminate([processing_date])`.
3. The condition walk over the six consent conditions:
   - `failed` gives `not_valid(Atom)`;
   - `missing` gives `indeterminate([Key])`;
   - `refer` gives `needs_legal_review(...)` with the referral citation.
4. `all_met` gives `valid`.

**pdpl_processing_lawful_basis.**
1. A present date before commencement gives `not_in_force`.
2. An absent date gives `indeterminate([processing_date])`.
3. All six consent conditions met gives `allowed_with_consent`.
4. Some consent key present with its failing value (`consent_fails/1`: some member fails) leads to the exception walk:
   - `holds` gives `allowed_without_consent(CaseAtom)`;
   - `missing` gives `indeterminate`;
   - `refer` gives review;
   - `none_holds` gives `not_allowed`.
5. Otherwise (no key has its failing value, and some key is absent or unsure):
   - (5a) the first absent consent key gives `indeterminate`;
   - (5b) if none is absent, scan E1 to E10, skipping false and unsure cases, up to but not including the first true case; the first absent key gives `indeterminate`;
   - (5c) otherwise, review on the first unsure consent judgement among CD, CC and CW.

The guards are mutually exclusive, so each profile has exactly one solution.

**pdpl_processing_controls.**
1. A present date before commencement gives `not_in_force`.
2. An absent date gives `indeterminate([processing_date])`.
3. The condition walk over the eight control conditions:
   - `failed` gives `fails_control(Atom)`;
   - `missing` gives `indeterminate`;
   - `refer` gives review.
4. `all_met` gives `meets_listed_controls`.

**Facade requirements.** `uae_pdpl_lawful_processing_and_consent_requirement(RequirementId, Profile, Status, Citation)` takes the RequirementId FIRST. There are three clauses per requirement: met, unmet and unknown. The six requirement ids are:
- `requirement_consent_given`
- `requirement_consent_specific_clear_and_unambiguous`
- `requirement_controller_able_to_prove_consent`
- `requirement_consent_clear_simple_unambiguous_and_easily_accessible`
- `requirement_consent_includes_right_to_withdraw_easily`
- `requirement_consent_not_withdrawn`

Each requirement's Citation is the first citation of its condition.

### Verdict atoms of this slice

All RESULT atoms and compounds listed under Verdict STATUS atoms.

### Predicates shared with another slice

None. This is the only determination slice, so `kernel.clausal` gains nothing.

### Per-rule tests (the seven test modes)

Each test is paired positive and negative, and each collects all answers with `findall` and checks `length(_, 1)`.

1. **Load.**
2. **Unit per route.** Every step of each ladder, every failure atom, all ten case atoms and all eight control atoms.
3. **Boundary.** The dates listed under fixtures, plus the Gregorian edge cases.
4. **Missing-key precedence.**
   - An earlier absent key beats a later failing value.
   - <<DNUM>> look-ahead: an absent key is named before a referral.
   - Absent keys after a failing value are not named.
5. **Input check.**
   - Duplicates with equal values and with unequal values.
   - Unbound values and unbound keys, with distinct and with shared variables.
   - A partial list.
   - A non-atom key.
   - Unknown-key order.
   - `wrong_type(profile)` alone.
6. **Properties via validate_props.** Totality, determinism, citation completeness against `citation_vocabulary`, and `bad_citation`.
7. **Cross-query consistency.** `allowed_with_consent` holds if and only if `valid` holds on the same profile. A key a query does not read never changes its answer.
