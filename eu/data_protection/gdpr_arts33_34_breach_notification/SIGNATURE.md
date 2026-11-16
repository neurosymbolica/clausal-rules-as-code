# SIGNATURE — eu/data_protection/gdpr_arts33_34_breach_notification

## Public query surface

The called contract has seven predicates.

- `authority_notification_deadline/3`
- `authority_notification_period_end/3`
- `notification_obligation/2`
- `breach_notification_verdict/4`
- `authority_notification_content_check/2`
- `data_subject_communication_check/2`
- `gdpr_arts33_34_breach_notification_input_problems/2`

The package facade adds five predicates. They wrap the verdict over the request term verdict_request(Profile, HoursElapsed).

- `decide_breach_notification_verdict/2`
- `breach_notification_verdict_status/2`
- `breach_notification_verdict_checklist/2`
- `gdpr_arts33_34_breach_notification_what_if/4`
- `gdpr_arts33_34_breach_notification_fixture/2`

The contract predicate names are fixed by the INTERFACE. They keep their names without the package prefix. Only the input check carries the prefix.

**Profile.** PROFILE is an attribute list [attribute(Key, Value), ...] of the twenty-five keys below. It is read only with profile_get/3, profile_has/2 and profile_lacks/2.

**Totality.** Every query is total over ground inputs. Malformed input gives input_problems(Problems).

**Determinism.** Every query yields exactly ONE solution. The scorer collects every solution (COUNTING), so this is required, not optional. Determinism comes from disjoint clause heads and guards, never from a cut, `->`, once/1 or a findall-dedup.

**Imported figures.** No statutory figure is imported. The 72 hours and the 24-hour day are declared once, in the slice.

## Status atoms (replacing the scaffold placeholders satisfied / not_satisfied)

### VERDICT of breach_notification_verdict/4

Final verdicts:

- `eligible`
- `ineligible`
- `notification_requirement_not_met(without_undue_delay)`
- `notification_requirement_not_met(reasons_for_delay)`

Non-final statuses:

- `indeterminate(MissingKeys)`
- `needs_legal_review(open_textured(Key, cite(CitationKey)), Context)`
- `input_problems(Problems)`

### OBLIGATION of notification_obligation/2

A final OBLIGATION is ONE non-empty list built from these duty terms:

- `no_notification_required(cite(eu_reg_2016_679_art_33_1))`
- `notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1))`
- `notify_controller(cite(eu_reg_2016_679_art_33_2))`
- `document_breach(cite(eu_reg_2016_679_art_33_5))`
- `communicate_to_data_subject(cite(eu_reg_2016_679_art_34_1))`
- `communicate_to_data_subject(cite(eu_reg_2016_679_art_34_4))`
- `no_communication_required(cite(eu_reg_2016_679_art_34_3_a))`
- `no_communication_required(cite(eu_reg_2016_679_art_34_3_b))`
- `no_communication_required(cite(eu_reg_2016_679_art_34_4))`
- `public_communication_or_similar_measure(cite(eu_reg_2016_679_art_34_3_c))`
- `public_communication_or_similar_measure(cite(eu_reg_2016_679_art_34_4))`

Otherwise OBLIGATION is the status compound alone: indeterminate/1, needs_legal_review/2 or input_problems/1.

### RESULT of the two content checks

Final results:

- `all_requirements_met`
- `requirements_not_met(Items)`
- `information_to_follow_in_phases(Items)` (authority notification only)

Otherwise RESULT is a status.

Item atoms of authority_notification_content_check/2, in this order:

- `nature_of_breach`
- `categories_and_approximate_numbers`
- `contact_point`
- `likely_consequences`
- `measures_taken_or_proposed`
- `mitigation_measures`

Item atoms of data_subject_communication_check/2, in this order:

- `without_undue_delay`
- `nature_of_breach_in_clear_and_plain_language`
- `contact_point`
- `likely_consequences`
- `measures_taken_or_proposed`
- `mitigation_measures`

### DEADLINE and PERIOD_END

- DEADLINE is `date(Year, Month, Day)`, each element a bare integer, or `input_problems([wrong_type(awareness_date)])`.
- PERIOD_END is `period_end(date(Year, Month, Day), EndHour)` or `input_problems(Problems)`.

### Problem terms

- `duplicate_key(Key)`
- `wrong_type(Key)`
- `unknown_key(Key)`
- `contradictory_inputs([KeyOne, KeyTwo])`
- `wrong_type(profile)`
- `wrong_type(awareness_date)`
- `wrong_type(awareness_hour)`
- `wrong_type(hours_elapsed)`

