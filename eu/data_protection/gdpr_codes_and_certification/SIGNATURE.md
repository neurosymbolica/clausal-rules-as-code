# SIGNATURE — eu/data_protection/gdpr_codes_and_certification

This is the authoring plan for the later phases. Shape family: deontic. The layout is kept exactly:

`kernel -> citations -> parameters -> gdpr_codes_and_certification -> queries -> fixtures -> package facade`

There are seven test modes and a v2 manifest. No file or module is renamed.

## Public query surface

The CALLED CONTRACT is the four contract queries below. Each yields EXACTLY ONE solution for every input, including malformed ones. Their arguments are ordered INPUTS then OUTPUTS.

- `certification_status(Profile, IssuedOn, CheckDate, Result, Citations)`
- `code_monitoring_status(Profile, Result, Citations)`
- `accreditation_status(Profile, Body, AccreditedOn, CheckDate, Result, Citations)`
- `gdpr_codes_and_certification_input_problems(Profile, Problems)`

The scaffold facade keeps its names and delegates to the contract queries. Its Request is a closed term, exactly one of:

- `certification(Profile, IssuedOn, CheckDate)`
- `code(Profile)`
- `accreditation(Profile, Body, AccreditedOn, CheckDate)`

The facade predicates are:

- `decide_gdpr_codes_and_certification(Request, gdpr_codes_and_certification_verdict(Result, Citations))`
- `gdpr_codes_and_certification_status(Request, Result)`
- `gdpr_codes_and_certification_checklist(Request, Checklist)`
- `gdpr_codes_and_certification_what_if(Request, Key, Value, Result)`
- the fixtures

No answer holds a number, a date or a string. The only exception is the KEY of `unknown_key(KEY)`, which is returned as given.

### Totality and determinism claims

These hold for every term given, for every contract query and every facade predicate whose Request is one of the three forms:

- totality: at least one solution;
- determinism: exactly one solution;
- no exception.

A Request of any other form gives `input_problems([wrong_type(request)])`. `request` is an argument name only and is not exported.

No statutory figure is imported: both periods are declared in the slice.

## Verdict STATUS atoms (replace the placeholders required / permitted / not_applicable)

The status atoms are grouped by the part or ladder that gives them.

**VALIDITY part, inside `certification_result/2`.** One bare atom of:
- `not_yet_issued`
- `maximum_period_ended`
- `not_issued_by_competent_issuer`
- `criteria_not_approved`
- `issued_without_informing_supervisory_authority`
- `withdrawn`
- `withdrawal_required`
- `within_maximum_period`

**TRANSFER part, in both queries.** One bare atom of:
- `not_relied_on_for_transfers`
- `transfer_conditions_not_met`
- `transfer_conditions_met`

**MONITORING part, inside `code_result/2`.** One of:
- `article_41_not_applicable`
- `not_a_code_under_article_40_2`
- `code_not_approved`
- `monitoring_mechanisms_missing`
- `no_accredited_monitoring_body`
- `monitoring_by_accredited_body([take_appropriate_action_on_infringement, inform_supervisory_authority_of_actions_and_reasons])`

**Duties atoms.** These are the two items of that list, in that order:
- `take_appropriate_action_on_infringement`
- `inform_supervisory_authority_of_actions_and_reasons`

**Accreditation ladder.** The RESULT is one bare atom of:
- `not_yet_accredited`
- `maximum_period_ended` (certification_body only)
- `accreditation_revoked`
- `not_accredited_by_entity_named_in_article_43_1` (certification_body only)
- `accreditation_conditions_not_met`
- `revocation_required`
- `accreditation_conditions_met`

**Result constructors.** These are exported and never called as queries:
- `certification_result/2`
- `code_result/2`
- `monitoring_by_accredited_body/1`
- `indeterminate/1`
- `needs_legal_review/2`
- `open_textured/2`
- `inputs_relied_on/1`
- `input_problems/1`
- `unknown_key/1`
- `wrong_type/1`
- `duplicate_key/1`

