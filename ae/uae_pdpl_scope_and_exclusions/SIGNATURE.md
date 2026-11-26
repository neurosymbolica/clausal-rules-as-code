# SIGNATURE — ae/uae_pdpl_scope_and_exclusions

## Public query surface (summary)

The two contract queries are:

- `pdpl_applies(Profile, Result, Citations)`
- `pdpl_in_force(Profile, Result, Citations)`

The input check is `uae_pdpl_scope_and_exclusions_input_problems(Profile, Problems)`.

The scaffold facade wraps pdpl_applies:

- `decide_uae_pdpl_scope_and_exclusions(Profile, uae_pdpl_scope_and_exclusions_verdict(Status, Citations))`
- `uae_pdpl_scope_and_exclusions_status(Profile, Status)`
- `uae_pdpl_scope_and_exclusions_checklist(Profile, Checklist)`
- `uae_pdpl_scope_and_exclusions_what_if(Profile, Key, Value, Status)`

Totality and determinism:

- Every query yields EXACTLY ONE solution for every term.
- Ladder clauses are made disjoint by explicit guards: no `!`, no `->`.
- Constant results are folded into clause heads (C17).

The only statutory figure is the commencement day. It is owned by the slice as constants; nothing is imported from a sibling domain.

## Verdict STATUS atoms (replace scaffold `required/permitted/not_applicable`)

**Final atoms:**

- pdpl_applies: `applies`, `does_not_apply`, `not_in_force`.
- pdpl_in_force: `in_force`, `not_in_force`.

**Status compounds:**

- `indeterminate([Key])`, with exactly one key; the bare atom `indeterminate` is NEVER written.
- `needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)])`.
- `input_problems(Problems)`.

**Result constructors** (exported, never queried): `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`, `inputs_relied_on/1`, `provenance/2`.