### Context terms

- `inputs_relied_on(Pairs)`, where Pairs is a list of Key-Value pairs.
- `provenance/2` is exported but never produced (the working notes (not published)).

### verdict_vocabulary pins

The atoms pinned in verdict_vocabulary:

- the verdict atoms: eligible, ineligible, without_undue_delay, reasons_for_delay;
- the result atom: all_requirements_met;
- the item atoms, each once: nature_of_breach, categories_and_approximate_numbers, contact_point, likely_consequences, measures_taken_or_proposed, mitigation_measures, nature_of_breach_in_clear_and_plain_language;
- the enumeration atoms: controller, processor, no_decision, required_communication, decided_point_a_condition_met, decided_point_b_condition_met, decided_point_c_condition_met;
- the judgement atom unsure.

The atoms true and false are NEVER pinned. The bare atom indeterminate is never written.

## Profile keys (input_contract and root_exports order)

| # | Key | Kind | Values | Source |
|---|---|---|---|---|
| 1 | breach_unlikely_to_result_in_risk | judgement | true, false, unsure | Art 33(1) |
| 2 | breach_likely_to_result_in_high_risk | judgement | true, false, unsure | Art 34(1) |
| 3 | delay_justified_by_reasons | judgement | true, false, unsure | Art 33(1) second sentence |
| 4 | party_role | enumeration | controller, processor | Art 33(1), 33(2) |
| 5 | notification_made_without_undue_delay | judgement | true, false, unsure | Art 33(1) |
| 6 | notification_accompanied_by_reasons_for_delay | crisp | true, false | Art 33(1) second sentence |
| 7 | supervisory_authority_decision_on_communication | enumeration | no_decision, required_communication, decided_point_a_condition_met, decided_point_b_condition_met, decided_point_c_condition_met | Art 34(4) |
| 8 | appropriate_protection_measures_applied_to_affected_data | judgement | true, false, unsure | Art 34(3)(a) |
| 9 | subsequent_measures_ensure_high_risk_no_longer_likely | judgement | true, false, unsure | Art 34(3)(b) |
| 10 | communication_would_involve_disproportionate_effort | judgement | true, false, unsure | Art 34(3)(c) |
| 11 | notification_describes_nature_of_breach | crisp | true, false | Art 33(3)(a) |
| 12 | notification_gives_categories_and_approximate_numbers | crisp | true, false | Art 33(3)(a) |
| 13 | categories_and_approximate_numbers_possible | judgement | true, false, unsure | Art 33(3)(a) |
| 14 | notification_gives_contact_point | crisp | true, false | Art 33(3)(b) |
| 15 | notification_describes_likely_consequences | crisp | true, false | Art 33(3)(c) |
| 16 | notification_describes_measures_taken_or_proposed | crisp | true, false | Art 33(3)(d) |
| 17 | notification_describes_mitigation_measures | crisp | true, false | Art 33(3)(d) |
| 18 | mitigation_measures_appropriate | judgement | true, false, unsure | Art 33(3)(d) |
| 19 | information_not_possible_to_provide_at_the_same_time | judgement | true, false, unsure | Art 33(4) |
| 20 | communication_made_without_undue_delay | judgement | true, false, unsure | Art 34(1) |
| 21 | communication_describes_nature_in_clear_and_plain_language | judgement | true, false, unsure | Art 34(2) |
| 22 | communication_gives_contact_point | crisp | true, false | Art 34(2) with Art 33(3)(b) |
| 23 | communication_describes_likely_consequences | crisp | true, false | Art 34(2) with Art 33(3)(c) |
| 24 | communication_describes_measures_taken_or_proposed | crisp | true, false | Art 34(2) with Art 33(3)(d) |
| 25 | communication_describes_mitigation_measures | crisp | true, false | Art 34(2) with Art 33(3)(d) |

The keys fall into three kinds:

- twelve judgement keys: 1, 2, 3, 5, 8, 9, 10, 13, 18, 19, 20, 21;
- eleven crisp keys: 6, 11, 12, 14, 15, 16, 17, 22, 23, 24, 25;
- two enumeration keys: 4 and 7.

No key is numeric. No key is a date.

### Arguments (not profile keys)

- `awareness_date`: AWARE, a `date(Year, Month, Day)` of a real UTC calendar day.
- `awareness_hour`: AWARENESS_HOUR, an integer from 0 to 23.
- `hours_elapsed`: HOURS_ELAPSED, a non-negative integer of begun hours, rounded UP.
- `profile`: names the whole PROFILE argument in wrong_type(profile).