**Statuses that are not final.** There are three forms:
- `indeterminate([Key])`: exactly one key. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`
- `input_problems(Problems)`

All of them give `Citations` `[]`. The reserved atom `unknown` is never used. `true` and `false` are never pinned in verdict_vocabulary or root_exports.

**root_exports order.** The thirty keys (order below), then the result atoms above, then the duties atoms, then the enumeration atoms. The enumeration atoms are `certification_body`, `competent_supervisory_authority`, `other_issuer`, `national_accreditation_body`, `both_named_entities`, `other_entity`, and the BODY atom `monitoring_body` (`certification_body` is shared), then `unsure`. The names `profile`, `body`, `issued_on`, `accredited_on`, `check_date` and `request` appear only inside `wrong_type(...)` and are not exported.

## Profile keys (input_contract order = root_exports order; bare atoms, read only with profile_get/3)

There are thirty keys. There are no numbers, lists or outside facts, and no attested wrapper (`attested(...)` gives `wrong_type(Key)`). Dates are arguments, not keys.

| # | key | type | read by |
|---|-----|------|---------|
| 1 | certification_issuer | issuer: certification_body / competent_supervisory_authority / other_issuer | certification_status |
| 2 | certification_body_accredited | boolean (true/false) | certification_status (issuer certification_body only) |
| 3 | certification_criteria_approved | boolean | certification_status (VALIDITY and TRANSFER) |
| 4 | supervisory_authority_informed_before_issue_or_renewal | boolean | certification_status (issuer certification_body only) |
| 5 | certification_withdrawn | boolean | certification_status |
| 6 | certification_requirements_not_met | judgement (true/false/unsure) | certification_status |
| 7 | certification_holder_not_subject_to_regulation | boolean | certification_status |
| 8 | certification_holder_binding_commitments_made | boolean | certification_status |
| 9 | processing_by_public_authority_or_body | boolean | code_monitoring_status |
| 10 | code_prepared_by_body_representing_controllers_or_processors | judgement | code_monitoring_status |
| 11 | code_approved_by_competent_supervisory_authority | boolean | code_monitoring_status (MONITORING and TRANSFER) |
| 12 | code_contains_monitoring_mechanisms | boolean | code_monitoring_status |
| 13 | monitoring_body_accredited | boolean | code_monitoring_status |
| 14 | code_adhered_to_by_party_not_subject_to_regulation | boolean | code_monitoring_status |
| 15 | code_has_general_validity | boolean | code_monitoring_status |
| 16 | code_adherent_binding_commitments_made | boolean | code_monitoring_status |
| 17 | monitoring_body_accreditation_revoked | boolean | accreditation_status monitoring_body |
| 18 | monitoring_body_independence_and_expertise_demonstrated | judgement | accreditation_status monitoring_body |
| 19 | monitoring_body_eligibility_monitoring_and_review_procedures_established | boolean | accreditation_status monitoring_body |
| 20 | monitoring_body_complaint_procedures_and_structures_established | boolean | accreditation_status monitoring_body |
| 21 | monitoring_body_no_conflict_of_interests_demonstrated | judgement | accreditation_status monitoring_body |
| 22 | monitoring_body_actions_infringe_regulation | judgement | accreditation_status monitoring_body |
| 23 | certification_body_accreditation_revoked | boolean | accreditation_status certification_body |
| 24 | certification_body_accrediting_entity | accrediting_entity: competent_supervisory_authority / national_accreditation_body / both_named_entities / other_entity | accreditation_status certification_body |
| 25 | certification_body_independence_and_expertise_demonstrated | judgement | accreditation_status certification_body |
| 26 | certification_body_undertook_to_respect_approved_criteria | boolean | accreditation_status certification_body |
| 27 | certification_body_issuing_review_and_withdrawal_procedures_established | boolean | accreditation_status certification_body |
| 28 | certification_body_complaint_procedures_and_structures_established | boolean | accreditation_status certification_body |
| 29 | certification_body_no_conflict_of_interests_demonstrated | judgement | accreditation_status certification_body |
| 30 | certification_body_actions_infringe_regulation | judgement | accreditation_status certification_body |

A key that a query (or a BODY) does not read never changes that answer. It is still checked by the input check.

### Arguments and their typed form

- `IssuedOn`, `AccreditedOn` and `CheckDate` are `date(Year, Month, Day)`: three integers naming a real Gregorian day, Year from 1 to 9999.
- `Body` is `monitoring_body` or `certification_body`.
- In `wrong_type(...)`, these carry the names `issued_on`, `accredited_on`, `check_date` and `body`.

## Citation-key atoms (canonical _lexicon scheme; citation_vocabulary; never shortened further)

**Article 40**
- `eu_reg_2016_679_art_40_2`
- `eu_reg_2016_679_art_40_3`
- `eu_reg_2016_679_art_40_4`
- `eu_reg_2016_679_art_40_5`
- `eu_reg_2016_679_art_40_9`

**Article 41**
- `eu_reg_2016_679_art_41_1`
- `eu_reg_2016_679_art_41_2`
- `eu_reg_2016_679_art_41_2_a`
- `eu_reg_2016_679_art_41_2_b`
- `eu_reg_2016_679_art_41_2_c`
- `eu_reg_2016_679_art_41_2_d`
- `eu_reg_2016_679_art_41_4`
- `eu_reg_2016_679_art_41_5`
- `eu_reg_2016_679_art_41_6`

**Article 42**
- `eu_reg_2016_679_art_42_2`
- `eu_reg_2016_679_art_42_4`
- `eu_reg_2016_679_art_42_5`
- `eu_reg_2016_679_art_42_7`

**Article 43**
- `eu_reg_2016_679_art_43_1`
- `eu_reg_2016_679_art_43_1_a`
- `eu_reg_2016_679_art_43_1_b`
- `eu_reg_2016_679_art_43_2`
- `eu_reg_2016_679_art_43_2_a`
- `eu_reg_2016_679_art_43_2_b`
- `eu_reg_2016_679_art_43_2_c`
- `eu_reg_2016_679_art_43_2_d`
- `eu_reg_2016_679_art_43_2_e`
- `eu_reg_2016_679_art_43_4`
- `eu_reg_2016_679_art_43_7`

Article 42(3) is quoted only. It is in no Citations list and NOT in citation_vocabulary. citations.clausal holds one `citation(Key, Unit, Gloss)` fact per atom above, with its pinned unit id (for example `02016R0679-20160504#point_041.002_a`).

