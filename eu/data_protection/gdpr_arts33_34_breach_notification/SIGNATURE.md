# SIGNATURE — eu/data_protection/gdpr_arts33_34_breach_notification

## 0. Public query surface (summary)

The contract queries come first. Their names are fixed by the order; each yields exactly one solution.

- `authority_notification_deadline(AWARE, DEADLINE, HOURS)`
- `authority_notification_period_end(AWARE, AWARENESS_HOUR, PERIOD_END)`
- `notification_obligation(PROFILE, OBLIGATION)`
- `breach_notification_verdict(PROFILE, HOURS_ELAPSED, VERDICT, CITES)`
- `authority_notification_content_check(PROFILE, RESULT)`
- `data_subject_communication_check(PROFILE, RESULT)`
- `gdpr_arts33_34_breach_notification_input_problems(PROFILE, PROBLEMS)`

The scaffold facade names are kept:

- `decide_breach_notification_verdict(CASE, gdpr_arts33_34_breach_notification_verdict(STATUS, CITATIONS))`
- `breach_notification_verdict_status(CASE, STATUS)`
- `breach_notification_verdict_checklist(CASE, CHECKLIST)`
- `gdpr_arts33_34_breach_notification_what_if(CASE, KEY, VALUE, DECISION)`
- the fixtures

CASE is `breach_case(PROFILE, HOURS_ELAPSED)`. HOURS_ELAPSED is an argument, not a profile key, so it would otherwise be refused as unknown_key.

PROFILE is an attribute list of the 25 keys of section 2.

The placeholder STATUS set `{ satisfied, not_satisfied }` is replaced by the atoms of section 1.

Totality: every query yields exactly ONE solution for every input, ground or not. A non-ground or ill-typed input is an input problem, never a failure or an error.

There are no imported figures. The two statutory figures, 72 hours and 3 calendar days, are declared once, in the slice (section 8).

## 1. Status and result atoms (replacing satisfied / not_satisfied)

VERDICT (`breach_notification_verdict/4` and the facade STATUS):
- `eligible` (final)
- `ineligible` (final; no Art 33(1) duty: J1 true)
- `notification_requirement_not_met(without_undue_delay)` (final)
- `notification_requirement_not_met(reasons_for_delay)` (final)
- `indeterminate(MISSING_KEYS)` (status; the bare atom `indeterminate` is NEVER written)
- `needs_legal_review(open_textured(KEY, cite(CITATION_KEY)), CONTEXT)` (status)
- `input_problems(PROBLEMS)`

OBLIGATION (`notification_obligation/2`) is either one list of duty terms (never `[]`) or one of the status compounds above. The duty terms are:
- `notify_controller(cite(eu_reg_2016_679_art_33_2))`
- `no_notification_required(cite(eu_reg_2016_679_art_33_1))`
- `notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1))`
- `document_breach(cite(eu_reg_2016_679_art_33_5))`
- `communicate_to_data_subject(cite(eu_reg_2016_679_art_34_1 | eu_reg_2016_679_art_34_4))`
- `no_communication_required(cite(eu_reg_2016_679_art_34_3_a | eu_reg_2016_679_art_34_3_b | eu_reg_2016_679_art_34_4))`
- `public_communication_or_similar_measure(cite(eu_reg_2016_679_art_34_3_c | eu_reg_2016_679_art_34_4))`

RESULT (content checks):
- `all_requirements_met`
- `requirements_not_met(ITEMS)`
- `information_to_follow_in_phases(ITEMS)` (authority notification only)
- or a status, or `input_problems(PROBLEMS)`

The item atoms are:
- Authority notification: `nature_of_breach`, `categories_and_approximate_numbers`, `contact_point`, `likely_consequences`, `measures_taken_or_proposed`, `mitigation_measures`.
- Data subject communication: `without_undue_delay`, `nature_of_breach_in_clear_and_plain_language`, `contact_point`, `likely_consequences`, `measures_taken_or_proposed`, `mitigation_measures`.