### input_contract

- The profile is typed as an attribute_list of the 25 keys, with kinds judgement, crisp or enumeration(Atoms).
- The arguments are typed as: awareness_date as date; awareness_hour as non_negative_integer, with the bound 23 from the prose; hours_elapsed as non_negative_integer.
- contradictory_combinations has two rows:
  - [attribute(breach_unlikely_to_result_in_risk, true), attribute(breach_likely_to_result_in_high_risk, true)];
  - [attribute(delay_justified_by_reasons, true), attribute(notification_accompanied_by_reasons_for_delay, false)].

## Citation keys (canonical lexicon scheme, citation_vocabulary)

Each key is spelled exactly as given. Keys are never shortened.

| Key | Unit | Used by |
|---|---|---|
| eu_reg_2016_679_art_33_1 | 02016R0679-20160504#parag_033.001 | verdict CITES; Art 33(1) duty terms; referrals on J1, notification_made_without_undue_delay and delay_justified_by_reasons |
| eu_reg_2016_679_art_33_2 | #parag_033.002 | notify_controller |
| eu_reg_2016_679_art_33_3_a | #parag_033.003, point (a) | referral on categories_and_approximate_numbers_possible |
| eu_reg_2016_679_art_33_3_d | #parag_033.003, point (d) | referral on mitigation_measures_appropriate, in both checks |
| eu_reg_2016_679_art_33_4 | #parag_033.004 | referral on information_not_possible_to_provide_at_the_same_time |
| eu_reg_2016_679_art_33_5 | #parag_033.005 | document_breach |
| eu_reg_2016_679_art_34_1 | #parag_034.001 | communicate_to_data_subject when reached through step 4; referrals on J2 and communication_made_without_undue_delay |
| eu_reg_2016_679_art_34_2 | #parag_034.002 | referral on communication_describes_nature_in_clear_and_plain_language |
| eu_reg_2016_679_art_34_3_a | #point_034.003_a | no_communication_required (a); referral on A |
| eu_reg_2016_679_art_34_3_b | #point_034.003_b | no_communication_required (b); referral on B |
| eu_reg_2016_679_art_34_3_c | #point_034.003_c | public_communication_or_similar_measure (c); referral on C |
| eu_reg_2016_679_art_34_4 | #parag_034.004 | every authority-decided Art 34 term |

**Regulation No 1182/71 Art 3.** It governs the period rule, but no scored output cites it. Its articles are recorded in citations.clausal only under the keys that _lexicon/citations.yaml already holds for 31971R1182 Art 3(1), 3(2)(a), 3(3) and 3(4). If the lexicon holds no such key, the rule is documented in comments and the working notes (not published) only. No key is invented.

## Public predicates

