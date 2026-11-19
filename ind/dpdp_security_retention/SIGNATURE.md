# SIGNATURE — ind/dpdp_security_retention

## Public query surface (one paragraph)

The contract surface is fixed by the order:

- The input check `dpdp_security_retention_input_problems/2`.
- Four profile queries, each `(PROFILE, RESULT, CITATIONS)`:
  - `security_safeguards_duty/3`
  - `accuracy_duty/3`
  - `erasure_duty/3`
  - `third_schedule_deemed_no_longer_served/3`
- Three date queries:
  - `third_schedule_period_end/2`
  - `erasure_notice_latest_day/2`
  - `processing_log_retention_minimum_end/2`
- The list query `fixed_lists/2`.

The scaffold facade wraps the four profile queries into one eligibility-style verdict with a cited checklist (query types #2 and #7):

- `decide_dpdp_security_retention(PROFILE, dpdp_security_retention_verdict(STATUS, CITATIONS))`
- `dpdp_security_retention_status(PROFILE, STATUS)`

PROFILE is an attribute list `[attribute(KEY, VALUE), ...]`, read only with `profile_get/3`. Every query yields exactly ONE solution for every input: there is no cut, no `->`, and each step is guarded by the negation of the earlier steps. No figure is imported. Every statutory value is declared once, with `constant_value/2`, in the slice file.

## Verdict STATUS atoms (replace the placeholders)

### Facade STATUS

The facade STATUS is one of four atoms. They form the eligibility triple, read as "is a s 8 duty engaged", plus a rejection atom.

- **`section_8_duty_owed`** (eligible). At least one checklist item is engaged.
- **`no_section_8_duty_owed`** (ineligible). All four items are clear.
- **`section_8_duty_undetermined`** (the indeterminate label). No item is engaged and at least one is missing or referred. The bare atom `indeterminate` is never used.
- **`profile_rejected`**. The input check found problems. CITATIONS is `[]`. The problems are reported by `dpdp_security_retention_checklist/2`.

### Per-query RESULT atoms (contract)

- **`security_safeguards_duty`**: `required_with_rule_6_minimum`, `required_minimum_not_prescribed`, `not_required`, `not_in_force`.
- **`accuracy_duty`**: `required`, `not_required`, `not_in_force`.
- **`erasure_duty`**: `erase`, `erase_and_cause_data_processor_to_erase`, `retain_until_minimum_retention_period_end`, `retain_as_required_by_other_law`, `not_yet_required`, `not_required`, `not_in_force`.
- **`third_schedule_deemed_no_longer_served`**: `deemed_no_longer_served`, `not_yet_deemed`, `not_listed`, `not_in_force`.
- **Status compounds**, which replace the RESULT with CITATIONS `[]`:
  - `indeterminate([KEY])`
  - `needs_legal_review(open_textured(KEY, cite(CITATION)), [inputs_relied_on(PAIRS)])`
  - `input_problems(PROBLEMS)`

## Profile keys (seventeen, in root_exports / input_contract order)

| # | key | type |
|---|-----|------|
| 1 | `section_8_3_in_force` | crisp `true`/`false` |
| 2 | `section_8_5_in_force` | crisp |
| 3 | `section_8_7_in_force` | crisp |
| 4 | `section_8_8_in_force` | crisp |
| 5 | `acts_as_data_fiduciary` | judgement `true`/`false`/`unsure` |
| 6 | `likely_used_for_decision_affecting_data_principal` | judgement |
| 7 | `likely_disclosed_to_another_data_fiduciary` | judgement |
| 8 | `retention_necessary_for_compliance_with_law` | judgement |
| 9 | `consent_withdrawn` | crisp |
| 10 | `specified_purpose_no_longer_served` | judgement |
| 11 | `assessment_date` | `date(Year, Month, Day)`, a real Gregorian day, Year >= 1 |
| 12 | `last_processing_date` | `date(Year, Month, Day)` |
| 13 | `data_made_available_to_data_processor` | crisp |
| 14 | `third_schedule_class` | `e_commerce_entity` / `online_gaming_intermediary` / `social_media_intermediary` / `no_listed_class` |
| 15 | `registered_users_in_india` | non-negative integer (a count; the unit is users) |
| 16 | `third_schedule_purpose_excepted` | crisp |
| 17 | `last_approached_date` | `date(Year, Month, Day)` |

No key is money, so there is no currency suffix. The only numeric key, `registered_users_in_india`, names its unit (users) in the key. There are no outside facts and no attested wrapper (RULINGS ruling 2 is not used).

## Citation-key atoms (canonical lexicon scheme; emitted only these)

### Act

- `in_dpdp_act_2023_s_2_i`
- `in_dpdp_act_2023_s_8_3`, `in_dpdp_act_2023_s_8_3_a`, `in_dpdp_act_2023_s_8_3_b`
- `in_dpdp_act_2023_s_8_5`
- `in_dpdp_act_2023_s_8_7`, `in_dpdp_act_2023_s_8_7_a`, `in_dpdp_act_2023_s_8_7_b`
- `in_dpdp_act_2023_s_8_8`, `in_dpdp_act_2023_s_8_8_a`, `in_dpdp_act_2023_s_8_8_b`
- `in_dpdp_act_2023_s_8_11`

### Rules

- `in_dpdp_rules_2025_r_1_4`
- `in_dpdp_rules_2025_r_6_1`, `in_dpdp_rules_2025_r_6_1_a`, `in_dpdp_rules_2025_r_6_1_b`, `in_dpdp_rules_2025_r_6_1_c`, `in_dpdp_rules_2025_r_6_1_d`, `in_dpdp_rules_2025_r_6_1_e`, `in_dpdp_rules_2025_r_6_1_f`, `in_dpdp_rules_2025_r_6_1_g`
- `in_dpdp_rules_2025_r_8_1`, `in_dpdp_rules_2025_r_8_2`, `in_dpdp_rules_2025_r_8_3`

### Schedules

- `in_dpdp_rules_2025_sch_3`
- `in_dpdp_rules_2025_sch_3_1`, `in_dpdp_rules_2025_sch_3_1_a`, `in_dpdp_rules_2025_sch_3_1_b`
- `in_dpdp_rules_2025_sch_3_2`, `in_dpdp_rules_2025_sch_3_2_a`, `in_dpdp_rules_2025_sch_3_2_b`
- `in_dpdp_rules_2025_sch_3_3`, `in_dpdp_rules_2025_sch_3_3_a`, `in_dpdp_rules_2025_sch_3_3_b`
- `in_dpdp_rules_2025_sch_7_1`, `in_dpdp_rules_2025_sch_7_2_i`, `in_dpdp_rules_2025_sch_7_2_ii`, `in_dpdp_rules_2025_sch_7_3`

### Rules for citation atoms

The other pinned units have no limb, so no atom is emitted for them. They are: s 2 lead-in, (j), (k), (t), (u), (x), (za); s 8(1), (2), (4), (6), (9), (10) and the Illustrations; rule 1(1) to (3); rule 6(2); the rule 8(3) Illustration; the Third Schedule Note; and the Seventh Schedule root.

No shortened atom is ever invented. Every CITATIONS list is set-like: each atom appears once.

## Public predicates

### Input check

`dpdp_security_retention_input_problems(Profile, Problems)`: THE INPUT CHECK. `Problems` is `[]` when the profile is well formed. Otherwise it lists, in this order:

- per contract key in input_contract order, `duplicate_key(KEY)` if the key repeats, else `wrong_type(KEY)` if its value does not have its type;
- then `unknown_key(KEY)` per non-contract key, in order of first occurrence.

A profile that is not an attribute list gives `[wrong_type(profile)]`. The check never fails and never raises. Cites: the input_contract; no legal citation.

### Profile queries

- `security_safeguards_duty(Profile, Result, Citations)`: the eight-step ladder of THE LIMBS. Cites s 8(5), s 2(i), rule 1(4), rule 6(1).
- `accuracy_duty(Profile, Result, Citations)`: the eleven-step ladder. Cites s 8(3), (3)(a), (3)(b), s 2(i).
- `erasure_duty(Profile, Result, Citations)`: the eighteen-step ladder. Cites s 8(7), (7)(a), (7)(b), s 2(i), rule 8(3).
- `third_schedule_deemed_no_longer_served(Profile, Result, Citations)`: the fifteen-step ladder. Cites s 8(8), (8)(a), (8)(b), (11), rule 1(4), rule 8(1), rule 8(2), Third Schedule items by class.

### Date queries

- `third_schedule_period_end(ApproachDate, EndDate)`: the later of `ApproachDate` and `date(2027, 5, 13)`, plus three years (YEAR RULE). Gives `input_problems([wrong_type(approach_date)])` for a non-date. Cites the Third Schedule column (4).
- `erasure_notice_latest_day(ApproachDate, LatestDay)`: the period end minus two calendar days. Gives `input_problems([wrong_type(approach_date)])` for a non-date. Cites rule 8(2).
- `processing_log_retention_minimum_end(ProcessingDate, EndDate)`: `ProcessingDate` plus one year (YEAR RULE). Gives `input_problems([wrong_type(processing_date)])` for a non-date. Cites rule 8(3).

### Fixed lists

`fixed_lists(Topic, Items)`:

- `security_safeguard_minimum` gives the seven `content_item(ATOM, cite(in_dpdp_rules_2025_r_6_1_X))`.
- `seventh_schedule_purposes` gives the four `content_item(ATOM, cite(in_dpdp_rules_2025_sch_7_N))`.

One list, one solution. Cites rule 6(1)(a) to (g) and Seventh Schedule items 1, 2(i), 2(ii), 3.

### Result constructors (exported, never called as queries)

The order names these as result constructors: `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`, `inputs_relied_on/1`, `provenance/2`, `content_item/2` and `date/3`. They are data terms: no clause defines them as goals.

- `provenance(CitationKey, SourceRecord)`: result constructor pairing a canonical citation-key atom of this order (e.g. `in_dpdp_act_2023_s_8_7_a`) with its source record from `citations.clausal` (`[label-'...', ref-'...']`, plus `verbatim-'...'` once the key is `status: verified` in citations-sources.yaml); it lets a caller trace any `cite(KEY)` in CITATIONS or a checklist item back to its pinned unit. It is never placed in a RESULT or CITATIONS position of the eight queries (this order has no BASIS output). Cites the pinned unit of `CitationKey` itself (e.g. DPDP Act 2023 s 8(7)(a) for `provenance(in_dpdp_act_2023_s_8_7_a, SourceRecord)`).
- `content_item(Atom, cite(KEY))`: one entry of a `fixed_lists/2` list. Cites rule 6(1)(a) to (g) or Seventh Schedule items 1, 2(i), 2(ii), 3.
- `date(Year, Month, Day)`: every interface date, three bare integers.

### Facade

- `decide_dpdp_security_retention(Profile, Verdict)`: `Verdict` is `dpdp_security_retention_verdict(Status, Citations)`.
  - `Status` is one of the four facade atoms.
  - `Citations` is the set-union of the citations of the four profile queries' final results (`[]` for `profile_rejected`).
  - Built with `assess/6` over the four checklist requirements.
  - Cites as its items.
- `dpdp_security_retention_status(Profile, Status)`: projects `Status` from `decide_dpdp_security_retention/2`. One solution.
- `dpdp_security_retention_checklist(Profile, Checklist)`: the cited checklist (query type #7). It is four `item(RequirementId, Status, cite(KEY))` terms, one per duty, in this order:
  1. `security_safeguards_duty_clear`, `cite(in_dpdp_act_2023_s_8_5)`
  2. `accuracy_duty_clear`, `cite(in_dpdp_act_2023_s_8_3)`
  3. `erasure_duty_clear`, `cite(in_dpdp_act_2023_s_8_7)`
  4. `third_schedule_deeming_clear`, `cite(in_dpdp_rules_2025_r_8_1)`

  Each item's `Status` is one of:
  - **`met`** when the query answers a clear result: `not_required`, `not_in_force`, `not_yet_required`, `not_yet_deemed` or `not_listed`.
  - **`unmet(engaged(Result))`** when it answers an engaged result: any required, erase or retain answer, or `deemed_no_longer_served`.
  - **`unknown([KEY])`** for `indeterminate([KEY])`, or for a referral, where KEY is the referred judgement.

  When the profile is rejected, the checklist is `[item(input_check, unmet(input_problems(Problems)), cite(input_contract))]`. This is the only item not tied to a statute; it marks the rejection.
- `dpdp_security_retention_what_if(Profile, Key, Value, Verdict)`: replaces (or adds) `attribute(Key, Value)` with `profile_set/3`, then calls `decide_dpdp_security_retention/2` on the result. One solution.
- **Fixtures** (`fixtures.clausal`):
  - `dpdp_security_retention_fixture(FixtureName, Profile)`
  - `dpdp_security_retention_fixture_expected(FixtureName, QueryName, Result, Citations)`
  - Named cases are listed per slice below.

### Facade polarity

The checklist items are phrased as "duty clear". `decide_labeled/3` therefore gives the right disjunctive semantics:

- any `unmet` (some duty engaged) gives the negative label;
- else any `unknown` gives the undetermined label;
- else the positive label.

The labels are `labels(no_section_8_duty_owed, section_8_duty_undetermined, section_8_duty_owed)`, passed to `assess(Subject, [security_safeguards_duty_clear, accuracy_duty_clear, erasure_duty_clear, third_schedule_deeming_clear], Profile, dpdp_security_retention_requirement, Labels, Result)`.

The requirement head is `dpdp_security_retention_requirement(RequirementId, Profile, Status, Citation)`, with RequirementId first. Each requirement has exactly three disjoint clauses (met, unmet, unknown), each delegating to one slice query.

## Planned reuse (manifest `uses:`)

### formalize_lib

| Predicate | Use |
|---|---|
| `profile_get/3` | the only profile reader |
| `profile_has/2`, `profile_lacks/2` | presence guards |
| `profile_set/3` | the what-if override |
| `profile_keys/2` | the input check's key scan |
| `assess/6`, `decide_labeled/3` | the facade |
| `item/3`, `unmet/1`, `unknown/1`, `labels/3`, `assessment/3`, `attribute/2` | constructors |
| `not_member/2`, `memberd/2` | duplicate and unknown key detection, the citation set |
| `first_applicable/2` | not used (the ladders use guarded clauses) |

`check_tri/4` is NOT used. The tri-state judgements feed step ladders with referral payloads, not checklist statuses. This is recorded to pre-empt lint C15: no clone of `check_tri` is written either.

### library(datetime)

- `date_sub/3`, `timedelta/3`, `ordinal/2`.
- Native date objects are built with `date/4` (`date(Year, Month, Day, Object)`) until `date/3` lands. Interface terms stay `date(Year, Month, Day)` of bare integers.
- `date_string_iso/2` is not needed: there is no JSON boundary in the engine.

### kit.deadline_lib

`month_last_day/3` is used for real-day validation and the 29 February clamp. `deadline_months_after/3` is explicitly NOT used, because its semantics differ from the YEAR RULE.

### validate_props

Used in tests:

- `run_props/1`
- `prop_totality/3` and `prop_determinism/3` over the fixture profiles and every query (the exactly-one-solution rule)
- `prop_citation_complete/3` (every final RESULT has non-empty CITATIONS from the lexicon)
- `prop_boundary_coverage/2`
- `prop_missing_key_coverage/3`

### Not used

`kit.compliance_lib`, `kit.rolling_window` and the query_combinators what-if family are not used. `what_if/5` overrides a dict world, and this profile is an attribute list, so `profile_set/3` is used instead.

## kernel.clausal — the shared floor (predicates only, no statutory values)

- `real_gregorian_date(DateTerm)`: `date(Year, Month, Day)` ground, all integers, Year >= 1, Month 1..12, Day 1..LastDay via `month_last_day/3`. Fails otherwise; never raises. Guard with `integer/1` before arithmetic.
- `calendar_day_ordinal(DateTerm, Ordinal)`: lifts the term with `date/4`, then `ordinal/2`.
- `day_before(EarlierTerm, LaterTerm)`, `day_on_or_before(EarlierTerm, LaterTerm)`: ordinal comparisons.
- `later_day(FirstTerm, SecondTerm, LaterTerm)`: two disjoint clauses on ordinal order.
- `add_years_year_rule(DateTerm, Years, ResultTerm)`: the YEAR RULE. Two disjoint clauses:
  - the target day exists: keep the month and day;
  - the date is 29 February and the target year is not leap: 28 February.
- `subtract_days(DateTerm, Days, ResultTerm)`: `date/4`, then `timedelta(Days, 0, Delta)`, then `date_sub/3`, then back to a `date(Year, Month, Day)` term.
- `judgement_value/1`, `crisp_value/1`: the type facts for `true`/`false`/`unsure` and `true`/`false`.
- `judgement_pairs(Profile, PairsListKeys, Pairs)`: THE PAIRS RULE. `Key-Value` pairs of the listed judgement keys present in the profile, in root_exports order.

These are the only predicates shared across files. The citations, parameters, queries, fixtures and facade files read them. The slice owns every value.

## Slice: dpdp_security_retention.clausal

### Value facts it owns (`:- constant_value(Name, Value).`)

| Constant | Value | Source |
|---|---|---|
| `rules_six_and_eight_commencement_date` | `date(2027, 5, 13)` | rule 1(4), calculated, Q4 |
| `third_schedule_period_years` | 3 | Third Schedule column (4) |
| `minimum_retention_period_years` | 1 | rule 8(3), rule 6(1)(e) |
| `erasure_notice_lead_days` | 2 | rule 8(2): forty-eight hours, counted exactly as two whole days back from the end of PERIOD END |
| `e_commerce_entity_registered_user_threshold` | 20000000 | Third Schedule item 1, two crore |
| `online_gaming_intermediary_registered_user_threshold` | 5000000 | item 2, fifty lakh |
| `social_media_intermediary_registered_user_threshold` | 20000000 | item 3, two crore |
| `lowest_registered_user_threshold` | 5000000 | the minimum over the items |

Tables:

- `class_threshold(Class, ConstantName)`: the three classes.
- `class_item_citations(Class, NotYetDeemedCitations, DeemedCitations)`: the step 12/15 and step 14 lists of THE LIMBS.

Derived:

- `deeming_floor_date`: `rules_six_and_eight_commencement_date` plus `third_schedule_period_years` (= `date(2030, 5, 13)`), computed with `add_years_year_rule/3`, not declared.

### Rules and requirements it implements

1. **Input check.** `dpdp_security_retention_input_problems/2`, with the typed `contract_key(Key, Type)` facts in the seventeen-key order. The types are `judgement`, `crisp`, `date`, `third_schedule_class`, `non_negative_integer`. It includes the attribute-list well-formedness test (proper list, every element `attribute(_, _)`, unbound element or partial list gives `[wrong_type(profile)]`), duplicate detection, and non-atom keys as `unknown_key`.
2. **`security_safeguards_duty/3`.** Steps 0 to 8. The PAIRS list is `[acts_as_data_fiduciary]`.
3. **`accuracy_duty/3`.** Steps 0 to 11. The PAIRS list is `[acts_as_data_fiduciary, likely_used_for_decision_affecting_data_principal, likely_disclosed_to_another_data_fiduciary]`. The not_required citations are the same four at steps 3 and 4.
4. **`erasure_duty/3`.** Steps 0 to 18. Local helpers:
   - `trigger_open/1`: `consent_withdrawn` is `true`, or `specified_purpose_no_longer_served` is not `false`.
   - `in_window/1`: both dates present; `assessment_date` on or after the commencement date; `assessment_date` on or before `last_processing_date` plus one year.
   - `hold_ruled_out_early/1`: `last_processing_date` present, and its year ended before the commencement date.
   - The PAIRS list is `[acts_as_data_fiduciary, retention_necessary_for_compliance_with_law, specified_purpose_no_longer_served]`.
5. **`third_schedule_deemed_no_longer_served/3`.** Steps 0 to 15.
   - Uses `period_end/2` (later of the approach date and the commencement date, plus three years).
   - There is no judgement key and no referral.
   - The not_listed citations are `[cite(in_dpdp_rules_2025_r_8_1), cite(in_dpdp_rules_2025_sch_3)]`.
   - The not_in_force citations are `[cite(in_dpdp_act_2023_s_8_8), cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_rules_2025_r_8_1)]`.
6. **Date queries.** `third_schedule_period_end/2`, `erasure_notice_latest_day/2`, `processing_log_retention_minimum_end/2`. Each has two disjoint clauses: `\+ real_gregorian_date` gives the input problem; otherwise the arithmetic.
7. **`fixed_lists/2`.** Two fact-like clauses with the exact `content_item` atoms of the contract, in the given order.
8. **Facade requirement.** `dpdp_security_retention_requirement/4`, the four requirements mapping each query's RESULT to `met`, `unmet(engaged(Result))` or `unknown([Key])`. It is defined here, next to the slice it projects. The facade file imports it.

### Verdict atoms

As listed under the per-query RESULT atoms above, plus the four facade atoms (decided in the facade from this slice's requirement).

### Shared predicates

Only the kernel predicates listed above. Nothing from this slice is needed elsewhere except the public queries and the requirement, which are re-exported through queries.clausal and the facade.

### Per-rule tests and fixtures (boundary set the tests must cover)

Commencement:

- `assessment_date` `date(2027, 5, 12)` versus `date(2027, 5, 13)`: `required_minimum_not_prescribed` versus `required_with_rule_6_minimum`; deeming `not_in_force` versus ladder.

Deeming floor:

- `assessment_date` `date(2030, 5, 13)` gives `not_yet_deemed` without `last_approached_date`.
- `date(2030, 5, 14)` with a last approach of `date(2026, 1, 1)` gives `deemed_no_longer_served`.

User thresholds:

- 4999999 gives `not_listed` with no class named.
- 5000000 is listed for online gaming.
- 19999999 gives `not_listed` for e-commerce and social media.
- 20000000 is listed.

YEAR RULE and date queries:

| Query | Input | Output |
|---|---|---|
| `third_schedule_period_end` | `date(2028, 2, 29)` | `date(2031, 2, 28)` |
| `erasure_notice_latest_day` | `date(2028, 2, 29)` | `date(2031, 2, 26)` |
| `erasure_notice_latest_day` | `date(2028, 3, 1)` | `date(2031, 2, 27)` (month borrow) |
| `third_schedule_period_end` | `date(2020, 1, 1)` | `date(2030, 5, 13)` |
| `processing_log_retention_minimum_end` | `date(2028, 2, 29)` | `date(2029, 2, 28)` |
| `processing_log_retention_minimum_end` | `date(2026, 5, 12)` | `date(2027, 5, 12)` |

The last row means the hold is ruled out early, so step 10 does not name `assessment_date`.

Erasure:

- In window gives `retain_until_minimum_retention_period_end`.
- The day after the retention end, with a processor, gives `erase_and_cause_data_processor_to_erase`.
- Other law `true` with no trigger gives `retain_as_required_by_other_law`.

Referrals:

- `acts_as_data_fiduciary` `unsure` with `assessment_date` absent gives `indeterminate([assessment_date])` before the referral.
- With all keys present it gives `needs_legal_review(open_textured(acts_as_data_fiduciary, cite(in_dpdp_act_2023_s_2_i)), [inputs_relied_on([acts_as_data_fiduciary-unsure])])`.

Input check:

- Duplicate key with equal values gives only `duplicate_key`.
- An unbound value gives `wrong_type`.
- A string key gives `unknown_key`.
- A partial list gives `[wrong_type(profile)]`.
- `registered_users_in_india` given as 5.0e6 gives `wrong_type`.
- `date(2027, 2, 29)` gives `wrong_type`.

Negative tests (`fail`) are always paired with a positive test over the same case. Answer counts are checked with `findall` plus `length(Answers, 1)`.

### Named fixtures

- `marketplace_after_sale`: Illustration (I) style. Purpose served, rule 8 in force, outside the window: `erase`.
- `bank_account_closed`: Illustration (II). Other law `true`: `retain_as_required_by_other_law`.
- `ebook_platform_within_year`: rule 8(3) Illustration Case 1: `retain_until_minimum_retention_period_end`.
- `cloud_processor_after_year`: Case 2 after the year: `erase_and_cause_data_processor_to_erase`.
- `processor_not_fiduciary`: `acts_as_data_fiduciary` `false`: every duty `not_required` or clear, so `no_section_8_duty_owed`.
- `social_media_dormant_user_2031`: `deemed_no_longer_served` (item 3 citations).
- `gaming_below_threshold`: 4999999 users: `not_listed`.
- `before_rules_commence`: `assessment_date` `date(2027, 1, 1)`: `required_minimum_not_prescribed`, deeming `not_in_force`.
- `empty_profile`: `section_8_duty_undetermined`.
- `malformed_profile`: `profile_rejected`.