DEADLINE is `date(Y, M, D)` with bare integers, or `input_problems([wrong_type(awareness_date)])`. PERIOD_END is `period_end(date(Y, M, D), END_HOUR)` or `input_problems(PROBLEMS)`.

The problem terms are:
- `wrong_type(KEY)` (KEY is a contract key, or one of `profile`, `awareness_date`, `awareness_hour`, `hours_elapsed`)
- `duplicate_key(KEY)`
- `unknown_key(KEY)`
- `contradictory_inputs(KEYS)`

CONTEXT is either:
- `[inputs_relied_on([hours_elapsed-H | PAIRS])]` (TIMING CONTEXT: referrals on notification_made_without_undue_delay and delay_justified_by_reasons), or
- `[inputs_relied_on(PAIRS)]` (everywhere else; no provenance term is emitted).

The atoms `true` and `false` are never pinned in verdict_vocabulary or root_exports.

## 2. Profile keys (root_exports and input_contract order; all bare atoms)

| # | Key | Type | Values |
|---|---|---|---|
| 1 | breach_unlikely_to_result_in_risk (J1) | judgement | true, false, unsure |
| 2 | breach_likely_to_result_in_high_risk (J2) | judgement | true, false, unsure |
| 3 | delay_justified_by_reasons | judgement | true, false, unsure |
| 4 | party_role | enumeration | controller, processor |
| 5 | notification_made_without_undue_delay | judgement | true, false, unsure |
| 6 | notification_accompanied_by_reasons_for_delay | crisp | true, false |
| 7 | supervisory_authority_decision_on_communication (AUTHORITY) | enumeration | no_decision, required_communication, decided_point_a_condition_met, decided_point_b_condition_met, decided_point_c_condition_met |
| 8 | appropriate_protection_measures_applied_to_affected_data (A) | judgement | true, false, unsure |
| 9 | subsequent_measures_ensure_high_risk_no_longer_likely (B) | judgement | true, false, unsure |
| 10 | communication_would_involve_disproportionate_effort (C) | judgement | true, false, unsure |
| 11 | notification_describes_nature_of_breach | crisp | true, false |
| 12 | notification_gives_categories_and_approximate_numbers | crisp | true, false |
| 13 | categories_and_approximate_numbers_possible | judgement | true, false, unsure |
| 14 | notification_gives_contact_point | crisp | true, false |
| 15 | notification_describes_likely_consequences | crisp | true, false |
| 16 | notification_describes_measures_taken_or_proposed | crisp | true, false |
| 17 | notification_describes_mitigation_measures | crisp | true, false |
| 18 | mitigation_measures_appropriate | judgement | true, false, unsure |
| 19 | information_not_possible_to_provide_at_the_same_time | judgement | true, false, unsure |
| 20 | communication_made_without_undue_delay | judgement | true, false, unsure |
| 21 | communication_describes_nature_in_clear_and_plain_language | judgement | true, false, unsure |
| 22 | communication_gives_contact_point | crisp | true, false |
| 23 | communication_describes_likely_consequences | crisp | true, false |
| 24 | communication_describes_measures_taken_or_proposed | crisp | true, false |
| 25 | communication_describes_mitigation_measures | crisp | true, false |

Argument names are not profile keys:
- `awareness_date`: AWARE, a ground `date(Year, Month, Day)` of a real UTC calendar day.
- `awareness_hour`: AWARENESS_HOUR, an integer 0..23.
- `hours_elapsed`: HOURS_ELAPSED, a non-negative integer, the hours begun with a partial hour rounded UP.

There are no money or measured profile keys, so no unit suffix applies.

## 3. Citation keys (citation_vocabulary; canonical lexicon scheme, spelled in full)

Each citation is written `cite(KEY)`. The P2 author must confirm every key verbatim against `_lexicon/citations.yaml` and must never shorten one.