- `authority_notification_deadline(AwarenessDate, Deadline, Hours)`: Deadline is the date(Year, Month, Day) three calendar days after AwarenessDate, never shifted for a non-working day. Hours is always 72. A malformed AwarenessDate gives input_problems([wrong_type(awareness_date)]) with Hours 72. One solution. + cite(eu_reg_2016_679_art_33_1); Regulation No 1182/71 Art 3(1), 3(2)(a), 3(3), 3(4).
- `authority_notification_period_end(AwarenessDate, AwarenessHour, PeriodEnd)`: PeriodEnd is period_end(Day, EndHour), with Day as AwarenessDate plus three days and EndHour as AwarenessHour + 1, from 1 to 24. Otherwise it is input_problems with wrong_type(awareness_date) and then wrong_type(awareness_hour). One solution. + cite(eu_reg_2016_679_art_33_1); Regulation No 1182/71 Art 3(1), 3(2)(a).
- `notification_obligation(Profile, Obligation)`: ONE list of duty terms in article order, or a status. + cite(eu_reg_2016_679_art_33_1), _33_2, _33_5, _34_1, _34_3_a, _34_3_b, _34_3_c, _34_4.
- `breach_notification_verdict(Profile, HoursElapsed, Verdict, Citations)`: scores the controller's Art 33(1) notification. Citations is [cite(eu_reg_2016_679_art_33_1)] for every final verdict and [] for every status. + cite(eu_reg_2016_679_art_33_1).
- `authority_notification_content_check(Profile, Result)`: checks the notification against Art 33(3)(a) to (d) and Art 33(4). + cite(eu_reg_2016_679_art_33_3_a), _33_3_d, _33_4.
- `data_subject_communication_check(Profile, Result)`: checks the communication against the Art 34(1) timing and Art 34(2). + cite(eu_reg_2016_679_art_34_1), _34_2, _33_3_d.
- `gdpr_arts33_34_breach_notification_input_problems(Profile, Problems)`: the typed input check, giving [] when the profile is well formed. One solution. + the input_contract.
- `decide_breach_notification_verdict(Request, Decision)`: Request is verdict_request(Profile, HoursElapsed). Decision is breach_notification_verdict(Verdict, Citations), taken from breach_notification_verdict/4. + cite(eu_reg_2016_679_art_33_1).
- `breach_notification_verdict_status(Request, Verdict)`: the Verdict alone. + cite(eu_reg_2016_679_art_33_1).
- `breach_notification_verdict_checklist(Request, Checklist)`: the cited checklist of the eligibility query (#2), a list of item(RequirementId, Status, Citation) built with eval_requirements/4. The checklist is [] when there are input problems. + cite(eu_reg_2016_679_art_33_1).
- `gdpr_arts33_34_breach_notification_what_if(Request, Key, Value, Verdict)`: the Verdict for the request with attribute(Key, Value) put in place of Key through profile_set/3. + cite(eu_reg_2016_679_art_33_1).
- `gdpr_arts33_34_breach_notification_fixture(Name, Request)`: the named fixtures in fixtures.clausal (see Fixtures).

## Result constructors (exported, never called as queries)

- input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, contradictory_inputs/1
- no_notification_required/1, notify_supervisory_authority/1, notify_controller/1, document_breach/1
- communicate_to_data_subject/1, no_communication_required/1, public_communication_or_similar_measure/1
- notification_requirement_not_met/1, period_end/2, requirements_not_met/1, information_to_follow_in_phases/1
- indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2

The facade also exports breach_notification_verdict/2 and verdict_request/2.

## Planned reuse (manifest uses:)

**Used**

- **formalize_lib**:
  - profile access: profile_get/3, profile_has/2, profile_lacks/2, profile_set/3, missing_keys/3;
  - list helpers: memberd/2, not_member/2;
  - the checklist engine: eval_requirements/4, called with the closure requirement_at(HoursElapsed);
  - terms: item/3, attribute/2;
  - status vocabulary: met, unmet/1, unknown/1, inapplicable.
- **library(datetime)**:
  - timedelta/3 and date_add/3, for AWARE plus three days;
  - date/4, to build and take apart the native date object; if P2 finds date/4 does not decompose an object, date_string_iso/2 is used instead.
- **kit/deadline_lib**: month_last_day/3, to validate a real calendar day.
- **validate_props** (tests only): run_props/1, prop_totality/3, prop_determinism/3, prop_citation_complete/3, prop_boundary_coverage/2 (HOURS_ELAPSED 72 and 73), prop_missing_key_coverage/3, bad_citation/1.

**Considered and not used**

- check_tri/4 and check_tri_neg/4: they collapse unsure into absent. The limbs need four states and produce no Kleene status, so this is not a C15 clone.
- assess/6: the verdict has statuses outside a checklist.
- kit/compliance_lib: no modality lattice; the duties form a fixed list.
- deadline_lib deadline/4: the native-datetime idiom is used instead.
- kit/query_combinators what_if/5: it works on dicts; the profile is an attribute list.
- rolling_window: not relevant.
- currency_vocab, vat_category, country: not relevant.

**_common family backbone**

None is required. If the temporal _common exposes an end-of-hours-period helper, P2 adopts it in place of the slice's arithmetic.

## File layout (unchanged names)

- **kernel.clausal** (shared floor):
  - contract_key(Position, Key, Kind) facts in root_exports order;
  - contract_keys_in_order/1;
  - key_state(Profile, Key, State), with State not_present or present(Value);
  - attribute_list/1;
  - profile_input_problems/2: duplicate keys, then type, then unknown keys, then contradictions;
  - contradictory_pair/4 facts;
  - the argument checks real_calendar_day/1, awareness_date_problems/2, awareness_hour_problems/2 and hours_elapsed_problems/2, with the clock bounds lowest_awareness_hour 0 and highest_awareness_hour 23 and the calendar years 1 to 9999;
  - relied_pairs(Profile, Keys, Pairs);
  - first_unsure_key(Profile, Keys, Key);
  - keys_in_contract_order/2, which sorts a key list by contract position.
- **citations.clausal**: citation_vocabulary, one citation(Key, Instrument, Unit) fact per key in the citation table.
- **parameters.clausal**: source pins only, source_version(gdpr, '02016R0679-20160504') and source_version(regulation_1182_1971, '31971R1182'). No statutory figure lives here.
- **breach_notification_verdict.clausal**: the slice, below.
- **queries.clausal**: the seven contract predicates as thin exports of the slice.
- **fixtures.clausal**: the named requests, below.
- **package facade**: re-exports, plus decide, status, checklist, what_if and fixture.

## Slice: breach_notification_verdict.clausal

The slice is self-contained for the breach-notification determination. It holds four determinations:

- the timing (deadline and period end);
- the eligibility verdict;
- the obligation list;
- the two content checks.

### Value facts owned (declared once here)

- `:- constant_value(authority_notification_period_hours, 72).` cite(eu_reg_2016_679_art_33_1).
- `:- constant_value(hours_per_calendar_day, 24).` The day of Regulation No 1182/71 Art 3(2)(a) arithmetic.

Derived arithmetic:

- period_calendar_days(Days): Days is constant(authority_notification_period_hours) // constant(hours_per_calendar_day), which is 3.
- A slice test asserts that the remainder is 0. That remainder is why the end hour is the same full hour as the end of the hour of awareness.
- period_end_hour(AwarenessHour, EndHour): EndHour is AwarenessHour + 1.
- Within the period: HoursElapsed =< constant(authority_notification_period_hours).
- Beyond the period: HoursElapsed > constant(authority_notification_period_hours).

### Rules — timing

**T1. Deadline.**

1. When awareness_date_problems(AwarenessDate, []) holds:
   - build the native object with date/4;
   - timedelta(Days, 0, Delta);
   - date_add(Object, Delta, DeadlineObject);
   - decompose DeadlineObject to date(Year, Month, Day);
   - Hours is constant(authority_notification_period_hours).
2. When the problems are [wrong_type(awareness_date)]: Deadline is input_problems([wrong_type(awareness_date)]) and Hours is 72.

**T2. Period end.**

- Problems is the date problems appended to the hour problems check.
- [] gives period_end(DeadlineDay, EndHour).
- A non-empty list gives input_problems(Problems).

The deadline day is never shifted. No holiday fact is read.

### Rules — breach_notification_verdict/4

Let J1 = breach_unlikely_to_result_in_risk.

Problems is the profile problems followed by hours_elapsed_problems. The clauses are disjoint. Each folds its ground verdict into its head.

| Route | Condition | Verdict | Citations |
|---|---|---|---|
| V0 | Problems non-empty | input_problems(Problems) | [] |
| V1 | J1 not_present | indeterminate([breach_unlikely_to_result_in_risk]) | [] |
| V2 | J1 true, any HoursElapsed | ineligible | [cite(eu_reg_2016_679_art_33_1)] |
| V3 | J1 false or unsure, within period, notification_made_without_undue_delay not_present | indeterminate([notification_made_without_undue_delay]) | [] |
| V4 | J1 unsure, within period, undue-delay key present | needs_legal_review(open_textured(breach_unlikely_to_result_in_risk, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([breach_unlikely_to_result_in_risk-unsure])]) | [] |
| V5 | J1 false, within period, undue unsure | needs_legal_review(open_textured(notification_made_without_undue_delay, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([hours_elapsed-HoursElapsed, breach_unlikely_to_result_in_risk-false, notification_made_without_undue_delay-unsure])]) | [] |
| V6 | J1 false, within period, undue true | eligible | [cite(eu_reg_2016_679_art_33_1)] |
| V7 | J1 false, within period, undue false | notification_requirement_not_met(without_undue_delay) | [cite(eu_reg_2016_679_art_33_1)] |
| V8 | J1 false or unsure, beyond period, notification_accompanied_by_reasons_for_delay not_present | indeterminate([notification_accompanied_by_reasons_for_delay]) | [] |
| V9 | J1 unsure, beyond period, reasons false | the J1 referral of V4 | [] |
| V10 | J1 false, beyond period, reasons false | notification_requirement_not_met(reasons_for_delay) | [cite(eu_reg_2016_679_art_33_1)] |
| V11 | J1 false or unsure, beyond period, reasons true, delay_justified_by_reasons not_present | indeterminate([delay_justified_by_reasons]) | [] |
| V12 | J1 unsure, beyond period, reasons true, delay present | the J1 referral of V4 | [] |
| V13 | J1 false, beyond period, reasons true, delay true | eligible | [cite(eu_reg_2016_679_art_33_1)] |
| V14 | J1 false, beyond period, reasons true, delay false or unsure | needs_legal_review(open_textured(delay_justified_by_reasons, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([hours_elapsed-HoursElapsed, breach_unlikely_to_result_in_risk-false, delay_justified_by_reasons-Value])]) | [] |

The verdict does not read J2, party_role, the authority decision or any Art 34 key.

### Rules — notification_obligation/2

Let J1 = breach_unlikely_to_result_in_risk, J2 = breach_likely_to_result_in_high_risk and AUTHORITY = supervisory_authority_decision_on_communication.

Let A, B and C be appropriate_protection_measures_applied_to_affected_data, subsequent_measures_ensure_high_risk_no_longer_likely and communication_would_involve_disproportionate_effort.

**O0.** Profile problems non-empty: input_problems(Problems).

**O1.** party_role:

- not_present: indeterminate([party_role]);
- processor: [notify_controller(cite(eu_reg_2016_679_art_33_2))];
- controller: go on to O2.

**O2.** missing_keys(Profile, [J1, AUTHORITY], Missing) with Missing non-empty: indeterminate(Missing), in root_exports order.

**O3.** communication_stage(Profile, J1Value, AuthorityValue, Stage). One clause per route:

- AUTHORITY is required_communication: authority_term(communicate_to_data_subject(cite(eu_reg_2016_679_art_34_4))).
- AUTHORITY is decided_point_a_condition_met or decided_point_b_condition_met: authority_term(no_communication_required(cite(eu_reg_2016_679_art_34_4))).
- AUTHORITY is decided_point_c_condition_met: authority_term(public_communication_or_similar_measure(cite(eu_reg_2016_679_art_34_4))).
- AUTHORITY no_decision and J1 true: no_term.
- AUTHORITY no_decision and J1 false or unsure:
  - J2 not_present: absent_key(breach_likely_to_result_in_high_risk);
  - J2 false: no_term;
  - J2 true or unsure: the exemption stage.

**O4.** exemption_stage(Profile, Stage). The routes are disjoint over the states of A, B and C:

1. A true: exemption_term(no_communication_required(cite(eu_reg_2016_679_art_34_3_a))).
2. A not true and B true: exemption_term(no_communication_required(cite(eu_reg_2016_679_art_34_3_b))).
3. A not_present and B not true: absent_key(A).
4. A false or unsure, and B not_present: absent_key(B).
5. A and B false or unsure, and C not_present: absent_key(C).
6. A and B false or unsure, C present, and at least one of A, B and C unsure: exemption_open.
7. A false, B false, C true: exemption_term(public_communication_or_similar_measure(cite(eu_reg_2016_679_art_34_3_c))).
8. A false, B false, C false: exemption_term(communicate_to_data_subject(cite(eu_reg_2016_679_art_34_1))).

**O5.** A stage absent_key(Key) gives indeterminate([Key]). Only that key is named.

**O6.** The referral judgements, in root order:

- J1;
- J2, when AUTHORITY is no_decision and J1 is not true;
- A, B and C, only when the stage is exemption_open.

first_unsure_key over this list gives the referring Key. The result is needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]).

