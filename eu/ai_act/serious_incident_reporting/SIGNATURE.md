# SIGNATURE — eu/ai_act/serious_incident_reporting

## Public query surface (summary)

There are two contract queries. They are the answer of record.

- `serious_incident_report_duty(Profile, AwarenessDate, Duty, Citations)`
- `serious_incident_report_timeliness(Profile, AwarenessDate, ReportDate, Verdict, Citations)`

The input check is `serious_incident_reporting_input_problems(Profile, Problems)`.

The scaffold facade is kept: `decide_serious_incident_reporting/2`, `serious_incident_reporting_status/2`, `serious_incident_reporting_checklist/2`, `serious_incident_reporting_what_if/4` and the fixtures. It wraps the duty query over a case term `serious_incident_case(Profile, AwarenessDate)`.

**Totality and determinism.** Every query yields EXACTLY ONE solution for every input term, the input check included. To achieve this:

- route clauses are mutually exclusive, with no cut, `->` or `*->`;
- ground verdicts are folded into clause heads (C17);
- the input check never raises.

**Statutory figures.** These are the day periods 2, 10 and 15, and the dates 2027-12-02, 2028-08-02 and 2030-08-02. They are declared ONCE with `constant_value/2` in serious_incident_reporting.clausal and are not imported. There is no imported figure.

## Verdict STATUS atoms (replace the placeholders satisfied / not_satisfied)

### DUTY terms (argument 3 of serious_incident_report_duty/4)

These are also the STATUS of the facade.

- `report_due(Recipient, Days, LastDay, FollowUp)`, where:
  - Recipient is one of the two recipient atoms;
  - Days is in {2, 10, 15};
  - LastDay is `date(Y, M, D)`;
  - FollowUp is `[perform_necessary_investigations_without_delay, risk_assessment_of_the_incident, corrective_action, cooperate_with_competent_authorities, inform_authorities_before_altering_the_system]`, exactly, in this order.
- `not_applicable_on_date`
- `not_a_high_risk_ai_system`
- `not_covered_placed_before_application_date`
- `not_a_serious_incident`
- `not_a_reportable_incident`

### VERDICT atoms (argument 4 of serious_incident_report_timeliness/5)

- `report_in_time`
- `report_after_time_limit`
- `report_not_immediate`
- each of the five no-duty atoms above

### Not-final statuses (CITATIONS always [])