- `eu_reg_2016_679_art_33_1`: Art 33(1), duty to notify the SA, the 72 hours and the reasons for delay. Used by the verdict, obligation and J1 referrals.
- `eu_reg_2016_679_art_33_2`: processor's duty to notify the controller.
- `eu_reg_2016_679_art_33_3_a`: nature, and categories/numbers where possible. Used in the categories referral and checklist items.
- `eu_reg_2016_679_art_33_3_b`: contact point (checklist items).
- `eu_reg_2016_679_art_33_3_c`: likely consequences (checklist items).
- `eu_reg_2016_679_art_33_3_d`: measures, and mitigation where appropriate. Used in the mitigation referral in both content checks.
- `eu_reg_2016_679_art_33_4`: information in phases. Used in the phases referral.
- `eu_reg_2016_679_art_33_5`: documentation.
- `eu_reg_2016_679_art_34_1`: communication to the data subject. Used in the J2 referral, the communication timing referral and the TERM when no exemption applies.
- `eu_reg_2016_679_art_34_2`: clear and plain language, and the minimum content. Used in the language referral.
- `eu_reg_2016_679_art_34_3_a`, `eu_reg_2016_679_art_34_3_b`, `eu_reg_2016_679_art_34_3_c`: the exemptions and the public-communication substitute.
- `eu_reg_2016_679_art_34_4`: decision of the supervisory authority.
- `eu_reg_1971_1182_art_3_1`, `eu_reg_1971_1182_art_3_2_a`, `eu_reg_1971_1182_art_3_3`, `eu_reg_1971_1182_art_3_4`: the period-in-hours rules. They are cited in the period predicates' documentation and checklist, never in VERDICT or CITES.

Deferred: `eu_reg_1971_1182_art_3_5` and `eu_reg_1971_1182_art_1` are listed in the deferred set only and are read by no rule.

## 4. Public predicates (one line each)

- `authority_notification_deadline(AwarenessDate, DeadlineDate, PeriodHours)`: DeadlineDate is AwarenessDate plus 3 calendar days, as `date(Y, M, D)` with bare integers, never shifted. PeriodHours is 72 always. An AwarenessDate that is not a real day gives `input_problems([wrong_type(awareness_date)])` with 72. One solution. Cites eu_reg_2016_679_art_33_1, eu_reg_1971_1182_art_3_1, eu_reg_1971_1182_art_3_2_a, eu_reg_1971_1182_art_3_3 and eu_reg_1971_1182_art_3_4.
- `authority_notification_period_end(AwarenessDate, AwarenessHour, PeriodEnd)`: PeriodEnd is `period_end(date(Y, M, D), AwarenessHour + 1)`, the date being AwarenessDate plus 3 days. Otherwise it is `input_problems(PROBLEMS)` with `wrong_type(awareness_date)` and then `wrong_type(awareness_hour)` for each argument at fault. One solution. Cites eu_reg_1971_1182_art_3_1 and eu_reg_1971_1182_art_3_2_a.
- `notification_obligation(Profile, Obligation)`: one list of duties in article order, or a status (limbs in section 9.2). Cites eu_reg_2016_679_art_33_1, eu_reg_2016_679_art_33_2, eu_reg_2016_679_art_33_5, eu_reg_2016_679_art_34_1, the eu_reg_2016_679_art_34_3_* keys and eu_reg_2016_679_art_34_4.
- `breach_notification_verdict(Profile, HoursElapsed, Verdict, Citations)`: scores the controller's Art 33 notification (limbs in section 9.3). Citations is `[cite(eu_reg_2016_679_art_33_1)]` for every final verdict and `[]` otherwise. Cites eu_reg_2016_679_art_33_1.
- `authority_notification_content_check(Profile, Result)`: checks the notification against Art 33(3)(a)-(d) and Art 33(4) (section 9.4). Cites eu_reg_2016_679_art_33_3_a to eu_reg_2016_679_art_33_3_d and eu_reg_2016_679_art_33_4.
- `data_subject_communication_check(Profile, Result)`: checks the communication against Art 34(1) timing and Art 34(2) (section 9.5). Cites eu_reg_2016_679_art_34_1, eu_reg_2016_679_art_34_2 and eu_reg_2016_679_art_33_3_d.
- `gdpr_arts33_34_breach_notification_input_problems(Profile, Problems)`: the typed input check (section 9.1). One solution. `[]` when the profile is well-formed.
- `decide_breach_notification_verdict(BreachCase, Decision)`: BreachCase is `breach_case(Profile, HoursElapsed)`. Decision is `gdpr_arts33_34_breach_notification_verdict(Verdict, Citations)`, delegating to `breach_notification_verdict/4`. Cites eu_reg_2016_679_art_33_1.
- `breach_notification_verdict_status(BreachCase, Status)`: Status is the Verdict of the decision.
- `breach_notification_verdict_checklist(BreachCase, Checklist)`: the cited checklist of `item(RequirementId, Status, cite(eu_reg_2016_679_art_33_1))`, built with `eval_requirements/4` (section 8). Input problems give `[]`.
- `gdpr_arts33_34_breach_notification_what_if(BreachCase, Key, Value, Decision)`: replaces Key (a profile key, or `hours_elapsed` for the argument) with Value, using `profile_set/3`, then decides. One solution.
- `gdpr_arts33_34_breach_notification_fixture(FixtureName, BreachCase)`: named cases (section 10).