### Referral citations

This fixed map is one fact per judgement key, `referral_citation(Key, CitationKey)`:

| judgement key | citation |
|---------------|----------|
| certification_requirements_not_met | art_42_7 |
| code_prepared_by_body_representing_controllers_or_processors | art_40_2 |
| monitoring_body_independence_and_expertise_demonstrated | art_41_2_a |
| monitoring_body_no_conflict_of_interests_demonstrated | art_41_2_d |
| monitoring_body_actions_infringe_regulation | art_41_5 |
| certification_body_independence_and_expertise_demonstrated | art_43_2_a |
| certification_body_no_conflict_of_interests_demonstrated | art_43_2_e |
| certification_body_actions_infringe_regulation | art_43_7 |

Each citation shown is prefixed with `eu_reg_2016_679_`.

### Final citation lists

These are sets: each atom once, order not scored.

**certification_status:**
- `cite(eu_reg_2016_679_art_42_2)`
- `cite(eu_reg_2016_679_art_42_4)`
- `cite(eu_reg_2016_679_art_42_5)`
- `cite(eu_reg_2016_679_art_42_7)`
- `cite(eu_reg_2016_679_art_43_1)`

**code_monitoring_status:** `cite(...)` of each of:
- `eu_reg_2016_679_art_40_2`
- `eu_reg_2016_679_art_40_3`
- `eu_reg_2016_679_art_40_4`
- `eu_reg_2016_679_art_40_5`
- `eu_reg_2016_679_art_40_9`
- `eu_reg_2016_679_art_41_1`
- `eu_reg_2016_679_art_41_4`
- `eu_reg_2016_679_art_41_6`

**accreditation_status, monitoring_body:** `cite(...)` of each of:
- `eu_reg_2016_679_art_41_1`
- `eu_reg_2016_679_art_41_2`
- `eu_reg_2016_679_art_41_2_a`
- `eu_reg_2016_679_art_41_2_b`
- `eu_reg_2016_679_art_41_2_c`
- `eu_reg_2016_679_art_41_2_d`
- `eu_reg_2016_679_art_41_5`