- Citation is cite(eu_reg_2016_679_art_33_1) for J1, cite(eu_reg_2016_679_art_34_1) for J2, and _34_3_a, _34_3_b or _34_3_c for A, B or C.
- Pairs is relied_pairs over the list prefix up to and including Key.

**O7.** No key is unsure. The final list is:

[Article33Term, document_breach(cite(eu_reg_2016_679_art_33_5)) | Article34Terms]

- Article33Term is no_notification_required(cite(eu_reg_2016_679_art_33_1)) when J1 is true, and notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)) when J1 is false.
- Article34Terms is:
  - [Term] for authority_term(Term) or exemption_term(Term);
  - [] for no_term.

### Rules — authority_notification_content_check/2

item_state(Profile, Item, State) gives one State per item: ruled_out, included, awaiting_key(Key) or awaiting_judgement(Key).

nature_of_breach, contact_point, likely_consequences and measures_taken_or_proposed each depend on one crisp key:

- crisp not_present: awaiting_key(crisp);
- crisp false: included;
- crisp true: ruled_out.

categories_and_approximate_numbers depends on keys 12 and 13:

- 13 present false: ruled_out;
- otherwise 12 true: ruled_out;
- 12 not_present: awaiting_key(12);
- 12 false and 13 not_present: awaiting_key(13);
- 12 false and 13 true: included;
- 12 false and 13 unsure: awaiting_judgement(13).