Result constructors are exported and are never called as queries:
- input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, contradictory_inputs/1
- no_notification_required/1, notify_supervisory_authority/1, notify_controller/1, document_breach/1
- communicate_to_data_subject/1, no_communication_required/1, public_communication_or_similar_measure/1
- notification_requirement_not_met/1, period_end/2, requirements_not_met/1, information_to_follow_in_phases/1
- indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2

## 5. Planned reuse (manifest `uses:`)

- `formalize_lib`:
  - `profile_get/3`: the ONLY value reader.
  - `profile_keys/2`: order of first occurrence, for unknown_key.
  - `profile_set/3`: what_if.
  - `check_tri_neg/4`: checklist row for J1, negative polarity.
  - `check_tri/4`: checklist rows for the timing judgements.
  - `status_lte/4`: checklist row HoursElapsed =< 72.
  - `eval_requirements/4`: the checklist engine, with the requirement closure injected. It is never hand-rolled (R1).
  - `not_member/2`, `memberd/2`.
  - Vocabulary atoms `met`, `unmet/1`, `unknown/1`, `item/3`.
- `library(datetime)`: `timedelta/3` and `date_add/3`, for AWARE plus 3 days on the native date object. The object is built and read with the `date(Y, M, D, Object)` constructor and converted to and from the contract's `date(Y, M, D)` compound at the boundary only.
- `kit/deadline_lib`: `month_last_day/3`, for the real-calendar-day check. `deadline/4` is NOT used, because Art 3(1) and 3(2)(a) define an hour period, not a trigger-plus-days period.
- `validate_props`:
  - `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`.
  - `bad_citation/1`, to catch an invented citation atom.
- `list_item/3` (built-in): position lookup in the key-order table.
- Considered and not used:
  - `kit/query_combinators` `what_if/5` overrides a dict key; our profile is an attribute list and hours_elapsed is an argument.
  - compliance_lib, rolling_window, currency_vocab, vat_category and country do not fit this domain.

Engine risk for P2: the card says `date/3` is not yet registered. The contract nevertheless fixes `date(Y, M, D)` compounds as AWARE and DEADLINE. P2 must confirm that a plain `date(Y, M, D)` compound can be written and unified, as a data term not an evaluable, before authoring the boundary conversion. Dates are never compared, so the msort and string-order trap does not arise.

## 6. Module layout (unchanged; contents planned)

- `kernel.clausal`: the shared floor only. It holds the predicates used by more than one file: the slice, queries and facade all run the input check first.
  - `gdpr_arts33_34_breach_notification_contract_key(Position, Key, Type)`: 25 facts. Type is `judgement`, `crisp`, `enumeration(Atoms)`.
  - `gdpr_arts33_34_breach_notification_value_has_type(Type, Value)`.
  - `gdpr_arts33_34_breach_notification_input_problems/2`.
  - `gdpr_arts33_34_breach_notification_argument_problems/3`, for awareness_date, awareness_hour and hours_elapsed.
  - `gdpr_arts33_34_breach_notification_real_calendar_day/1`.