- `indeterminate([Key])`: exactly one bare key atom. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(JudgementKey, cite(CitationKey)), [inputs_relied_on(Pairs)])`. An unscored trailing `provenance(Clause, Citations)` is optional.
- `input_problems(Problems)`

### Recipient atoms

- `market_surveillance_authority_of_member_state_where_incident_occurred`
- `national_competent_authority_chosen_by_member_state_where_incident_occurred`

### Problem terms

- `unknown_key(Key)`
- `wrong_type(Key)`, with Key also one of `profile`, `awareness_date` or `report_date`
- `duplicate_key(Key)`

### Result constructors

These are exported and never queried: `report_due/4`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

## Profile keys (root_exports order = input_contract order)

PROFILE is `[attribute(Key, Value), ...]`, read ONLY with `formalize_lib:profile_get/3`: first by presence, then by value.

| # | Key | Type | Values |
|---|---|---|---|
| 1 | `high_risk_classification` | enumeration | `annex_iii_high_risk`, `annex_i_high_risk`, `not_high_risk` |
| 2 | `placed_before_chapter_iii_application_date` | crisp | `true`, `false` |
| 3 | `significant_change_in_design_since_that_date` | judgement | `true`, `false`, `unsure` |
| 4 | `intended_to_be_used_by_public_authorities` | crisp | `true`, `false` |
| 5 | `medical_device_or_safety_component_of_one` | crisp | `true`, `false` |
| 6 | `provider_subject_to_equivalent_union_reporting_obligations` | judgement | `true`, `false`, `unsure` |
| 7 | `harm_to_health` | enumeration | `death_of_a_person`, `serious_harm_to_health_without_death`, `no_death_or_serious_harm_to_health` |
| 8 | `critical_infrastructure_disruption` | crisp | `true`, `false` |
| 9 | `fundamental_rights_obligations_infringed` | crisp | `true`, `false` |
| 10 | `serious_harm_to_property_or_environment` | crisp | `true`, `false` |
| 11 | `widespread_infringement` | judgement | `true`, `false`, `unsure` |
| 12 | `report_made_immediately` | judgement | `true`, `false`, `unsure`; read by timeliness only |

**Dates.** AwarenessDate and ReportDate are query arguments, not profile keys. Each is a ground `date(Year, Month, Day)` of three integers that is a real calendar day.

**Numeric keys.** There are none, so no unit-suffixed key is needed.

**Judgement keys each query can read (THE PAIRS RULE).**

- duty: `significant_change_in_design_since_that_date`, `provider_subject_to_equivalent_union_reporting_obligations`, `widespread_infringement`;
- timeliness: those three plus `report_made_immediately`.

PAIRS lists the PRESENT ones, in root_exports order, with their values as given (`unsure` included), written `Key-Value`.

## Citation-key atoms (citation_vocabulary; canonical lexicon scheme)

| Atom | Source unit |
|---|---|
| `eu_reg_2024_1689_art_3_49` | Art 3 lead and point (49) [art_003, point_003_49] |
| `eu_reg_2024_1689_art_3_49_c` | Art 3(49)(c) [point_003_49_c] |
| `eu_reg_2024_1689_art_3_61` | Art 3(61) [point_003_61 ...]; referral row of `widespread_infringement` |
| `eu_reg_2024_1689_art_73_1` | Art 73(1) |
| `eu_reg_2024_1689_art_73_2` | Art 73(2); also the referral row of `report_made_immediately` |
| `eu_reg_2024_1689_art_73_3` | Art 73(3) |
| `eu_reg_2024_1689_art_73_4` | Art 73(4) |
| `eu_reg_2024_1689_art_73_5` | Art 73(5); in the vocabulary and the checklist, never in a contract answer |
| `eu_reg_2024_1689_art_73_6` | Art 73(6) |
| `eu_reg_2024_1689_art_73_9` | Art 73(9); referral row of `provider_subject_to_equivalent_union_reporting_obligations` |
| `eu_reg_2024_1689_art_73_10` | Art 73(10) |
| `eu_reg_2024_1689_art_111_2` | Art 111(2); referral row of `significant_change_in_design_since_that_date` |
| `eu_reg_2024_1689_art_113_c` | Art 113 third paragraph point (c) |
| `eu_reg_2024_1689_art_113_c_i` | point (c)(i) |
| `eu_reg_2024_1689_art_113_c_ii` | point (c)(ii) |

No shortened or invented atom may be used. CITATIONS are set-like lists, normalised with `sort/2` before any comparison.

## Public predicates (one line each)

- `serious_incident_report_duty(Profile, AwarenessDate, Duty, Citations)`: whether the Art 73(1) report is due, to whom, within 2, 10 or 15 days and by which last day, with the Art 73(6) follow-up duties. It follows ladder steps (0) to (11) and the unsure rule. Cites Art 73(1), (2), (3), (4), (6), (9), (10), Art 3(49), Art 111(2) and Art 113(c)(i)/(ii). Query #14.
- `serious_incident_report_timeliness(Profile, AwarenessDate, ReportDate, Verdict, Citations)`: whether a first report (Art 73(5)) made on ReportDate was in time, late, or not immediate. It follows steps (12) to (14) on the duty's answer. Cites Art 73(2), (3), (4) and the duty citations. Query #15.
- `serious_incident_reporting_input_problems(Profile, Problems)`: THE INPUT CHECK. It gives a bare flat list (duplicate_key, wrong_type, unknown_key; `[wrong_type(profile)]` for a non-attribute list) and never fails or raises. Cites nothing (contract check).
- `decide_serious_incident_reporting(serious_incident_case(Profile, AwarenessDate), serious_incident_reporting_verdict(Status, Citations))`: facade. Status and Citations are exactly the Duty and Citations of `serious_incident_report_duty/4`. Same citations.
- `serious_incident_reporting_status(serious_incident_case(Profile, AwarenessDate), Status)`: facade projection of Status only.
- `serious_incident_reporting_checklist(serious_incident_case(Profile, AwarenessDate), Checklist)`: the list of `item(RequirementId, Status, cite(Key))` rows, built with `formalize_lib:eval_requirements/4` over `requirement/4`. Status is `met`, `unmet(Reason)` or `unknown([Key])`. The rows are:
  - `applicable_on_date` [art_113_c_i / art_113_c_ii]
  - `high_risk_ai_system` [art_73_1]
  - `covered_by_transitional_rule` [art_111_2]
  - `serious_incident` [art_3_49]
  - `reportable_in_regime` [art_73_9 / art_73_10]
  - `time_limit_determined` [art_73_2 / art_73_3 / art_73_4]

  A row whose precondition failed is reported `met` only when it is not reached, as `unmet(not_reached)`.
- `serious_incident_reporting_what_if(serious_incident_case(Profile, AwarenessDate), Key, Value, Status)`: the duty Status after replacing or adding `attribute(Key, Value)` with `formalize_lib:profile_set/3`. The result passes through the input check, so a bad value gives input_problems.
- `serious_incident_reporting_fixture(Name, Profile, AwarenessDate, ReportDate, ExpectedDuty, ExpectedVerdict)` (fixtures.clausal): the named cases used by the tests and the facade examples (see Fixtures).

No public predicate returns a structured record in any other argument position.

## Planned reuse (manifest `uses:`)

**formalize_lib**

- `profile_get/3` (the only profile access)
- `profile_has/2`, `profile_lacks/2`
- `profile_set/3` (for what_if and for the unsure-rule runs)
- `profile_keys/2` (duplicate and unknown detection in the input check)
- `memberd/2`, `not_member/2`
- `eval_requirements/4` (checklist; not hand-rolled, rule R1)
- `item/3`, `unmet/1`, `unknown/1`, `attribute/2`

**library(datetime)**

- `timedelta/3` and `date_add/3`, for LAST_DAY = AwarenessDate + Days;
- `days_between/3`, for every before / on-or-after comparison.

Comparisons are made on date OBJECTS, never on `date/3` compounds, because of the string-ordering trap.

Until `date/3` lands, each ground `date(Y, M, D)` argument is converted to an object with `date(Y, M, D, Object)` (date/4), only after `real_calendar_date/1` has passed. The result object is converted back to a plain `date(Y, M, D)` for LAST_DAY.

**kit/deadline_lib**

- `month_last_day/3`, used inside `real_calendar_date/1` for the day range, including leap years.

**validate_props** (tests only)

- `run_props/1`
- `prop_totality/3`, `prop_determinism/3`
- `prop_citation_complete/3`
- `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`
- `bad_citation/1`

**list_item/3** (builtin): root_exports order position of keys, used for the first-key selection in U2 and U3.

**Not used, with reasons**

- **compliance_lib:** there is no deontic lattice conflict.
- **query_combinators `what_if/5`:** it takes a Dict, but the profile is an attribute list, so `profile_set/3` is used instead.
- **rolling_window:** not relevant to this order.
- **currency, vat and country vocabularies:** there is no money or country key.

## Package files and what each holds

**kernel.clausal** (the shared floor)

- The result-constructor declarations.
- `serious_incident_reporting_root_key/2`: the twelve keys with their 0-based order and type rows: `key_type(Key, enumeration(Atoms) | crisp | judgement)`.
- `real_calendar_date/1`: a ground `date(Y, M, D)` guard with integer fields, month 1 to 12 and day 1 to month_last_day. It never raises: it checks `nonvar` and `integer` first.
- `date_object/2`: converts a plain date to a datetime object.
- `citation_set_equal/2`: comparison via `sort/2`.

These are shared because queries.clausal, the facade and fixtures need them.

**citations.clausal**

- `citation_vocabulary/1`: the fifteen atoms above.
- `citation_source/2`: maps each atom to its pinned unit id.
- `referral_row(JudgementKey, CitationKey)`: the four rows of .

**parameters.clausal**

- No statutory figure. Those live in the slice.
- Only the pin metadata: consolidation id `02024R1689-20260727`, source sha256, and amending act `2026_1744`.

**serious_incident_reporting.clausal**: the one determination slice (below).

**queries.clausal**

- The two contract queries.
- The input check.
- THE UNSURE RULE wrapper over the slice's ladder.

**fixtures.clausal**: the named cases.

**Package facade**: the four facade predicates.

## Slice: serious_incident_reporting.clausal

### Value facts owned here (constant_value/2, read with constant/1)

- `report_period_general_days` = 15 (Art 73(2))
- `report_period_widespread_or_critical_infrastructure_days` = 2 (Art 73(3))
- `report_period_death_days` = 10 (Art 73(4))
- `annex_iii_application_date` = 2027-12-02 (Art 113(c)(i))
- `annex_i_application_date` = 2028-08-02 (Art 113(c)(ii))
- `public_authorities_compliance_date` = 2030-08-02 (Art 111(2), second sentence)
- `follow_up_duties`: the five atoms in their fixed order (Art 73(6))
- `recipient_for_device(true, national_competent_authority_chosen_by_member_state_where_incident_occurred)`
- `recipient_for_device(false, market_surveillance_authority_of_member_state_where_incident_occurred)`

The slice never reads `general_application_date` (2026-08-02, Art 113 second paragraph). It is recorded only as a comment, because reading  makes it non-deciding.

### Rules (THE LADDER; each a disjoint clause family, ground answers in heads)

The ladder is `ladder_duty(Profile, AwarenessObject, Duty, Citations)`. Its precondition is that no judgement key is unsure, which the queries guarantee by substitution. Its steps are:

- **L1 `not_applicable_on_date`, all systems.** Awareness is before 2027-12-02. Cites `art_113_c` and `art_113_c_i`. No key is read.
- **L2** `high_risk_classification` absent gives `indeterminate([high_risk_classification])`.
- **L3** `not_high_risk` gives `not_a_high_risk_ai_system`, citing `art_73_1`.
- **L4** `annex_i_high_risk` with awareness before 2028-08-02 gives `not_applicable_on_date`, citing `art_113_c` and `art_113_c_ii`.
- **L5 coverage under Art 111(2).** `coverage(Profile, AwarenessObject, covered | not_covered | missing(Key))`:
  - `not_covered` gives `not_covered_placed_before_application_date`, citing `art_111_2`;
  - `missing(Key)` gives `indeterminate([Key])`. The key order is placed, then significant_change, then public_authorities, and public_authorities is asked only for awareness on or after 2030-08-02.
- **L6** `medical_device_or_safety_component_of_one` absent gives `indeterminate([medical_device_or_safety_component_of_one])`.
- **L7** device false, Annex III, fundamental rights not true and equivalence absent gives `indeterminate([provider_subject_to_equivalent_union_reporting_obligations])`.
- **L8 the limited regime** (device true, or Annex III with equivalence true):
  - fundamental rights absent gives `indeterminate`;
  - false gives `not_a_reportable_incident`, citing `[art_73_10, art_3_49_c]` (device) or `[art_73_9, art_3_49_c]`;
  - true goes to L10.
- **L9 outside the regime.** `serious_incident_test(Profile, serious | not_serious | missing(Key))`:
  - serious when health is death or serious harm, or any of (b), (c), (d) is true;
  - otherwise the first absent of health, (b), (c), (d) gives indeterminate;
  - otherwise `not_a_serious_incident`, citing `art_3_49`.
- **L10 the limit.** `time_limit(Profile, days(Days, LimitCitations) | missing(Key))`:
  - (b) true, or widespread true, gives 2 days with `[art_73_3]`. This is written as two clauses that cannot both fire: the second requires (b) not true.
  - else the first absent of health, (b), widespread gives indeterminate;
  - else death gives 10 days with `[art_73_4]`;
  - else 15 days with `[art_73_2]`.
- **L11 the report.** `report_due(Recipient, Days, LastDay, FollowUp)`. LastDay comes from `date_add(AwarenessObject, timedelta(Days, 0))` and is converted back to `date(Y, M, D)`. The citations are `[art_73_1 | LimitCitations] ++ [art_73_6]`, plus `art_73_10` when device is true.

The timeliness ladder is `ladder_timeliness(Profile, AwarenessObject, ReportObject, Verdict, Citations)`:

- **T1** a non-report_due duty is passed through unchanged.
- **T2** report after LastDay (`days_between` > 0) gives `report_after_time_limit` with the duty citations.
- **T3** report on or before LastDay:
  - `report_made_immediately` absent gives `indeterminate`;
  - false gives `report_not_immediate`;
  - true gives `report_in_time`.

  T2 and T3 carry the duty citations.

### Unsure rule (in queries.clausal, over this slice)

- **Settings.** `unsure_judgements(Profile, Readable, Keys)` finds the unsure judgements in root_exports order.
- **Runs.** `run_settings/3` enumerates every true/false assignment through `profile_set/3`. The answers are collected with `findall` into `Runs = [run(Assignment, Answer, SortedCitations)]`.
- **U1/U2/U3 classification.** It is done by three disjoint clauses:
  - U1 holds when all runs are equal.
  - U2 holds when they are not all equal and some run is `indeterminate`. The minimum key position is taken via `list_item/3`.
  - U3 holds when they are not all equal and no run is `indeterminate`. J is the first unsure key such that two runs differing only in J differ.

  Each clause yields once (`findall` plus deterministic min selection), so there is no duplicate solution.

### Verdict atoms of this slice

All DUTY and VERDICT terms listed above, plus `indeterminate/1`. The slice never builds `needs_legal_review` or `input_problems`; queries.clausal builds those.

### Predicates shared with another slice (kernel.clausal)

There is no other determination slice. Only `real_calendar_date/1`, `date_object/2`, the root key and type rows, and `citation_set_equal/2` are in kernel. They are shared with queries.clausal, the facade and fixtures, not with a sibling slice.

## Input check (queries.clausal)

The input check runs in this order:

1. **Profile shape.** It checks for a non-list, a partial list, an unbound element, or an element that is not `attribute/2`. Any of these gives `[wrong_type(profile)]`. The guards are `var` and `nonvar` with `is_list`, and the check never raises.
2. **Contract keys.** For each contract key in contract order:
   - `duplicate_key(Key)` if the key occurs at least twice. Its values are not read.
   - otherwise `wrong_type(Key)` if the value is unbound or outside its type.
3. **Other keys.** `unknown_key(Key)` for each non-contract key, including non-atom keys and variables, once, in first-occurrence order. A variable key is compared with `==` to avoid unifying.

The queries then append date problems:

- duty: `wrong_type(awareness_date)`;
- timeliness: `wrong_type(awareness_date)`, then `wrong_type(report_date)`.

## Fixtures (fixtures.clausal) and test modes

### Boundary cases

| Case | Profile | Awareness | Expected |
|---|---|---|---|
| Before Annex III date | any | 2027-12-01 | `not_applicable_on_date` |
| Annex III date | Annex III, death, complete | 2027-12-02 | `report_due(market_surveillance_..., 10, date(2027, 12, 12), FollowUp)` |
| Before Annex I date | Annex I | 2028-08-01 | `not_applicable_on_date` |
| Annex I date | Annex I | 2028-08-02 | applicable |
| Day before public-authority date | early, no change, public | 2030-08-01 | `not_covered_placed_before_application_date` |
| Public-authority date | early, no change, public | 2030-08-02 | covered |
| Leap day | critical infrastructure | 2028-02-27 | 2 days, LastDay `date(2028, 2, 29)` |
| Year crossing | general | 2027-12-20 | 15 days, LastDay `date(2028, 1, 4)` |

### Device and limited-regime cases

- Device and non-(c) gives `not_a_reportable_incident`, citing `[art_73_10, art_3_49_c]`.
- Device and (c) gives the national competent authority recipient.

### Timeliness cases

- A report on LastDay with immediately true gives `report_in_time`.
- A report on LastDay + 1 gives `report_after_time_limit`.
- A report on LastDay with immediately false gives `report_not_immediate`.

### Unsure-rule cases

- Widespread `unsure` with (b) true gives U1: 2 days.
- Widespread `unsure` with (b) false and health absent gives U2: `indeterminate([harm_to_health])`.
- Widespread `unsure` with all present and no death gives U3: `needs_legal_review(open_textured(widespread_infringement, cite(eu_reg_2024_1689_art_3_61)), [inputs_relied_on([widespread_infringement-unsure])])`.

### Input-check cases

- A duplicate key.
- An unknown key.
- A non-atom key.
- An unbound value.
- A partial list.
- An invalid date such as `date(2027, 2, 30)`.

### Seven test modes

Each mode carries exactly-one-solution assertions, made with `findall` and `length` of 1:

1. load
2. per-rule unit
3. fixtures and golden answers
4. boundary
5. input check
6. unsure rule
7. properties (validate_props totality, determinism and citation completeness)

Every `fail` test is paired with a positive test over the same case.