mitigation_measures follows the same pattern with keys 17 and 18.

An item COULD BE INCLUDED when its State is not ruled_out.

**C0. Problems.** Profile problems non-empty: input_problems(Problems).

**C1. Absent keys.** Collect every awaiting_key key.

- Add information_not_possible_to_provide_at_the_same_time when it is not_present and either some item is included or at least two items could be included.
- A non-empty set gives indeterminate(keys_in_contract_order(Set)).

**C2. The phases key behind one unsure judgement.** When:

- the phases key is not_present;
- exactly one item could be included;
- that item is awaiting_judgement;

the result is indeterminate([information_not_possible_to_provide_at_the_same_time]).

**C3. Referral on an item judgement.** first_unsure_key over the read judgements, in root order:

- key 13, when key 12 is present false;
- key 18, when key 17 is present false.

The result is needs_legal_review(open_textured(Key, cite(eu_reg_2016_679_art_33_3_a) or cite(eu_reg_2016_679_art_33_3_d)), [inputs_relied_on(Pairs)]). Pairs is the prefix up to and including Key (the working notes (not published)).

**C4.** Items is the included items, in item order. An empty list gives all_requirements_met.

**C5.** Items non-empty reads the phases key:

- unsure: needs_legal_review(open_textured(information_not_possible_to_provide_at_the_same_time, cite(eu_reg_2016_679_art_33_4)), [inputs_relied_on(Pairs)]). Pairs is the carried 13 and 18 values followed by information_not_possible_to_provide_at_the_same_time-unsure.
- true: information_to_follow_in_phases(Items).
- false: requirements_not_met(Items).