- `citations.clausal`: the citation_vocabulary facts of section 3, each with its pinned unit id and verbatim text reference.
- `parameters.clausal`: source-version pins only. These are `source_version(eu_reg_2016_679, '02016R0679-20160504')` and `source_version(eu_reg_1971_1182, '31971R1182-fetched-2026-11-05')`. No statutory figure is declared here.
- `breach_notification_verdict.clausal`: the single determination slice (section 8).
- `queries.clausal`: the facade queries (decide, status, checklist, what_if) over the slice.
- `fixtures.clausal`: the named BreachCase fixtures (section 10).
- Package facade: re-exports the public predicates and the result constructors in the root_exports order of section 2.

## 7. Totality, determinism, counting

Every public predicate is written as mutually exclusive guarded clauses: type guards, presence via `profile_get/3` or its negation-as-failure, and value guards. The ground answer is folded into the clause head (C17), with no cut, if-then-else or soft-cut.

Each query therefore yields exactly ONE solution. A list result is built once, never one solution per duty.

Tests assert the count with `findall/3` and `length(Results, 1)`. Every negative test is paired with a positive test over the same case.

## 8. Determination slice — breach_notification_verdict.clausal

This is the only slice. It is self-contained for the Art 33/34 determination: it owns the value facts, the derived period arithmetic, every limb, the per-rule tests, the checklist rows and the verdict.

**Statutory VALUE facts owned here** (declared once, read with `constant(Name)`):
- `:- constant_value(authority_notification_period_hours, 72).` (Art 33(1))
- `:- constant_value(authority_notification_period_calendar_days, 3).` (72 hours = 3 calendar days from the end of the hour of awareness; Reg 1182/71 Art 3(1), 3(2)(a))
- `:- constant_value(awareness_hour_minimum, 0).`
- `:- constant_value(awareness_hour_maximum, 23).`
- `:- constant_value(excluded_hour_of_awareness, 1).` (END_HOUR = AWARENESS_HOUR + this; Art 3(1))

There is no holiday table: Art 3(3) and 3(4) mean the period is never shifted.

**Rules / requirements:**
- R-period-day: DAY = AWARE + `authority_notification_period_calendar_days`, using `timedelta/3` and `date_add/3`.
- R-period-hour: END_HOUR = AWARENESS_HOUR + 1.
- R-hours: HOURS = 72 for every AWARE.
- R-timing: HOURS_ELAPSED =< 72 means within the period, and > 72 means beyond it (73 is the first late value).
- R-duty-arises (J1), R-undue-delay (key 5), R-reasons-given (key 6), R-reasons-justify (key 3, reading (1)).
- R-processor (Art 33(2)), R-documentation (Art 33(5)), R-communication (Art 34(1)), R-exemptions (Art 34(3)(a)-(c)), R-authority-decision (Art 34(4)).
- R-contradictions (reading (8)): enforced by the kernel input check.
- R-content-notification (Art 33(3), 33(4)) and R-content-communication (Art 34(1), 34(2)).

**Checklist rows** for `breach_notification_verdict_checklist/2`. The requirement closure is `breach_notification_requirement(RequirementId, BreachCase, Status, Citation)`, with RequirementId FIRST. Every row cites `cite(eu_reg_2016_679_art_33_1)`.
- The id list depends on the timing branch:
  - Within the period: `[duty_to_notify_arises, notification_made_without_undue_delay]`.
  - Beyond the period: `[duty_to_notify_arises, notification_accompanied_by_reasons_for_delay, delay_justified_by_reasons]`.