**accreditation_status, certification_body:** `cite(...)` of each of:
- `eu_reg_2016_679_art_43_1`
- `eu_reg_2016_679_art_43_1_a`
- `eu_reg_2016_679_art_43_1_b`
- `eu_reg_2016_679_art_43_2`
- `eu_reg_2016_679_art_43_2_a`
- `eu_reg_2016_679_art_43_2_b`
- `eu_reg_2016_679_art_43_2_c`
- `eu_reg_2016_679_art_43_2_d`
- `eu_reg_2016_679_art_43_2_e`
- `eu_reg_2016_679_art_43_4`
- `eu_reg_2016_679_art_43_7`

## Public predicates (one line each: description + citation)

### Contract queries

- `certification_status(Profile, IssuedOn, CheckDate, Result, Citations)`: runs step 0 (`input_problems(ProblemsA)`). It then gives either `certification_result(Validity, Transfer)` with the five-citation list, or `indeterminate([Key])` / `needs_legal_review(...)` with `[]`. Citations: Regulation (EU) 2016/679 Articles 42(2), 42(4), 42(5), 42(7), 43(1).
- `code_monitoring_status(Profile, Result, Citations)`: runs step 0, then gives `code_result(Monitoring, Transfer)` with the eight-citation list, or a status that is not final, with `[]`. Citations: Articles 40(2), 40(3), 40(4), 40(5), 40(9), 41(1), 41(4), 41(6).
- `accreditation_status(Profile, Body, AccreditedOn, CheckDate, Result, Citations)`: runs step 0 (`input_problems(ProblemsC)`, with problems for body, accredited_on and check_date after those of the profile). It then runs one ladder chosen by Body and gives one accreditation atom with that Body's list, or a status that is not final, with `[]`. Citations: Articles 41(1), 41(2), 41(2)(a) to (d), 41(5); or Articles 43(1), 43(1)(a) and (b), 43(2), 43(2)(a) to (e), 43(4), 43(7).
- `gdpr_codes_and_certification_input_problems(Profile, Problems)`: the input check of the profile alone. It returns `[]` or problem terms:
  - `duplicate_key` or else `wrong_type`, in contract-key order;
  - then `unknown_key`, in first-occurrence order;
  - `[wrong_type(profile)]` for anything that is not an attribute list.
  It never fails and never raises. It reads no provision, so it has no citation.

### Facade (scaffold names kept)

- `decide_gdpr_codes_and_certification(Request, Verdict)`: gives `Verdict = gdpr_codes_and_certification_verdict(Result, Citations)` for the Request's contract query. Citations: as that query.
- `gdpr_codes_and_certification_status(Request, Result)`: the Result alone. Citations: as that query.
- `gdpr_codes_and_certification_checklist(Request, Checklist)`: this is query type #7, justification. Checklist is one `item(StepId, Outcome, cite(CitationKey))` per step of every part the Request runs, in step order. Outcome is the step outcome: `passed`, `decides(Atom)`, `open_by_absence(Key)` or `open_by_judgement(Key)`. EVERY item carries `cite(...)`, passed items included, as given by `step_citation/2` in the slice. An input-problem Request gives `[item(input_check, input_problems(Problems), cite(none))]`; `none` is not a citation atom and is documented as the no-provision marker.
- `gdpr_codes_and_certification_what_if(Request, Key, Value, Result)`: the Result of the Request after setting `attribute(Key, Value)` in its profile via `profile_set/3`. Citations: as that query.
- `gdpr_codes_and_certification_provision(CitationKey, Unit, Gloss)`: this is query type #1, factual lookup. It answers what the rules say about a provision: its pinned unit and a one-line gloss. It enumerates in citations order when CitationKey is unbound. Citation: the provision itself.
- `gdpr_codes_and_certification_ground_provision(Ground, CitationKey)`: this is also query type #1. It answers which provision states a given result atom (for example `withdrawal_required` gives `eu_reg_2016_679_art_42_7`). It is one fact per result atom.
- `gdpr_codes_and_certification_holding_ground(Request, Part, Ground)`: this is query type #4, enumeration (output mode). It enumerates EVERY step that DECIDES, as `Part`-`Ground`, once each in step order. This is beside the one-ground answer of reading (7), for the caller of Q8, and it never changes the contract answers. A malformed Request gives no solution.
- `gdpr_codes_and_certification_key_read(Query, Key)`: also query type #4. It enumerates the keys a query reads, in root_exports order. Query is `certification`, `code`, `accreditation_monitoring_body` or `accreditation_certification_body`. Citation: as that query.
- `gdpr_codes_and_certification_fixture(Name, Request, ExpectedResult)`: fixtures (fixtures.clausal), one per named case below.

