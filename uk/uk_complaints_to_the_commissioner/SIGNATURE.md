# SIGNATURE — uk/uk_complaints_to_the_commissioner

This is the authoring plan the later phases execute.

Layout: `kernel -> citations -> parameters -> uk_complaints_to_the_commissioner -> queries -> fixtures -> package facade`. The predicate prefix is `uk_complaints_to_the_commissioner_`. No file or module is renamed.

The package has one determination slice, `uk_complaints_to_the_commissioner.clausal`, which owns all value facts, rules, tests, checklist and verdicts.

## 1. Verdict STATUS atoms

These replace the placeholders `required`, `permitted` and `not_applicable`.

### Final results

| Query | Result | Citations |
|---|---|---|
| `controller_complaint_right/3` | `complaint_under_section_164a` | `[cite(uk_dpa_2018_s_164a_1)]` |
| `controller_complaint_right/3` | `not_a_complaint_under_section_164a` | `[cite(uk_dpa_2018_s_164a_1)]` |
| `commission_complaint_right/3` | `complaint_under_section_165_2` | `[cite(uk_dpa_2018_s_165_2)]` |
| `commission_complaint_right/3` | `not_a_complaint_under_section_165_2` | `[cite(uk_dpa_2018_s_165_2)]` |
| `acknowledgement_last_day/3` | `date(Y, M, D)` (the last day) | `[cite(uk_dpa_2018_s_164a_3), cite(uk_si_2026_82_reg_3), cite(uk_si_2026_82_reg_3_a), cite(uk_si_2026_82_reg_7)]` |
| `acknowledgement_last_day/3` | `acknowledgement_duty_does_not_apply` | `[cite(uk_si_2026_82_reg_3), cite(uk_si_2026_82_reg_3_a), cite(uk_si_2026_82_reg_7)]` |

### Not-final status compounds

A not-final answer always has `CITATIONS = []`.

- `indeterminate([Key])` lists exactly one bare key atom, the first missing key. The bare atom `indeterminate` is NEVER written.
- `input_problems(Problems)` holds the flat list of problem terms.

### Problem constructors

`unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

### Checklist item statuses

These come from `formalize_lib`: `met`, `unmet(Reason)`, `unknown([Key])`.

### No other answers

There is no `needs_legal_review` and no referral. The order is closed_world and stateless.

## 2. Profile keys

The profile is an attribute list `[attribute(Key, Value), ...]` read only with `profile_get/3`. Keys are listed in `root_exports` / `input_contract` order.

1. `complaint_by_data_subject_about_own_personal_data`: crisp, `true` or `false` (s.164A(1), s.165(2)).
2. `infringement_considered`: an enumeration, one of `uk_gdpr`, `dpa_2018_part_3`, `dpa_2018_part_4`, `none_of_the_three` (s.164A(1), s.165(2)).
3. `complaint_made_to_the_controller`: crisp, `true` or `false` (s.164A(1)).

There are no numeric keys and no profile dates. The only date is the positional argument `receipt_date` of `acknowledgement_last_day/3`, written as the ground term `date(Year, Month, Day)` of bare integers. An input date must have Year from 1900 to 2199; this is an ADDED check.

## 3. Citation-key atoms

These come from the canonical lexicon (`_lexicon/citations.yaml`). No shortened atom is ever invented.

- `uk_dpa_2018_s_164a_1`: DPA 2018 s.164A(1)
- `uk_dpa_2018_s_164a_3`: DPA 2018 s.164A(3)
- `uk_dpa_2018_s_165_2`: DPA 2018 s.165(2) as amended
- `uk_si_2026_82_reg_3`: S.I. 2026/82 reg 3
- `uk_si_2026_82_reg_3_a`: S.I. 2026/82 reg 3(a)
- `uk_si_2026_82_reg_7`: S.I. 2026/82 reg 7

## 4. Public predicates

Every query yields EXACTLY ONE solution. The scorer counts duplicates as refutations.

### Contract queries

- `controller_complaint_right(Profile, Result, Citations)`: eligibility (#2) under s.164A(1). It returns the s.164A atoms, `indeterminate([Key])` or `input_problems(Problems)` + `cite(uk_dpa_2018_s_164a_1)`.
- `commission_complaint_right(Profile, Result, Citations)`: eligibility (#2) under s.165(2) as amended. It returns the s.165(2) atoms, `indeterminate([Key])` or `input_problems(Problems)` + `cite(uk_dpa_2018_s_165_2)`.
- `acknowledgement_last_day(ReceiptDate, LastDay, Citations)`: deadline (#15). It returns `date(Y, M, D)`, `acknowledgement_duty_does_not_apply` or `input_problems([wrong_type(receipt_date)])` + `cite(uk_dpa_2018_s_164a_3)`, `cite(uk_si_2026_82_reg_3)`, `cite(uk_si_2026_82_reg_3_a)`, `cite(uk_si_2026_82_reg_7)`. If the controller has not acknowledged by LastDay, it is in breach of s.164A(3); no sanction is modelled.
- `uk_complaints_to_the_commissioner_input_problems(Profile, Problems)`: the input check, returning the BARE flat list of problems + the typed input_contract. It never fails and never raises.

### Facade predicates (scaffold names kept)

- `decide_uk_complaints_to_the_commissioner(Profile, uk_complaints_to_the_commissioner_verdict(Status, Citations))`: the package verdict. It equals `controller_complaint_right/3`, the primary question of this order + `cite(uk_dpa_2018_s_164a_1)`.
- `uk_complaints_to_the_commissioner_status(Profile, Status)`: Status is the RESULT of `controller_complaint_right/3` + `cite(uk_dpa_2018_s_164a_1)`.
- `uk_complaints_to_the_commissioner_checklist(Profile, Checklist)`: justification (#7), built with `eval_requirements/4` over `uk_complaints_to_the_commissioner_requirement/4` + `cite(uk_dpa_2018_s_164a_1)`. Each item is `item(RequirementId, Status, cite(uk_dpa_2018_s_164a_1))`. The three requirement ids are:
  - `complainant_is_data_subject_about_own_personal_data`
  - `infringement_named_in_section_164a_1`
  - `complaint_made_to_the_controller_of_the_data`

  A malformed profile gives `[]`.
- `uk_complaints_to_the_commissioner_what_if(Profile, Key, Value, Status)`: the verdict status after `profile_set/3` replaces Key with Value. It re-runs the input check, so a bad override yields `input_problems(...)` + `cite(uk_dpa_2018_s_164a_1)`.
- `uk_complaints_to_the_commissioner_fixture(FixtureName, Profile)`: named fixture profiles, the scaffold fixtures, listed in section 6.

## 5. Planned reuse (manifest `uses:`)

- **`formalize_lib`**:
  - profile access: `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`;
  - checklist: `eval_requirements/4`, `item/3`, `unmet/1`, `unknown/1`, `attribute/2`;
  - vocabulary: `met`.
- **`kit/deadline_lib`**:
  - `next_day/2` steps one calendar day with Gregorian month and year carry;
  - `month_last_day/3` validates the input date (day 1 to the last day of the month) and handles leap years.
- **`kit/query_combinators`**: not used. `what_if/5` overrides a dict, while the profile is an attribute list, so `profile_set/3` is used instead.
- **`validate_props`** (tests only):
  - `run_props/1`;
  - `prop_totality/3` and `prop_determinism/3`, enumerating all completions;
  - `prop_citation_complete/3`;
  - `prop_boundary_coverage/2` for 2026-06-18 / 2026-06-19 and the month, year and leap carries;
  - `prop_missing_key_coverage/3`.

### Deliberately not used

- `library(datetime)` `date_add/3`: only `date/4` objects exist today, and the contract term is `date/3`.
- `deadline_lib` `deadline/4`: its period convention (whether the trigger day counts as day 1) is unverified. If phase P2 shows that `deadline(_, 29, date(2026,6,19), date(2026,7,18))` holds, it may replace the `next_day/2` walk with the same tests.
- `assess/6`: its Indet label would be a bare atom, while the contract needs `indeterminate([Key])`.
- `compliance_lib`: there is no modality conflict to resolve.

### Kernel

`kernel.clausal` gains nothing. With a single slice, no predicate is shared.

## 6. Fixtures

| Fixture | Expected answers |
|---|---|
| `gdpr_complaint_to_controller` (true, `uk_gdpr`, true) | `complaint_under_section_164a`; `complaint_under_section_165_2` |
| `part_3_complaint_to_controller` (true, `dpa_2018_part_3`, true) | `complaint_under_section_164a`; `complaint_under_section_165_2` |
| `part_4_complaint_to_controller` (true, `dpa_2018_part_4`, true) | `not_a_complaint_under_section_164a`; `complaint_under_section_165_2` |
| `complaint_to_processor` (true, `uk_gdpr`, false) | `not_a_complaint_under_section_164a`; `complaint_under_section_165_2` |
| `third_party_complaint` (false, `uk_gdpr`, true) | not a complaint under either section |
| `no_infringement_considered` (true, `none_of_the_three`, true) | not a complaint under either section |
| `recipient_not_stated` (true, `uk_gdpr`) | `indeterminate([complaint_made_to_the_controller])`; `complaint_under_section_165_2` |
| `empty_profile` (`[]`) | `indeterminate([complaint_by_data_subject_about_own_personal_data])` for both queries |
| `badly_typed_profile` (`[attribute(infringement_considered, gdpr), attribute(colour, red)]`) | `input_problems([wrong_type(infringement_considered), unknown_key(colour)])` |

## 7. Slice: `uk_complaints_to_the_commissioner.clausal`

This section is self-contained. A later phase authors the slice from it alone.

### 7.1 Statutory VALUE facts

These live in this file only and are read with `constant(Name)`.

- `:- constant_value(acknowledgement_period_days, 30).` (s.164A(3))
- `:- constant_value(acknowledgement_receipt_day_counts_as_day_one, 1).` The days added are the period days minus this value, so 29 (reading (5), Q1).
- `:- constant_value(duty_commencement_year, 2026).`, `:- constant_value(duty_commencement_month, 6).`, `:- constant_value(duty_commencement_day, 19).` (S.I. 2026/82 reg 3(a), reg 7)
- `:- constant_value(earliest_input_year, 1900).`, `:- constant_value(latest_input_year, 2199).` (the ADDED range check)
- Contract tables as facts:
  - `contract_key/1` in order: `complaint_by_data_subject_about_own_personal_data`, `infringement_considered`, `complaint_made_to_the_controller`;
  - `key_type(Key, crisp)` / `key_type(Key, enumeration)`;
  - `crisp_value(true)`, `crisp_value(false)`;
  - `infringement_value(uk_gdpr)`, `infringement_value(dpa_2018_part_3)`, `infringement_value(dpa_2018_part_4)`, `infringement_value(none_of_the_three)`;
  - `section_164a_infringement(uk_gdpr)`, `section_164a_infringement(dpa_2018_part_3)`;
  - `section_165_2_infringement/1`: `uk_gdpr`, `dpa_2018_part_3`, `dpa_2018_part_4`.

### 7.2 Rules / requirements

Only `profile_get/3`, `profile_has/2` and `profile_lacks/2` are used. The verdict atoms are folded into clause heads (C17), with no `!`, `->` or `*->`. Routes are pairwise disjoint so that each query has exactly one solution.

**Step 0, every profile query.** `uk_complaints_to_the_commissioner_input_problems(Profile, Problems)`. A non-empty Problems gives `input_problems(Problems)` with `[]`. Problems = `[]` (tested with `==`) is a guard on every other clause.

**`controller_complaint_right`, step 1** gives `not_a_complaint_under_section_164a`. It has three disjoint clauses:

- (a) subject is `false`;
- (b) subject is not `false` (true or absent) AND infringement is `dpa_2018_part_4` or `none_of_the_three`;
- (c) subject is not `false` AND infringement is not one of those two (a s.164A value, or absent) AND controller is `false`.

**`controller_complaint_right`, step 2** gives `indeterminate([Key])`, applying only where no step 1 clause holds. It has three disjoint clauses: the first absent key, in key order, among subject, infringement and controller.

**`controller_complaint_right`, step 3** gives `complaint_under_section_164a` when subject is `true`, infringement is a s.164A value and controller is `true`.

**`commission_complaint_right`, step 1** gives `not_a_complaint_under_section_165_2`. It has two disjoint clauses:

- (a) subject is `false`;
- (b) subject is not `false` AND infringement is `none_of_the_three`.

The query never reads `complaint_made_to_the_controller`.

**`commission_complaint_right`, step 2** gives `indeterminate([complaint_by_data_subject_about_own_personal_data])` when subject is absent and infringement is not `none_of_the_three`. It gives `indeterminate([infringement_considered])` when subject is `true` and infringement is absent.

**`commission_complaint_right`, step 3** gives `complaint_under_section_165_2` when subject is `true` and infringement is a s.165(2) value.

**`acknowledgement_last_day`.** This query takes no profile.

- (1) `\+ valid_input_date(R)` gives `input_problems([wrong_type(receipt_date)])` with `[]`.
- (2) The date is valid and `day_key(R) < commencement key 20260619` (computed from the constants); this gives `acknowledgement_duty_does_not_apply` with the three regulation citations.
- (3) The date is valid and `day_key(R) >= commencement key`. `add_calendar_days(R, 29, LastDay)` walks `next_day/2` with a 0 clause and a `N > 0` clause, which are disjoint. This gives `date(Y, M, D)` with the four citations.

**`valid_input_date/1`.** It requires all of:

- `nonvar(R)`, `R = date(Y, M, D)`;
- `integer(Y)`, `integer(M)`, `integer(D)`;
- year within 1900 to 2199;
- month from 1 to 12;
- `month_last_day(Y, M, Last)` and `1 =< D =< Last`.

It never binds or raises on an unbound argument.

**Input check.** Problems are assembled in this order.

1. If the profile is not a proper list, or any element is unbound or not `attribute(_, _)`, the result is `[wrong_type(profile)]`. `is_list/1` rejects unbound and partial lists.
2. Otherwise, for each contract key in order:
   - count its occurrences by `==` on the key, never by unification;
   - two or more occurrences give `duplicate_key(Key)`, and the value is not read;
   - exactly one occurrence whose value is unbound or outside its type gives `wrong_type(Key)`.
3. Then `unknown_key(Key)` for each key that is not an atom contract key, in first-occurrence order and deduplicated by `==`. This covers numbers, strings, compounds and unbound variables, each as given.

The check uses local `==`-based helpers, since `memberd` / `not_member` unify.

**Checklist requirements.** `uk_complaints_to_the_commissioner_requirement(RequirementId, Profile, Status, Citation)` has three exclusive clauses per requirement: met / unmet(Reason) / unknown([Key]). The citation is always `cite(uk_dpa_2018_s_164a_1)`.

- `complainant_is_data_subject_about_own_personal_data`: `true` gives `met`; `false` gives `unmet(not_a_data_subject_about_own_personal_data)`.
- `infringement_named_in_section_164a_1`: a s.164A value gives `met`; `dpa_2018_part_4` or `none_of_the_three` gives `unmet(infringement_not_named_in_section_164a_1)`.
- `complaint_made_to_the_controller_of_the_data`: `true` gives `met`; `false` gives `unmet(complaint_not_made_to_the_controller)`.

### 7.3 Verdict atoms owned

- `complaint_under_section_164a`
- `not_a_complaint_under_section_164a`
- `complaint_under_section_165_2`
- `not_a_complaint_under_section_165_2`
- `acknowledgement_duty_does_not_apply`
- `date(Y, M, D)` last days
- `indeterminate/1`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`