- Statuses are `met`, `unmet(Reason)` or `unknown([Key])`, with three disjoint clauses per row. Rows use `check_tri_neg/4` (J1) and `check_tri/4` (key 5 and key 3).
- The checklist explains the verdict but never decides it. STATUS always comes from `breach_notification_verdict/4`, never from `decide_labeled/3`. The the first-missing-key rule precedence and reading (1) cannot be expressed in the labeled classifier.

**Verdict atoms:** those of section 1, VERDICT, OBLIGATION and RESULT.

**Predicates SHARED with another file:** the input check, the contract-key table and the real-calendar-day check. These live in kernel.clausal (section 6). Everything else, including the PAIRS builder, is slice-local.

## 9. The limbs (exact algorithm for P2)

Notation:
- J1 = key 1, J2 = key 2, AUTHORITY = key 7, A/B/C = keys 8/9/10.
- 'absent' means `profile_get/3` finds no entry.
- PAIRS = judgement Key-Value pairs read, in root_exports order, up to and including the referring key.

### 9.1 Input check (kernel)

1. PROFILE is not a proper list whose every element is `attribute(Key, Value)`: the answer is `[wrong_type(profile)]` alone.
2. For each contract key in order:
   - `duplicate_key(K)` if it occurs at least twice. Its values are not read.
   - Otherwise `wrong_type(K)` if it is present once with a value outside its type.
3. Then `unknown_key(K)` for each non-contract key, in order of first occurrence, once each.
4. Then the contradictory pairs, each key present exactly once and well-typed:
   - J1 true and J2 true: `contradictory_inputs([breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk])`.
   - Key 3 true and key 6 false: `contradictory_inputs([delay_justified_by_reasons, notification_accompanied_by_reasons_for_delay])`.

Queries with arguments append argument problems after the profile problems: wrong_type(awareness_date), then wrong_type(awareness_hour), then wrong_type(hours_elapsed).

### 9.2 notification_obligation(PROFILE, OBLIGATION)

- (0) Problems non-empty: `input_problems(P)`.
- (1) party_role:
  - absent: `indeterminate([party_role])`.
  - processor: `[notify_controller(cite(eu_reg_2016_679_art_33_2))]`.
  - controller: continue.
- (2) J1 or AUTHORITY absent: `indeterminate` naming every absent one of the two, in the order J1, then AUTHORITY.
- (3) Which keys are read next:
  - AUTHORITY is a decision, or AUTHORITY is no_decision and J1 is true: go to (5) with no TERM.
  - Otherwise (no_decision, J1 false or unsure):
    - J2 absent: `indeterminate([breach_likely_to_result_in_high_risk])`.
    - J2 false: no TERM, go to (5).
    - J2 true or unsure: go to (4).
- (4) Exemptions:
  - A true: TERM `no_communication_required(cite(...art_34_3_a))`.
  - Otherwise B true: TERM `no_communication_required(cite(...art_34_3_b))`.
  - Otherwise the first absent of A, B, C: `indeterminate([that key])`.
  - Otherwise any unsure among A, B, C: no TERM, referral in (5).
  - Otherwise C true: TERM `public_communication_or_similar_measure(cite(...art_34_3_c))`.
  - Otherwise: TERM `communicate_to_data_subject(cite(...art_34_1))`.
- (5) Referral: the first unsure, in the order J1, J2 (if read), A, B, C (if read in (4) and not decided by a true A or B), gives `needs_legal_review(open_textured(KEY, CITE), [inputs_relied_on(PAIRS)])`.
  - CITE is art_33_1 for J1, art_34_1 for J2, and art_34_3_a, art_34_3_b or art_34_3_c for A, B or C.
  - A referral on J1 carries `[J1-unsure]` only.
- (6) Final list:
  - First `no_notification_required(cite(...art_33_1))` if J1 is true, or `notify_supervisory_authority(cite(...art_33_1))` if J1 is false.
  - Then `document_breach(cite(...art_33_5))`.
  - Then the Art 34 term:
    - required_communication: `communicate_to_data_subject(cite(...art_34_4))`.
    - decided_point_a_condition_met or decided_point_b_condition_met: `no_communication_required(cite(...art_34_4))`.
    - decided_point_c_condition_met: `public_communication_or_similar_measure(cite(...art_34_4))`.
    - no_decision: the TERM from (4) if J2 is true; none if J1 is true or J2 is false.