## Planned reuse (manifest `uses:`)

- `formalize_lib`: `profile_get/3` (the ONLY profile reader; absence is `\+ profile_get(Profile, Key, _)`), `profile_set/3` (what_if), `attribute/2`, `item/3`.
  - assess/6 and check_tri/4 are NOT used. The order needs a first-ground ladder with judgement deferral (reading (21)), not a met/unmet/unknown checklist aggregate. The checklist engine's indeterminate shape is also not the contract's.
  - This choice is stated in the manifest so that R1 and C15 see no clone. The ladder outcome terms are distinct from item/3 statuses.
- `kit/deadline_lib`: `month_last_day/3`, for the real-day check and the month-end clamp of the LAST DAY. It is called only with Year from 1 to 9999.
  - deadline_months_after/3 is NOT used: it counts from the day after the anchor, which is not reading (19).
- `validate_props`: `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`, `bad_citation/1`, in the property test mode.
- `kit/query_combinators`: `diff_checklists/3`, used in the what-if test mode to show which step changes.
- `library(datetime)`: NOT imported for the arithmetic. The reasons are in NOTES, Engineering decisions: date/3 is unregistered, date/4 raises on invalid input, and the input check must never raise. The `date(Year, Month, Day)` term is kept, so that the move to native datetime is a drop-in once date/3 lands.
- No `_common` family-backbone predicate fits the first-ground deontic ladder. None is used.

## kernel.clausal — the shared floor (predicates shared by the slice, the queries and the facade)

The kernel has no statutory value. Every predicate has disjoint clause heads, with no `!`, `->` or `*->`. Ground outcomes are folded into the heads (C17).

### Dates

- `calendar_date_valid(Date)`: true for `date(Year, Month, Day)` with three integers, Year from the first to the last calendar year, Month from 1 to 12, and Day from 1 to `month_last_day(Year, Month, LastDay)`. The `integer/1` checks run first, so the predicate fails quietly, never raising, on any other term or on an unbound one.
- `date_triple_earlier(YearOne, MonthOne, DayOne, YearTwo, MonthTwo, DayTwo)`: true when the first triple is earlier, compared lexicographically (Year, then Month, then Day). It has three disjoint clauses: an earlier year; the same year and an earlier month; the same year and month and an earlier day.
- `date_earlier(DateOne, DateTwo)`: the same comparison over two valid date terms.
- `period_step(StartDate, CheckDate, Years, DecidingAtom, Outcome)`: computes LastYear = StartYear + Years.
  - If LastYear is above the last calendar year, the outcome is `passed`, without calling `month_last_day`.
  - Otherwise LastDay is the minimum of StartDay and the month's last day.
  - If CheckDate is later than (LastYear, StartMonth, LastDay), the outcome is `decides(DecidingAtom)`; if not, `passed`.
  - The heads are disjoint by arithmetic guards.
- `not_yet_step(StartDate, CheckDate, DecidingAtom, Outcome)`: `decides(DecidingAtom)` when CheckDate is earlier than StartDate, else `passed`.

### Step readers

Each is called only after the input check has passed, so there is at most one value per key.

- `crisp_step(Profile, Key, DecidingValue, DecidingAtom, Outcome)`: three clauses.
  - absent gives `open_by_absence(Key)`;
  - a value equal to DecidingValue gives `decides(DecidingAtom)`;
  - the other crisp value gives `passed`.