### Rules — data_subject_communication_check/2

The states follow the same pattern.

- without_undue_delay (key 20) and nature_of_breach_in_clear_and_plain_language (key 21) are judgement items:
  - not_present: awaiting_key;
  - false: included;
  - true: ruled_out;
  - unsure: awaiting_judgement.
- contact_point, likely_consequences and measures_taken_or_proposed depend on the crisp keys 22, 23 and 24.
- mitigation_measures depends on keys 25 and 18:
  - 18 present false: ruled_out;
  - otherwise 25 true: ruled_out;
  - 25 not_present: awaiting_key(25);
  - 25 false and 18 not_present: awaiting_key(18);
  - 25 false and 18 true: included;
  - 25 false and 18 unsure: awaiting_judgement(18).

**S0. Problems.** Profile problems non-empty: input_problems(Problems).

**S1. Absent keys.** All awaiting_key keys, in root_exports order. Key 18 sorts BEFORE key 20.

**S2. Referral.** first_unsure_key over the read judgements, in root order:

- key 18, when key 25 is present false;
- key 20;
- key 21.

The citations are cite(eu_reg_2016_679_art_33_3_d), cite(eu_reg_2016_679_art_34_1) and cite(eu_reg_2016_679_art_34_2). The result is needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]), with Pairs the prefix up to and including Key.

**S3.** Items is the included items, in item order.

- An empty list gives all_requirements_met.
- Otherwise the result is requirements_not_met(Items).

Neither content check reads J1, J2, party_role or AUTHORITY.

### Referral rows (the keys each PAIRS can carry)

- Obligation:
  - referral on J1: [J1];
  - on J2: [J1, J2];
  - on A: [J1, J2, A];
  - on B: [J1, J2, A, B];
  - on C: [J1, J2, A, B, C].
- Verdict:
  - referral on J1: [J1];
  - on undue delay: [hours_elapsed, J1, notification_made_without_undue_delay];
  - on reasons: [hours_elapsed, J1, delay_justified_by_reasons].
- Authority content check:
  - referral on 13: [13];
  - on 18: [13, 18];
  - on 19: [13, 18, 19].
- Data subject check:
  - referral on 18: [18];
  - on 20: [18, 20];
  - on 21: [18, 20, 21].

### Verdict atoms

The slice produces every atom and compound in Status atoms above. It writes no others.

### Shared with kernel (the only cross-file predicates)

The slice uses the following kernel predicates:

- the key and profile helpers: key_state/3, contract_key/3, keys_in_contract_order/2, relied_pairs/3, first_unsure_key/3;
- the input check: profile_input_problems/2;
- the argument checks: awareness_date_problems/2, awareness_hour_problems/2, hours_elapsed_problems/2, real_calendar_day/1.