### 9.3 breach_notification_verdict(PROFILE, H, VERDICT, CITES)

This query does not read J2, party_role, AUTHORITY or keys 8-25.

- (0) Profile problems plus hours_elapsed problems, when non-empty: `input_problems(P)`, `[]`.
- (1) J1 absent: `indeterminate([breach_unlikely_to_result_in_risk])`, `[]`.
- (2) J1 true: `ineligible`, `[cite(eu_reg_2016_679_art_33_1)]`, whatever H is.
- (3) J1 false or unsure, and H =< 72:
  - Key 5 absent: `indeterminate([notification_made_without_undue_delay])`.
  - Otherwise J1 unsure: `needs_legal_review(open_textured(breach_unlikely_to_result_in_risk, cite(...art_33_1)), [inputs_relied_on([breach_unlikely_to_result_in_risk-unsure])])`.
  - Otherwise (J1 false), key 5:
    - unsure: `needs_legal_review(open_textured(notification_made_without_undue_delay, cite(...art_33_1)), [inputs_relied_on([hours_elapsed-H, breach_unlikely_to_result_in_risk-false, notification_made_without_undue_delay-unsure])])`.
    - true: `eligible`.
    - false: `notification_requirement_not_met(without_undue_delay)`.
- (4) J1 false or unsure, and H > 72:
  - Key 6 absent: `indeterminate([notification_accompanied_by_reasons_for_delay])`.
  - Key 6 false:
    - J1 unsure: J1 referral as in (3).
    - J1 false: `notification_requirement_not_met(reasons_for_delay)`.
  - Key 6 true:
    - Key 3 absent: `indeterminate([delay_justified_by_reasons])`.
    - Otherwise J1 unsure: J1 referral.
    - Otherwise (J1 false), key 3:
      - true: `eligible`.
      - false or unsure: `needs_legal_review(open_textured(delay_justified_by_reasons, cite(...art_33_1)), [inputs_relied_on([hours_elapsed-H, breach_unlikely_to_result_in_risk-false, delay_justified_by_reasons-V])])`.

CITES is `[cite(eu_reg_2016_679_art_33_1)]` exactly for eligible, ineligible and notification_requirement_not_met/1, and `[]` for every other verdict.

### 9.4 authority_notification_content_check(PROFILE, RESULT)

Definitions:
- ITEM-IN means the item enters ITEMS:
  - nature (11 false), contact (14 false), consequences (15 false), measures (16 false);
  - categories (12 false and 13 true);
  - mitigation (17 false and 18 true).
- COULD means no present value rules the item out:
  - the plain four: crisp key absent or false;
  - categories: 12 absent or false, and 13 not present-false;
  - mitigation: 17 absent or false, and 18 not present-false.

The needed set R contains:
- 11, 14, 15, 16 always;
- 12 unless 13 is present-false;
- 17 unless 18 is present-false;
- 13 if 12 is false;
- 18 if 17 is false;
- 19 if some ITEM-IN holds or COULD holds for at least 2 items.

Steps:
- (0) Problems non-empty: `input_problems(P)`.
- (1) Absent members of R, in root order: `indeterminate(THEM)`. 19 is excluded when COULD holds for exactly one item and that item waits on an absent key.
- (2) 19 absent, COULD holds for exactly one item, and it is categories (12 false, 13 unsure) or mitigation (17 false, 18 unsure): `indeterminate([information_not_possible_to_provide_at_the_same_time])`.
- (3) The first unsure among 13 (if read) and 18 (if read): referral citing art_33_3_a or art_33_3_d, with PAIRS from 13, 18.
- (4) ITEMS in the order nature_of_breach, categories_and_approximate_numbers, contact_point, likely_consequences, measures_taken_or_proposed, mitigation_measures. Empty: `all_requirements_met`.
- (5) ITEMS non-empty, key 19:
  - unsure: referral citing art_33_4, with PAIRS from 13 (if read), 18 (if read) and 19-unsure.
  - true: `information_to_follow_in_phases(ITEMS)`.
  - false: `requirements_not_met(ITEMS)`.