**Eligibility labels** (query type #2): the checklist uses `labels(applies, indeterminate, does_not_apply)`. Eligible means `applies`; ineligible means `does_not_apply`.

## Profile keys (attribute list, read only with `profile_get/3`; root_exports / input_contract order)

| # | Key | Kind | Values |
|---|---|---|---|
| 1 | `processing_date` | date | `date(Year, Month, Day)`: integers, a real Gregorian day, Year from 1 to 9999, both ends |
| 2 | `activity_is_processing_of_personal_data` | judgement | `true`, `false`, `unsure` |
| 3 | `personal_data_is_government_data` | judgement | `true`, `false`, `unsure` |
| 4 | `governmental_entity_controls_or_processes` | judgement | `true`, `false`, `unsure` |
| 5 | `personal_data_held_by_security_or_judicial_authorities` | judgement | `true`, `false`, `unsure` |
| 6 | `data_subject_processing_own_data_for_personal_purposes` | judgement | `true`, `false`, `unsure` |
| 7 | `personal_health_data_with_own_protection_legislation` | judgement | `true`, `false`, `unsure` |
| 8 | `personal_banking_or_credit_data_with_own_protection_legislation` | judgement | `true`, `false`, `unsure` |
| 9 | `free_zone_company_or_establishment_with_own_data_protection_legislation` | judgement | `true`, `false`, `unsure` |
| 10 | `data_subject_resides_or_has_place_of_business_in_state` | crisp | `true`, `false` |
| 11 | `controller_or_processor_resides_in_state` | crisp | `true`, `false` |
| 12 | `data_subject_inside_state` | crisp | `true`, `false` |

There are no numeric or money keys.

## Citation-key atoms (canonical `_lexicon/citations.yaml`; never shortened)

**Load-bearing (used in results):**

- `uae_pdpl_art_1_personal_data`
- `uae_pdpl_art_1_processing`
- `uae_pdpl_art_2_1`
- `uae_pdpl_art_2_1_a`
- `uae_pdpl_art_2_1_b`
- `uae_pdpl_art_2_1_c`
- `uae_pdpl_art_2_2`
- `uae_pdpl_art_2_2_a`
- `uae_pdpl_art_2_2_b`
- `uae_pdpl_art_2_2_c`
- `uae_pdpl_art_2_2_d`
- `uae_pdpl_art_2_2_e`
- `uae_pdpl_art_2_2_f`
- `uae_pdpl_art_2_2_g`
- `uae_pdpl_art_31`

**Deferred:** the Art 1 lead-in, the other Art 1 definitions, the Art 2 heading, and Arts 3, 28, 29 and 30. They are listed in `citations.clausal` as deferred with the reason. They are never emitted in Citations.

## Public predicates

- `pdpl_applies(Profile, Result, Citations)`: the scope ladder below. One solution. Cites Art 1 Personal Data and Processing, Art 2(1)(a)(b)(c), Art 2(2)(a)-(g) and Art 31.
- `pdpl_in_force(Profile, Result, Citations)`: the commencement ladder below. One solution. Cites `uae_pdpl_art_31`.
- `uae_pdpl_scope_and_exclusions_input_problems(Profile, Problems)`: the typed input check. One solution; never fails, never raises. Its basis is the input contract, which is not statutory.
- `decide_uae_pdpl_scope_and_exclusions(Profile, Verdict)`: Verdict is `uae_pdpl_scope_and_exclusions_verdict(Status, Citations)`, where Status and Citations are exactly those of `pdpl_applies/3`. Cites Art 2(1), Art 2(2) and Art 31.
- `uae_pdpl_scope_and_exclusions_status(Profile, Status)`: projects Status from `pdpl_applies/3`. Cites Art 2.
- `uae_pdpl_scope_and_exclusions_checklist(Profile, Checklist)`: the justification (query type #7).
  - Built with `formalize_lib` `eval_requirements/4`, injecting `uae_pdpl_scope_and_exclusions_requirement/4`.
  - Each item is `item(RequirementId, Status, cite(Key))`, met items included.
  - It explains a verdict; the verdict itself always comes from the ladder.
- `uae_pdpl_scope_and_exclusions_what_if(Profile, Key, Value, Status)`: replaces or adds `attribute(Key, Value)` with `formalize_lib` `profile_set/3`, then re-decides with `uae_pdpl_scope_and_exclusions_status/2`. Citations follow pdpl_applies.
- Fixtures, exported from `fixtures.clausal`: `uae_pdpl_scope_and_exclusions_fixture(Name, Profile)` and `uae_pdpl_scope_and_exclusions_expected(Name, Query, Result, Citations)`.

## Planned reuse (manifest `uses:`)

**formalize_lib:**

- `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`;
- `check_tri/4` (for P);
- `check_tri_neg/4` (for each exclusion: a true exclusion is unmet);
- `or_status/2` (for the three Art 2(1) crisp keys);
- `eval_requirements/4`, `decide_labeled/3`, `item/3`, `labels/3`, `attribute/2`, `memberd/2`, `not_member/2`.

**kit/deadline_lib:** `month_last_day/3`, for the real-Gregorian-day check only. No day arithmetic is done.

**kit/query_combinators:** `what_if/5`, with the closure `uae_pdpl_scope_and_exclusions_status`, for the what-if facade.

**validate_props:**

- `run_props/1`, `prop_totality/3`, `prop_determinism/3`;
- `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`;
- `bad_citation/1`.

These serve the seven test modes.

**Not used:** `currency_vocab`, `vat_category`, `country`, `compliance_lib`, `rolling_window`. No money, countries or plans are involved. library(datetime) is not used because the profile date is a plain `date/3` compound and nothing is computed from it.

## Layer files

- **kernel.clausal**: the SHARED floor only.
  - It holds the result constructors.
  - It holds `uae_pdpl_scope_and_exclusions_input_problems/2`, with its helpers `contract_key_kind/2` (in contract order), `value_has_kind/2` and `real_gregorian_day/3`.
  - Both queries and the facade need the input check, so it lives here.
- **citations.clausal**: the citation facts (active and deferred).
- **parameters.clausal**: no shared figures. Its header says that the commencement day is owned by the slice.
- **queries.clausal**: re-exports `pdpl_applies/3` and `pdpl_in_force/3` from the slice.
- **fixtures.clausal**: the named cases.
- **package facade**: the four scaffold predicates.

## Slice: uae_pdpl_scope_and_exclusions.clausal

### Value facts owned

```
:- constant_value(uae_pdpl_commencement_year, 2022).
:- constant_value(uae_pdpl_commencement_month, 1).
:- constant_value(uae_pdpl_commencement_day, 2).
```

These come from Art 31, 'as of 02 January 2022', that day included.

### Shared with the kernel

The slice imports `uae_pdpl_scope_and_exclusions_input_problems/2` and the result constructors from the kernel. Nothing else is shared.

### Local helpers (no cut, disjoint clauses)

- `date_before_commencement(Profile)`: holds when the date is present and earlier than 2 January 2022. The comparison is lexicographic on the integers:
  - Year below `#uae_pdpl_commencement_year`; or
  - the same year and Month below `#uae_pdpl_commencement_month`; or
  - the same year and month and Day below `#uae_pdpl_commencement_day`.
- `date_on_or_after_commencement(Profile)`: the exact complement, for a present, well-typed date.
- `key_true(Profile, Key)`, `key_false(Profile, Key)`, `key_unsure(Profile, Key)`, `key_absent(Profile, Key)`: via `profile_get/3` and `profile_lacks/2`.
- `some_exclusion_true(Profile)`: guarded so that it yields ONE solution even when several exclusions are true. It uses a single negation-based test (`\+ none_exclusion_true`), not member backtracking.
- `no_way_true(Profile)`: none of SR, CR, SI is true.
- `all_ways_false(Profile)`: SR, CR and SI are all present and false.
- `relied_pairs(Profile, Pairs)`: KEY-VALUE for every present key, in root_exports order.

### Rules: pdpl_applies ladder

Each step after (0) holds only when every earlier step fails. This is encoded by explicit `\+` guards over the earlier conditions.

**(0) Input check.** `input_problems(Problems)` with Citations `[]`, when Problems is not `[]`.

**Day, steps (1) and (2):**

- (1) The date is before `date(2022, 1, 2)`: `not_in_force` with `[cite(uae_pdpl_art_31)]`.
- (2) The date is absent: `indeterminate([processing_date])` with `[]`.

**Settled `does_not_apply`, steps (3) to (5).** All three give `does_not_apply` with `[cite(uae_pdpl_art_2_1), cite(uae_pdpl_art_2_2)]`:

- (3) P is false.
- (4) SR, CR and SI are all false.
- (5) One or more of EA to EG is true.

**Missing keys, steps (6) to (16).** Each gives `indeterminate([Key])` with `[]`.

| Step | Condition | Key named |
|---|---|---|
| (6) | P absent | `activity_is_processing_of_personal_data` |
| (7) | EA absent | `personal_data_is_government_data` |
| (8) | EB absent | `governmental_entity_controls_or_processes` |
| (9) | EC absent | `personal_data_held_by_security_or_judicial_authorities` |
| (10) | ED absent | `data_subject_processing_own_data_for_personal_purposes` |
| (11) | EE absent | `personal_health_data_with_own_protection_legislation` |
| (12) | EF absent | `personal_banking_or_credit_data_with_own_protection_legislation` |
| (13) | EG absent | `free_zone_company_or_establishment_with_own_data_protection_legislation` |
| (14) | none of SR, CR, SI true and SR absent | `data_subject_resides_or_has_place_of_business_in_state` |
| (15) | none of SR, CR, SI true and CR absent | `controller_or_processor_resides_in_state` |
| (16) | none of SR, CR, SI true and SI absent | `data_subject_inside_state` |

**Unsure judgements, steps (17) to (24).** The first unsure judgement in root order gives `needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)])` with `[]`.

| Step | Unsure key | Citation |
|---|---|---|
| (17) | P | `uae_pdpl_art_1_personal_data` |
| (18) | EA | `uae_pdpl_art_2_2_a` |
| (19) | EB | `uae_pdpl_art_2_2_b` |
| (20) | EC | `uae_pdpl_art_2_2_c` |
| (21) | ED | `uae_pdpl_art_2_2_d` |
| (22) | EE | `uae_pdpl_art_2_2_e` |
| (23) | EF | `uae_pdpl_art_2_2_f` |
| (24) | EG | `uae_pdpl_art_2_2_g` |

Pairs holds every present key with its value, in root_exports order.

**Applies, step (25).** Otherwise the result is `applies`. Its citations are:

```
[cite(uae_pdpl_art_1_personal_data), cite(uae_pdpl_art_1_processing),
 cite(uae_pdpl_art_2_1), cite(uae_pdpl_art_2_1_a), cite(uae_pdpl_art_2_1_b),
 cite(uae_pdpl_art_2_1_c), cite(uae_pdpl_art_2_2), cite(uae_pdpl_art_31)]
```

### Rules: pdpl_in_force ladder

- (0) Input check, as for pdpl_applies.
- (1) The date is absent: `indeterminate([processing_date])` with `[]`.
- (2) The date is before `date(2022, 1, 2)`: `not_in_force` with `[cite(uae_pdpl_art_31)]`.
- (3) Otherwise: `in_force` with `[cite(uae_pdpl_art_31)]`.

pdpl_in_force reads no other key.

### Input check order (kernel, scored in order)

1. **Not an attribute list.** An unbound profile, a partial list, an unbound element, or any element that is not `attribute(Key, Value)` gives `[wrong_type(profile)]` alone.
2. **Contract keys.** For each of the twelve contract keys, in order:
   - `duplicate_key(Key)` if it occurs more than once (its values are not read);
   - else `wrong_type(Key)` if its value is outside its type, an unbound value included.
   - The date type is `date(Y, M, D)` of integers, with Year from 1 to 9999, Month from 1 to 12, and Day from 1 to `month_last_day`.
3. **Unknown keys.** Then `unknown_key(Key)` once per non-contract key, in order of first occurrence. This includes non-atoms and unbound variables, compared by `==`. Their values are never checked.

### Checklist requirements (justification, query type #7)

The requirement predicate is `uae_pdpl_scope_and_exclusions_requirement(RequirementId, Profile, Status, Citation)`. Each requirement has three disjoint clauses: met, unmet and unknown.

| Requirement | Check | Citation |
|---|---|---|
| `in_force_on_processing_day` | date | `cite(uae_pdpl_art_31)` |
| `activity_is_processing_of_personal_data` | `check_tri` | `cite(uae_pdpl_art_1_personal_data)` |
| `territorial_connection_under_article_two_one` | `or_status` over SR, CR, SI | `cite(uae_pdpl_art_2_1)` |
| `government_data_exclusion_does_not_hold` | `check_tri_neg` on EA | `cite(uae_pdpl_art_2_2_a)` |
| `governmental_entity_exclusion_does_not_hold` | `check_tri_neg` on EB | `cite(uae_pdpl_art_2_2_b)` |
| `security_or_judicial_exclusion_does_not_hold` | `check_tri_neg` on EC | `cite(uae_pdpl_art_2_2_c)` |
| `personal_purposes_exclusion_does_not_hold` | `check_tri_neg` on ED | `cite(uae_pdpl_art_2_2_d)` |
| `health_data_exclusion_does_not_hold` | `check_tri_neg` on EE | `cite(uae_pdpl_art_2_2_e)` |
| `banking_or_credit_exclusion_does_not_hold` | `check_tri_neg` on EF | `cite(uae_pdpl_art_2_2_f)` |
| `free_zone_exclusion_does_not_hold` | `check_tri_neg` on EG | `cite(uae_pdpl_art_2_2_g)` |

### Planned fixtures (one or more per ladder step)

**Date boundaries:**

- `before_commencement_first_january_2022`: gives `not_in_force`.
- `on_commencement_second_january_2022`: gives `in_force` / `applies`.
- Year 1 and year 9999 boundaries.

**Final results:**

- `not_processing_of_personal_data`.
- `no_territorial_connection`.
- One fixture per exclusion, (a) to (g), each giving `does_not_apply`.
- `foreign_controller_with_subject_inside_state`: gives `applies`.

**Statuses:**

- Each missing key named in order.
- Each unsure judgement referred, with its Pairs.
- Unsure combined with a missing key: the missing key is named first.
- Input problems, one fixture each: a duplicate key, a wrong type, `date(2021, 2, 29)`, year 0, year 10000, an unknown key, an unbound key, and a profile that is not a list.

### Test modes (seven)

1. Load.
2. Per-rule unit tests.
3. Fixtures against the expected results.
4. Solution-count (exactly one solution) for every fixture and every query.
5. Citation completeness, checked with `bad_citation/1`.
6. Boundary and missing-key coverage.
7. Input-check order and robustness, including unbound and non-list terms.