- `judgement_step(Profile, Key, DecidingValue, DecidingAtom, Outcome)`: four clauses. They are the three of crisp_step, plus `unsure` gives `open_by_judgement(Key)`.
- `enumeration_step(Profile, Key, DecidingValue, DecidingAtom, Outcome)`: absent gives `open_by_absence(Key)`; DecidingValue gives `decides(DecidingAtom)`; any other contract value gives `passed`.
- `all_step(Profile, Keys, DecidingAtom, Outcome)`: the outcome is the first of these that applies:
  - `decides(DecidingAtom)` if any key is false (`memberd`-free search, exactly one solution);
  - else `open_by_absence(FirstAbsentKey)`;
  - else `open_by_judgement(FirstUnsureKey)`;
  - else `passed`.
  It is built with helpers `first_absent_key(Profile, Keys, Key)` and `first_unsure_key(Profile, Keys, Key)` plus `no_false_key/2`, `no_absent_key/2` and `no_unsure_key/2`.

### Walking a ladder and combining parts

- `walk_ladder(Outcomes, Final, PartAnswer)`: HOW A LADDER IS READ. The helper is `walk_ladder(Outcomes, Remembered, Final, PartAnswer)`, with Remembered being `nothing_remembered` or `remembered(Key)`. The clauses:
  - `passed`: continue;
  - `decides(Atom)` with nothing remembered: `answer(Atom)`;
  - `decides(_)` with `remembered(Key)`: `judgement(Key)`;
  - `open_by_absence(Key)`: `absence(Key)`;
  - `open_by_judgement(Key)` with nothing remembered: continue, remembering Key;
  - `open_by_judgement(_)` with something remembered: continue;
  - `[]` with nothing remembered: `answer(Final)`;
  - `[]` with `remembered(Key)`: `judgement(Key)`.
  PartAnswer is one of `answer(Term)`, `absence(Key)` or `judgement(Key)`.
- `combine_parts(PartOne, PartTwo, Combined)`: ONE QUERY, ITS PARTS. The clauses, in order of precedence:
  - `absence` in the first part;
  - otherwise `absence` in the second part;
  - otherwise `judgement` in the first part;
  - otherwise `judgement` in the second part;
  - otherwise `answers(AnswerOne, AnswerTwo)`.
  Each clause is disjoint from the others by its pattern on the two arguments.
- `relied_pairs(Profile, ReadKeys, Pairs)`: THE PAIRS RULE. It gives `Key-Value` for each read key that is present, unsure included, in root_exports order. The order of ReadKeys is the contract order.

### Input check

- `profile_input_problems(Profile, Problems)`: THE INPUT CHECK.
  - `attribute_list_shape(Profile)` fails, without looping or raising, on a variable, a partial list, an unbound element, an element that is not `attribute/2`, or a compound key holding a variable.
  - Per contract key: count its occurrences (identical match), giving `duplicate_key`; otherwise `value_has_type(Key, Value)` fails, giving `wrong_type`.
  - Then unknown keys, deduplicated by `==`, in first-occurrence order.
  - The contract table is `contract_key(Key, Type)`, thirty facts in contract order, with the types `boolean`, `judgement`, `issuer` and `accrediting_entity`.
- `argument_problem(Name, Argument, Problems)`: gives `[]` or `[wrong_type(Name)]`, for date arguments (via `calendar_date_valid`) and for body.

## Slice — gdpr_codes_and_certification.clausal (self-contained)

### Statutory VALUE facts owned here (declared once, read with #Name)

- `:- constant_value(certification_maximum_period_years, 3).`: Article 42(7), 'a maximum period of three years'.
- `:- constant_value(certification_body_accreditation_maximum_period_years, 5).`: Article 43(4), 'a maximum period of five years'.
- The monitoring-body accreditation has no period: Article 41 states none (reading (16)).
- `monitoring_body_duty(Position, Duty)`: two facts in text order (Article 41(4)): `take_appropriate_action_on_infringement`, then `inform_supervisory_authority_of_actions_and_reasons`.
- Not statutory, held in parameters.clausal: `calendar_first_year` 1 and `calendar_last_year` 9999 (reading (19)). parameters.clausal holds only those two calendar bounds.