### 9.5 data_subject_communication_check(PROFILE, RESULT)

The needed set R contains:
- 20, 21, 22, 23, 24 always;
- 25 unless 18 is present-false;
- 18 if 25 is false.

Steps:
- (0) Problems non-empty: `input_problems(P)`.
- (1) Absent members of R, in root order: `indeterminate(THEM)`.
- (2) The first unsure in root order among 18 (if read), 20, 21: referral citing art_33_3_d, art_34_1 or art_34_2. PAIRS are the read judgements up to it, e.g. `[mitigation_measures_appropriate-true, communication_made_without_undue_delay-unsure]`.
- (3) ITEMS in the order without_undue_delay (20 false), nature_of_breach_in_clear_and_plain_language (21 false), contact_point (22 false), likely_consequences (23 false), measures_taken_or_proposed (24 false), mitigation_measures (25 false and 18 true). Empty: `all_requirements_met`; otherwise `requirements_not_met(ITEMS)`.

## 10. Fixtures (fixtures.clausal; `gdpr_arts33_34_breach_notification_fixture(Name, breach_case(Profile, HoursElapsed))`)

- `timely_notification_eligible`: J1 false, key 5 true, H 40.
- `boundary_seventy_two_hours_in_time`: J1 false, key 5 true, H 72, giving eligible.
- `boundary_seventy_three_hours_with_justified_reasons`: H 73, key 6 true, key 3 true, giving eligible.
- `late_without_reasons`: H 90, key 6 false, giving notification_requirement_not_met(reasons_for_delay).
- `late_with_unjustified_reasons_referred`: H 90, key 6 true, key 3 false, giving a referral.
- `unduly_delayed_within_period`: H 50, key 5 false, giving notification_requirement_not_met(without_undue_delay).
- `unlikely_risk_ineligible`: J1 true, H 200, giving ineligible.
- `unsure_risk_referred`: J1 unsure, key 5 true, H 10.
- `missing_risk_judgement_indeterminate`: J1 absent.
- `contradictory_risk_inputs`: J1 true, J2 true, giving input_problems.
- `public_communication_substitute`: the obligation example of THE LIMBS.
- `processor_notifies_controller`.
- `authority_required_communication`.

Deadline fixtures: 2025-10-31 to 2025-11-03; 2032-02-26 to 2032-02-29; 2032-02-27 to 2032-03-01; 2025-12-30 to 2026-01-02; hour 23 to END_HOUR 24.

## 11. Test plan (seven modes, v2 manifest)

1. **load**: the package and every module load; every root export resolves.
2. **unit / per-rule**: one test per limb step of section 9, each paired positive and negative.
3. **boundary**:
   - H 0, 72, 73;
   - AWARENESS_HOUR 0, 23, 24 (24 is wrong_type), -1;
   - month end, year end, leap day; 2031-02-29 is wrong_type.
4. **missing-key / precedence**: the first-missing-key rule cases.
   - Both J1 and AUTHORITY named.
   - J2 alone named.
   - The first absent of A/B/C named.
   - In the content check, the phases key named beside an absent crisp key.
5. **counting / determinism**: `findall/3` gives exactly one solution for every public query over the fixtures and an exhaustive tri-state sweep of the verdict keys.
6. **input-problems**:
   - duplicate keys, equal or unequal;
   - unknown keys in first-occurrence order;
   - wrong types;
   - non-list and non-attribute elements, giving `[wrong_type(profile)]`;
   - both contradictory pairs;
   - argument problems after profile problems.
7. **properties** (validate_props):
   - totality, determinism;
   - citation completeness (every final verdict cites art_33_1, checked with `bad_citation/1`);
   - boundary coverage, missing-key coverage.