Nothing else is shared. The constants stay in the slice.

### Checklist (facade, query #2)

The requirement head is requirement_at(HoursElapsed, RequirementId, Profile, Status, Citation). The requirements are:

- risk_to_rights_and_freedoms (J1);
- notification_within_period (HoursElapsed =< 72);
- without_undue_delay (read only within the period);
- reasons_accompany_delay (read only beyond the period);
- delay_justified_by_reasons (read only beyond the period, with reasons true).

Each requirement:

- has its Status as met, unmet(Reason), unknown([Key]) for an absent or unsure key, or inapplicable;
- has three or four disjoint clauses;
- carries the Citation cite(eu_reg_2016_679_art_33_1).

### Per-rule tests (feeding the scaffold's seven test modes)

- **Each verdict route V0 to V14.** One positive and one paired negative test per route. Each counts its solutions with findall and length 1.
- **Each obligation route.** Include at least these cases:
  - O4 routes 2 to 6;
  - J1 unsure with J2 absent;
  - an authority decision with J1 true;
  - the reading (6) example.
- **Each content-check C1 to C5 and S1 to S3 route.** Include at least these cases:
  - the the status rule phases case;
  - 18 sorted before 20 in the data subject check.
- **The input check**:
  - duplicates with equal values;
  - an unknown key repeated;
  - both contradictory pairs;
  - a non-attribute element;
  - a string key.
- **Deadline and period-end examples**: the four PERIODS examples plus a Saturday case, for example awareness Wednesday 2025-11-05 ending on Saturday 2025-11-08, unshifted.
- **Boundary**: HoursElapsed 72 is within the period and 73 is beyond it. Malformed HoursElapsed values are -1 and 72.5.

## Determinism and totality

- **Profile reads.** After the input check passes, every key occurs at most once, so key_state/3 has exactly one solution.
- **Clause routes.** Every route set above is pairwise disjoint over the key states and exhaustive.
- **validate_props.** prop_determinism and prop_totality run over the fixture generator. The generator crosses the full state grid of J1, J2, AUTHORITY, A, B and C, and the HoursElapsed values 0, 72, 73 and 200.

## Fixtures (fixtures.clausal; gdpr_arts33_34_breach_notification_fixture(Name, Request))

| Fixture | Profile and arguments | Expected result |
|---|---|---|
| timely_notification_eligible | J1 false, undue true, H 48 | eligible |
| unlikely_risk_ineligible | J1 true, H 100 | ineligible |
| late_with_justified_reasons_eligible | J1 false, reasons true, delay true, H 73 | eligible |
| late_without_reasons_not_met | J1 false, reasons false, H 80 | notification_requirement_not_met(reasons_for_delay) |
| late_reasons_unjustified_referral | J1 false, reasons true, delay false, H 80 | the delay referral with [hours_elapsed-80, breach_unlikely_to_result_in_risk-false, delay_justified_by_reasons-false] |
| inside_period_unduly_delayed | J1 false, undue false, H 72 | notification_requirement_not_met(without_undue_delay) |
| risk_judgement_missing | an empty profile with H 10 | indeterminate([breach_unlikely_to_result_in_risk]) |
| contradictory_risk_inputs | J1 true, J2 true | input_problems([contradictory_inputs([breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk])]) |

Obligation companion cases:

| Case | Profile | Expected OBLIGATION |
|---|---|---|
| Reading (6) example | J1 false, J2 true, AUTHORITY no_decision, A false, B false, C true | [notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), public_communication_or_similar_measure(cite(eu_reg_2016_679_art_34_3_c))] |
| Processor | party_role processor | [notify_controller(cite(eu_reg_2016_679_art_33_2))] |
| Authority requires communication | J1 true, AUTHORITY required_communication | [no_notification_required(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), communicate_to_data_subject(cite(eu_reg_2016_679_art_34_4))] |

Deadline and period-end cases:

| Inputs | Expected output |
|---|---|
| AWARE date(2025, 10, 31), hour 10 | DEADLINE date(2025, 11, 3); period_end(date(2025, 11, 3), 11) |
| AWARE date(2032, 2, 26) | DEADLINE date(2032, 2, 29) |
| AWARE date(2032, 2, 27) | DEADLINE date(2032, 3, 1) |
| AWARE date(2025, 12, 30), hour 23 | period_end(date(2026, 1, 2), 24) |
| AWARE date(2025, 2, 30) | DEADLINE input_problems([wrong_type(awareness_date)]); HOURS 72 |