### Requirements, as ladders of step ids, in order

Each step is a `step_outcome(StepId, Context, Outcome)` clause using a kernel step reader, plus a `step_citation(StepId, CitationKey)` fact for the checklist.

**Certification VALIDITY** (final `within_maximum_period`):
1. `certification_check_date_before_issue`: `not_yet_step`, gives `not_yet_issued`. Article 42(7).
2. `certification_maximum_period`: `period_step` with `#certification_maximum_period_years`, gives `maximum_period_ended`. Article 42(7).
3. `certification_issuer_competent`: `enumeration_step` on `certification_issuer`; `other_issuer` gives `not_issued_by_competent_issuer`. Article 42(5).
4. `certification_body_accredited_at_check_date`: `crisp_step`; false gives `not_issued_by_competent_issuer`. It applies only when the issuer value is `certification_body`, otherwise `passed`; two disjoint clauses on the issuer value. Articles 42(5) and 43(1).
5. `certification_criteria_approved`: false gives `criteria_not_approved`. Article 42(5).
6. `supervisory_authority_informed`: false gives `issued_without_informing_supervisory_authority`. Gated like step 4. Article 43(1).
7. `certification_withdrawn`: true gives `withdrawn`. Article 42(7).
8. `certification_requirements_not_met`: `judgement_step`; true gives `withdrawal_required`. Article 42(7).

**Certification TRANSFER** (final `transfer_conditions_met`):
1. `certification_holder_outside_regulation`: false gives `not_relied_on_for_transfers`. Article 42(2).
2. `certification_transfer_conditions`: `all_step` over [certification_criteria_approved, certification_holder_binding_commitments_made], giving `transfer_conditions_not_met`. Article 42(2).

**Code MONITORING** (final `monitoring_by_accredited_body(Duties)`, Duties built from the `monitoring_body_duty` facts):
1. `processing_by_public_authority`: true gives `article_41_not_applicable`. Article 41(6).
2. `code_prepared_by_representative_body`: `judgement_step`; false gives `not_a_code_under_article_40_2`. Article 40(2).
3. `code_approved`: false gives `code_not_approved`. Article 40(5).
4. `code_monitoring_mechanisms`: false gives `monitoring_mechanisms_missing`. Article 40(4).
5. `monitoring_body_accredited`: false gives `no_accredited_monitoring_body`. Article 41(1); duties Article 41(4).

**Code TRANSFER** (final `transfer_conditions_met`):
1. `code_adherent_outside_regulation`: false gives `not_relied_on_for_transfers`. Article 40(3).
2. `code_transfer_conditions`: `all_step` over [code_approved_by_competent_supervisory_authority, code_has_general_validity, code_adherent_binding_commitments_made], giving `transfer_conditions_not_met`. Articles 40(3) and 40(9).

**Monitoring-body accreditation** (final `accreditation_conditions_met`):
1. `monitoring_body_check_date_before_accreditation`: `not_yet_step`, gives `not_yet_accredited`. Article 41(1).
2. `monitoring_body_accreditation_revoked`: true gives `accreditation_revoked`. Article 41(5).
3. `monitoring_body_accreditation_points`: `all_step` over the four Article 41(2) keys in contract order, giving `accreditation_conditions_not_met`. Article 41(2)(a) to (d).
4. `monitoring_body_actions_infringe`: `judgement_step`; true gives `revocation_required`. Article 41(5).

**Certification-body accreditation** (final `accreditation_conditions_met`):
1. `certification_body_check_date_before_accreditation`: gives `not_yet_accredited`. Article 43(1).
2. `certification_body_accreditation_maximum_period`: `period_step` with `#certification_body_accreditation_maximum_period_years`, gives `maximum_period_ended`. Article 43(4).
3. `certification_body_accreditation_revoked`: true gives `accreditation_revoked`. Article 43(7).
4. `certification_body_accrediting_entity_named`: `enumeration_step`; `other_entity` gives `not_accredited_by_entity_named_in_article_43_1`. Article 43(1)(a) and (b).
5. `certification_body_accreditation_points`: `all_step` over the five Article 43(2) keys, giving `accreditation_conditions_not_met`. Article 43(2)(a) to (e).
6. `certification_body_actions_infringe`: `judgement_step`; true gives `revocation_required`. Article 43(7).