### 7.4 Per-rule tests

The seven test modes are listed below. Each negative test is paired with a positive one over the same case.

1. **Unit.** Every fixture gets its expected answer in both profile queries.
2. **Counting.** For every completion of the three keys (each value or absent, 3 x 5 x 3 = 45 profiles), `findall` gives length 1 for each query.
3. **Status rule.** The settled and first-missing-key answers agree with the completion semantics.
4. **Irrelevance.** `complaint_made_to_the_controller`, present or absent, never changes `commission_complaint_right/3`.
5. **Deadline boundary.**
   - Commencement edge: 2026-06-18 gives `acknowledgement_duty_does_not_apply`; 2026-06-19 gives 2026-07-18.
   - Carries: 2026-12-15 gives 2027-01-13; 2028-02-10 gives 2028-03-10; 2027-02-10 gives 2027-03-11.
   - Century rule: 2100-02-10 gives 2100-03-11, and 2000 is not tested (outside the duty range is irrelevant).
   - Bad dates: `date(2027,2,29)`, `date(2026,13,1)`, `date(1899,12,31)`, `date(2200,1,1)`, an unbound date and `date(2026,6,a)` each give `input_problems([wrong_type(receipt_date)])`, once.
6. **Input check.** Duplicates (equal and unequal values), unknown keys repeated, a non-atom key, an unbound key and an unbound value are each tested. Non-list, partial-list and unbound-element profiles give `[wrong_type(profile)]`. Each case yields exactly one solution.
7. **Citation completeness.** Every final answer carries exactly its fixed citation list, and every not-final answer carries `[]`.

### 7.5 Shared with other slices

None. This is the only slice, so nothing goes into `kernel.clausal`.

## 8. Totality and determinism claims

For every term passed as Profile, `controller_complaint_right/3` and `commission_complaint_right/3` yield exactly one (Result, Citations), and so does the input check. For every term passed as ReceiptDate, `acknowledgement_last_day/3` yields exactly one (LastDay, Citations).

No query raises. No query reads today's date. All arithmetic uses exact integers, with no floats.