### Slice predicates

- `ladder_outcomes(Ladder, Context, Outcomes)`: evaluates every step of a ladder.
- `ladder_final(Ladder, Final)`
- `ladder_read_keys(Query, Keys)`: for PAIRS and key_read.
- `query_citations(Query, Citations)`
- `ground_provision/2` facts.

### Shared with another slice

NONE. There is only one slice. Everything listed under kernel.clausal is domain-neutral machinery used by the slice and by queries.clausal; no legal content is in the kernel.

## queries.clausal

This file implements the four contract queries from the kernel and slice.

- Step 0 is a disjoint pair of clauses:
  - the problems list is non-empty: give `input_problems(Problems)` and `[]`;
  - the problems list is `[]`: run the parts, then pass the combined part answers to `query_result(Query, Profile, Combined, Result, Citations)`.
- `query_result` has three clauses:
  - `absence(Key)` gives `indeterminate([Key])` and `[]`;
  - `judgement(Key)` gives `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])` and `[]`, with CitationKey from `referral_citation/2`;
  - `answers(...)` gives the final compound with `query_citations/2`.
- One-part accreditation uses `combine_one(PartAnswer, Combined)`.

## fixtures.clausal (named cases; each one of the seven test modes reads them)

**Certification**
- `certification_in_force`: issuer `competent_supervisory_authority`, all certification keys set, holder not outside the Regulation. Gives `certification_result(within_maximum_period, not_relied_on_for_transfers)`.
- `certification_leap_day_last_day`: IssuedOn `date(2024, 2, 29)`, CheckDate `date(2027, 2, 28)`. Gives `within_maximum_period`. The same case with `date(2027, 3, 1)` gives `maximum_period_ended`.
- `certification_withdrawn_but_transfer_met`: gives `certification_result(withdrawn, transfer_conditions_met)` (Q9).
- `certification_issuer_absent`: gives `indeterminate([certification_issuer])`, with no gated key named.
- `certification_requirements_unsure_then_absent`: the judgement is unsure and a later key is absent. Gives `indeterminate([...])`, because <<DNUM>> names the absent key first.
- `certification_requirements_unsure`: gives `needs_legal_review(open_textured(certification_requirements_not_met, cite(eu_reg_2016_679_art_42_7)), [inputs_relied_on(Pairs)])`.

**Code**
- `code_public_authority`: gives `code_result(article_41_not_applicable, ...)`.
- `code_monitored`: gives `code_result(monitoring_by_accredited_body([take_appropriate_action_on_infringement, inform_supervisory_authority_of_actions_and_reasons]), transfer_conditions_met)`.

**Accreditation**
- `monitoring_body_point_false`: gives `accreditation_conditions_not_met`.
- `monitoring_body_infringing`: gives `revocation_required`.
- `certification_body_other_entity`: gives `not_accredited_by_entity_named_in_article_43_1`.
- `certification_body_five_years_ended`: gives `maximum_period_ended`.
- `certification_body_period_beyond_calendar`: AccreditedOn `date(9998, 1, 1)` gives step `passed`, with no error.

**Input check**
- `input_duplicate_and_unknown`: gives `input_problems([duplicate_key(...), unknown_key(...)])`.
- `input_attested_value`: gives `wrong_type(Key)`.
- `input_unbound_profile`: gives `[wrong_type(profile)]`.
- `input_bad_dates_and_body`: gives the profile problems, then `wrong_type(body)`, `wrong_type(accredited_on)`, `wrong_type(check_date)`.

### Seven test modes

1. load
2. fixtures (exact Result, compared with findall and length 1, for the counting rule)
3. per-step tests (each paired with a positive)
4. boundary (period last day, leap day, Year 9999)
5. missing-key coverage (every key named exactly where THE LIMBS name it)
6. properties via validate_props (totality, determinism, citation completeness)
7. what-if (unread keys never change an answer; diff_checklists)

The manifest `referrals:` block lists, per judgement key, the rows with `inputs` as the stated minimum and points to THE PAIRS RULE.
