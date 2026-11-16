# SIGNATURE — eu/ai_act/provider_side_duties

## Public query surface (summary)

The scored contract (INTERFACE - THE CALLED CONTRACT) is three predicates, each yielding exactly ONE solution:

- `operator_duty_status(Profile, Duty, AssessmentDate, Result, Citations)`
- `retention_period_end(KeepingDuty, StartDate, EndDate, Citations)`
- `provider_side_duties_input_problems(Profile, Problems)`

The scaffold facade wraps `operator_duty_status/5` around a question term:

```
duty_question(Profile, Duty, AssessmentDate)
```

This question term is an INPUT constructor only, never returned. The facade predicates are:

- `decide_provider_side_duties(duty_question(P, D, A), provider_side_duties_verdict(Status, Citations))`
- `provider_side_duties_status(duty_question(P, D, A), Status)`
- `provider_side_duties_checklist/2`
- `provider_side_duties_what_if/4`

Two further predicates serve query types #13 and #14:

- `provider_side_duties_compliance_check/3`
- `provider_side_duties_obligations/3`

Guarantees:

- **Totality:** every term given to any public predicate yields one answer. Input problems are answered, never by failure or raise.
- **Determinism:** exactly one solution per query.
- **No re-declaration:** no figure is imported from a sibling order. All dates and periods are declared once in the slice.

## Verdict STATUS atoms (replace placeholder `{ required, permitted, not_applicable }`)

There are ten final RESULT atoms:

- `not_applicable_on_date`
- `earlier_text_not_formalised`
- `not_an_ai_system`
- `not_a_high_risk_ai_system`
- `not_the_addressee_of_the_duty`
- `compliance_required_by_31_december_2030`
- `compliance_required_by_2_august_2030`
- `system_already_placed_without_significant_change`
- `duty_not_triggered`
- `duty_applies`

There are three not-final compounds, each with CITATIONS `[]`:

- `indeterminate([Key])`
- `needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)])`, where Pairs are `Key-Value` terms; an optional trailing `provenance(Clause, Citations)` is unscored.
- `input_problems(Problems)`

The problem terms are `unknown_key(Key)`, `wrong_type(Key)` and `duplicate_key(Key)`. The non-profile argument problems are `wrong_type(duty)`, `wrong_type(assessment_date)`, `wrong_type(keeping_duty)` and `wrong_type(start_date)`.

`retention_period_end/4` gives END_DATE as either a `date(Year, Month, Day)` term or `input_problems(Problems)`.

Compliance verdict atoms (#13) are `compliant` and `non_compliant`. A not-final status compound is passed through itself.

The bare atom `indeterminate` is NEVER written.

## Profile keys (attribute list, read only with profile_get/3; root_exports / input_contract order)

| # | Key | Type |
|---|---|---|
| 1 | `ai_system` | judgement (true / false / unsure) |
| 2 | `high_risk_ai_system` | crisp (true / false) |
| 3 | `high_risk_route` | enumeration `high_risk_route`: annex_iii, annex_i |
| 4 | `actor_role` | enumeration `actor_role`: provider, deployer, importer, distributor, product_manufacturer, authorised_representative, affected_person |
| 5 | `component_of_a_large_scale_it_system_listed_in_annex_x` | crisp |
| 6 | `placed_on_the_market_or_put_into_service_before_2_august_2027` | crisp |
| 7 | `placed_on_the_market_or_put_into_service_before_the_date_of_application_of_chapter_iii` | crisp |
| 8 | `significant_change_in_design_as_from_the_date_of_application_of_chapter_iii` | judgement |
| 9 | `intended_to_be_used_by_public_authorities` | judgement |
| 10 | `provider_established_in_a_third_country` | crisp |
| 11 | `logs_under_the_providers_control` | crisp |
| 12 | `reasoned_request_from_a_competent_authority` | crisp |
| 13 | `request_from_a_market_surveillance_authority_for_a_copy_of_the_mandate` | crisp |
| 14 | `competent_authority_action_in_relation_to_the_system` | crisp |
| 15 | `system_under_the_operators_responsibility` | crisp |
| 16 | `provider_considers_or_has_reason_to_consider_the_system_not_in_conformity` | judgement |
| 17 | `presents_a_risk_within_the_meaning_of_article_79_1` | judgement |
| 18 | `provider_aware_of_the_risk` | crisp |
| 19 | `representative_considers_or_has_reason_to_consider_the_provider_acting_contrary_to_its_obligations` | judgement |
| 20 | `importer_has_sufficient_reason_to_consider_the_system_not_in_conformity_or_falsified` | judgement |
| 21 | `distributor_considers_or_has_reason_to_consider_the_system_not_in_conformity` | judgement |
| 22 | `distributor_has_made_the_system_available_on_the_market` | crisp |

No key is numeric and no key is a date. The date arguments ASSESSMENT_DATE and START_DATE are `date(Year, Month, Day)` terms of integers, giving a real calendar day with Year from 1 to 9999.

Value rules:

- An `attested/2` value is `wrong_type(Key)`.
- An unbound value is `wrong_type(Key)`.
- A Python boolean or a string is `wrong_type(Key)`.

## Argument atoms

There are forty DUTY atoms, grouped by addressee.

**Provider (16):**
- `compliance_with_the_requirements_of_section_2`
- `provider_name_and_contact_address`
- `quality_management_system`
- `documentation_keeping`
- `log_keeping`
- `conformity_assessment_before_placing_on_the_market`
- `eu_declaration_of_conformity`
- `ce_marking`
- `registration`
- `corrective_actions_and_information`
- `investigation_and_information_on_a_risk`
- `demonstration_of_conformity_on_request`
- `access_to_logs_on_request`
- `accessibility_requirements`
- `appointment_of_an_authorised_representative`
- `enabling_the_authorised_representative`

**Authorised representative (8):**
- `performance_of_the_mandate_tasks`
- `copy_of_the_mandate_on_request`
- `verification_of_the_declaration_documentation_and_conformity_assessment`
- `keeping_of_the_provider_contact_details_and_documents`
- `representative_information_on_request`
- `representative_cooperation_with_authorities`
- `representative_registration`
- `termination_of_the_mandate`

**Importer (8):**
- `importer_verification_before_placing_on_the_market`
- `importer_withholding_of_a_non_conforming_system`
- `importer_information_on_a_risk`
- `importer_name_and_contact_address`
- `importer_storage_and_transport_conditions`
- `importer_keeping_of_copies`
- `importer_information_on_request`
- `importer_cooperation_with_authorities`

**Distributor (7):**
- `distributor_verification_before_making_available`
- `distributor_withholding_of_a_non_conforming_system`
- `distributor_information_on_a_risk`
- `distributor_storage_and_transport_conditions`
- `distributor_corrective_actions`
- `distributor_information_on_request`
- `distributor_cooperation_with_authorities`

**Provider or deployer (1):**
- `ai_literacy_measures`

The four KEEPING_DUTY atoms are:
- `documentation_keeping`
- `keeping_of_the_provider_contact_details_and_documents`
- `importer_keeping_of_copies`
- `log_keeping`

## Citation-key atoms (CANONICAL lexicon scheme; registered in citations.clausal with their pinned unit ids)

Emitted by answers:

| Group | Keys |
|---|---|
| Art 3 | `eu_reg_2024_1689_art_3_1`, `eu_reg_2024_1689_art_3_3`, `eu_reg_2024_1689_art_3_4`, `eu_reg_2024_1689_art_3_5`, `eu_reg_2024_1689_art_3_6`, `eu_reg_2024_1689_art_3_7` |
| Art 4 | `eu_reg_2024_1689_art_4_1` |
| Art 16 | `eu_reg_2024_1689_art_16_a`, `_16_b`, `_16_c`, `_16_d`, `_16_e`, `_16_f`, `_16_g`, `_16_h`, `_16_i`, `_16_j`, `_16_k`, `_16_l` |
| Art 18 | `eu_reg_2024_1689_art_18_1`, `_18_1_a`, `_18_1_b`, `_18_1_c`, `_18_1_d`, `_18_1_e` |
| Art 19 | `eu_reg_2024_1689_art_19_1` |
| Art 20 | `eu_reg_2024_1689_art_20_1`, `eu_reg_2024_1689_art_20_2` |
| Art 21 | `eu_reg_2024_1689_art_21_1`, `eu_reg_2024_1689_art_21_2` |
| Art 22 | `eu_reg_2024_1689_art_22_1`, `_22_2`, `_22_3`, `_22_3_a`, `_22_3_b`, `_22_3_c`, `_22_3_d`, `_22_3_e`, `_22_4` |
| Art 23 | `eu_reg_2024_1689_art_23_1`, `_23_1_a`, `_23_1_b`, `_23_1_c`, `_23_1_d`, `_23_2`, `_23_3`, `_23_4`, `_23_5`, `_23_6`, `_23_7` |
| Art 24 | `eu_reg_2024_1689_art_24_1`, `_24_2`, `_24_3`, `_24_4`, `_24_5`, `_24_6` |
| Art 111 | `eu_reg_2024_1689_art_111_1`, `eu_reg_2024_1689_art_111_2` |
| Art 113 | `eu_reg_2024_1689_art_113_a`, `eu_reg_2024_1689_art_113_c`, `eu_reg_2024_1689_art_113_c_i`, `eu_reg_2024_1689_art_113_c_ii` |

In the table, `_16_b` and similar short forms abbreviate the full prefix. Every atom is written in full in code, for example `eu_reg_2024_1689_art_16_b`.

Registered for meaning only and NEVER emitted:
- `eu_reg_2024_1689_art_3_8`
- `eu_reg_2024_1689_art_3_9`
- `eu_reg_2024_1689_art_3_10`
- `eu_reg_2024_1689_art_3_11`
- `eu_reg_2024_1689_art_3_26`
- `eu_reg_2024_1689_art_3_48`
- `eu_reg_2024_1689_art_3_56`
- `eu_reg_2024_1689_art_17_1`
- `eu_reg_2024_1689_art_17_2`

No shortened citation atom is ever invented.

## Public predicates (one line each)

- `operator_duty_status(Profile, Duty, AssessmentDate, Result, Citations)`: whether Duty applies to the actor and system of Profile on AssessmentDate. Result is a RESULT atom or a status compound; Citations is a set-like `cite/1` list, `[]` when not final. Cites: Art 4(1); Art 16; Arts 18 to 24; Art 111(1), (2); Art 113(a), (c)(i), (c)(ii); Art 3(1), (3) to (7).
- `retention_period_end(KeepingDuty, StartDate, EndDate, Citations)`: the last day, included, of the keeping period. Ten years for documentation (Art 18(1)), the representative's documents (Art 22(3)(b)) and the importer's copies (Art 23(5)); at least six months for logs (Art 19(1)). EndDate is `input_problems(Problems)` with Citations `[]` on a bad argument.
- `provider_side_duties_input_problems(Profile, Problems)`: the bare flat list of problems of THE INPUT CHECK, `[]` when well-formed. No citation (the input contract of this order).
- `decide_provider_side_duties(Question, Verdict)`: Question is `duty_question(Profile, Duty, AssessmentDate)`; Verdict is `provider_side_duties_verdict(Status, Citations)`, the `operator_duty_status/5` answer. Cites as `operator_duty_status/5`.
- `provider_side_duties_status(Question, Status)`: status determination (#3). Status is the RESULT term of `operator_duty_status/5`. Cites as above.
- `provider_side_duties_checklist(Question, Checklist)`: justification (#7). One `item(StepIdentifier, StepStatus, cite(Key))` per ladder step reached, with StepStatus met / unmet / unknown(Keys). Each item carries the citation of that step: Art 113, Art 3, Art 111 or the DUTY citations.
- `provider_side_duties_what_if(Question, Key, Value, Result)`: the Status of Question with Key overridden to Value, via `what_if/5` from query_combinators. Cites as `operator_duty_status/5`.
- `provider_side_duties_compliance_check(Question, Action, Verdict)`: compliance check (#13). Action is `omit_duty` or `perform_duty`. Verdict is:
  - `non_compliant` for `omit_duty` when the Status is `duty_applies`;
  - `compliant` otherwise for a final Status;
  - the status compound itself when the Status is not final.

  Built on `compliance_check/7` from compliance_lib, with modality obligatory for duty_applies (deny-overrides). Cites the DUTY citations.
- `provider_side_duties_obligations(Profile, AssessmentDate, Duties)`: obligation surfacing (#14). Duties is the list of DUTY atoms, in DUTY-table order, whose Status for the actor is `duty_applies`. A single findall gives exactly one solution. Cites the DUTY citations per duty, via the checklist.
- `provider_side_duties_fixture(Name, Question)`: the named fixtures, listed below.

The fixture names are:
- `fixture_annex_iii_provider_duty_applies`
- `fixture_annex_i_before_2_august_2028`
- `fixture_large_scale_component_2029`
- `fixture_public_authority_provider_2029`
- `fixture_already_placed_importer`
- `fixture_ai_literacy_earlier_text`
- `fixture_ai_literacy_deployer_applies`
- `fixture_missing_actor_role`
- `fixture_unsure_risk_referral`
- `fixture_duplicate_and_unknown_keys`

## Planned reuse (manifest `uses:`)

**formalize_lib:**
- `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`, `profile_keys/2`;
- `check_tri/4`, `check_true/4`, `check_eq/5`;
- `not_defeated/3`: defeasible step guard; each ladder step is a rule whose defeaters are the earlier steps, guarded by `once/1`, cut-free;
- `item/3`, `memberd/2`, `not_member/2`, `first_applicable/2`, `missing_keys/3`;
- `assess/6` and `eval_requirements/4`: checklist assembly, with `requirement(StepIdentifier, Profile, Status, Citation)` passed as a closure;
- `attribute/2`.

**kit/query_combinators:** `what_if/5`, `override_key/4`, `diff_checklists/3`.

**kit/compliance_lib:** `nm/2`, `compliance_check/7`, `verdict/5`.

**validate_props** (tests): `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`, `bad_citation/1`.

**Not used, with reasons:**
- `kit/deadline_lib`: `deadline_months_after/3` is last-day-after-anchor, not same-day, and month_last_day may not hold above year 9999.
- `library(datetime)`: dates must be compound `date/3` and years above 9999 must be supported.

Day arithmetic is therefore local, Gregorian and integer-only. This is noted as a kit candidate in the working notes (not published).

No `_common` family-backbone predicate fits. The STATUS RULE engine is local and is noted as a kit candidate.

## Layout: kernel and the non-slice files

**kernel.clausal** holds only what the queries file and the slice both need:
- `provider_side_duties_valid_calendar_date/1`: a ground `date(Y, M, D)` of integers, Y from 1 to 9999, a real day.
- `provider_side_duties_leap_year/1`: the Gregorian rule for every year.
- `provider_side_duties_month_length/3`.
- `provider_side_duties_day_key/2`: Y*10000 + M*100 + D, for comparison.
- `provider_side_duties_date_before/2`.
- The key type table, `provider_side_duties_contract_key(Index, Key, Type)`, which is non-statutory, together with the type tests `provider_side_duties_value_has_type/2`:
  - `crisp`: true or false;
  - `judgement`: true, false or unsure;
  - `high_risk_route`;
  - `actor_role`.

The other files hold:
- **citations.clausal:** `citation(Key, UnitIdentifier)` for every atom above.
- **parameters.clausal:** no statutory figure. It keeps the layout and holds only the root_exports key order, delegating to kernel.
- **queries.clausal:** the three contract predicates. It contains:
  - step (0) argument checks;
  - THE INPUT CHECK:
    - attribute-list shape;
    - `duplicate_key` in key order, never also `wrong_type`;
    - `wrong_type` in key order;
    - `unknown_key` in order of first occurrence, once each; a non-atom key is unknown;
    - never fails, never raises;
  - THE STATUS RULE engine;
  - the facade #13 and #14 predicates.
- **fixtures.clausal:** the named fixtures.
- **The package facade:** re-exports the public predicates and the result constructors.

### THE STATUS RULE engine (queries.clausal)

1. Compute the relevant keys for (Duty, AssessmentDate):
   - for Art 4 on or after 2026-07-27: `actor_role`, `ai_system`;
   - for Art 4 before 2026-07-27: none;
   - for a Chapter III duty before 2027-12-02: none;
   - otherwise: `high_risk_ai_system`, `high_risk_route`, `actor_role`, keys 5 to 8, key 9 for provider duties only, and the condition keys of the DUTY.
2. Free keys are the relevant keys that are absent or judgement-unsure. Enumerate the completions over the free keys only (at most about 3584).
3. Compute the ANSWER of each completion with the ladder.
4. If all answers are equal, the answer is SETTLED.
5. Otherwise compute the witnesses per free key, for MATTERS and BEHIND (reading B, also for the enumeration keys). Then:
   - the first absent key that matters and is not behind another absent key gives `indeterminate([K])`; if every such key is behind another, the first absent key that matters;
   - otherwise, the first unsure judgement that matters gives `needs_legal_review`.

The engine is cut-free and builds its sets with findall and sort. Exactly one solution.

## Slice: provider_side_duties.clausal

This slice is self-contained for the determination 'does this duty apply to this operator on this day, and when does keeping end'.

### Statutory VALUE facts owned (declared once, here only)

Dates are given as statutory date facts with their citation, in the form `statutory_date(Name, date(Y, M, D), cite(Key))`:

| Name | Date | Citation |
|---|---|---|
| `chapter_i_application` | date(2025, 2, 2) | art_113_a |
| `pinned_text_validity` | date(2026, 7, 27) | art_113_a, as the citation the order gives |
| `chapter_iii_annex_iii_application` | date(2027, 12, 2) | art_113_c, c_i, c_ii |
| `chapter_iii_annex_i_application` | date(2028, 8, 2) | same |
| `large_scale_it_system_compliance` | date(2030, 12, 31) | art_111_1 |
| `public_authority_compliance` | date(2030, 8, 2) | art_111_2 |

The date 2 August 2027 is carried by the key name only and is not compared.

Periods are declared with constant_value:
- `:- constant_value(record_retention_years, 10).`, citing Art 18(1), Art 22(3)(b) and Art 23(5);
- `:- constant_value(log_retention_minimum_months, 6).`, citing Art 19(1).

The slice also owns these tables:

- **The DUTY TABLE:** `duty_row(Duty, Addressee, Condition, DutyCitations)` for all 39 Chapter III duties, exactly as in INTERFACE - THE LIMBS. Condition is `true`, `key(Key, Value)` or `all([key(...), ...])`.
- **`addressee_role_citation(Addressee, Citations)`** for the four addressees.
- **`keeping_duty_period(KeepingDuty, years(10) or months(6), Citations)`.**
- **`referral_citation(Judgement, Duty, cite(Key))`:**
  - per-duty rows for `presents_a_risk_within_the_meaning_of_article_79_1`:
    - `investigation_and_information_on_a_risk`: 20_2;
    - `importer_information_on_a_risk`: 23_2;
    - `distributor_information_on_a_risk`: 24_2;
  - per-duty rows for `distributor_considers_or_has_reason_to_consider_the_system_not_in_conformity`:
    - withholding: 24_2;
    - corrective actions: 24_4;
  - duty-independent rows for the other six judgements:
    - `ai_system`: 3_1;
    - `significant_change_in_design_as_from_the_date_of_application_of_chapter_iii`: 111_2;
    - `intended_to_be_used_by_public_authorities`: 111_2;
    - `provider_considers_or_has_reason_to_consider_the_system_not_in_conformity`: 20_1;
    - `representative_considers_or_has_reason_to_consider_the_provider_acting_contrary_to_its_obligations`: 22_4;
    - `importer_has_sufficient_reason_to_consider_the_system_not_in_conformity_or_falsified`: 23_2.

### Rules and requirements (ladder of a COMPLETE profile; defeasible, cut-free)

Each step is one clause with its ground RESULT folded into the head (C17). Every later step is guarded by `not_defeated/3` over the earlier steps, using `once/1` defeaters.

The Art 4 steps:
- **A1:** before 2025-02-02 gives `not_applicable_on_date`, citing [113_a].
- **A2:** before 2026-07-27 gives `earlier_text_not_formalised`, citing [113_a].
- **A3:** role not provider or deployer gives `not_the_addressee_of_the_duty`, citing [3_3, 3_4, 4_1].
- **A4:** `ai_system` false gives `not_an_ai_system`, citing [3_1, 4_1].
- **A5:** otherwise `duty_applies`, citing [4_1].

The Chapter III steps:
- **C1:** before 2027-12-02 gives `not_applicable_on_date`, citing [113_c, 113_c_i, 113_c_ii].
- **C2:** `high_risk_ai_system` false gives `not_a_high_risk_ai_system`, citing the DUTY citations.
- **C3:** route annex_i and before 2028-08-02 gives `not_applicable_on_date`, citing [113_c, c_i, c_ii].
- **C4:** role not the addressee gives `not_the_addressee_of_the_duty`, citing the DUTY citations plus the role citation.
- **C5:** the large-scale test and before 2030-12-31 give `compliance_required_by_31_december_2030`, citing the DUTY citations plus 111_1.
- **C6:** the already-placed test, the public authority test and before 2030-08-02 give `compliance_required_by_2_august_2030`, citing the DUTY citations plus 111_2.
- **C7:** the already-placed test with NOT the public authority test gives `system_already_placed_without_significant_change`, citing the DUTY citations plus 111_2.
- **C8:** NOT the condition gives `duty_not_triggered`, citing the DUTY citations.
- **C9:** otherwise `duty_applies`, citing the DUTY citations.

The named tests:
- **The large-scale test:** component true AND placed before 2027-08-02 true.
- **The already-placed test:** NOT the large-scale test, AND (placed before 2027-08-02 true OR placed before the Chapter III date true), AND significant change false.
- **The public authority test:** the addressee is the provider AND intended for public authorities true.

Citations are built set-like with sort/2 and are never duplicated.

Retention:
- **10 years:** date(Y+10, M, D), except that date(Y, 2, 29) gives date(Y+10, 2, 28) when Y+10 is not a leap year.
- **6 months:** month M+6, carrying into Y+1 when M+6 is above 12, with the day clamped to the month length.

The check examples are:
- 2028-03-15 gives 2038-03-15 for a 10-year record and 2028-09-15 for logs;
- 2028-02-29 gives 2038-02-28;
- 2028-08-31 gives 2029-02-28 for logs.

### Verdict atoms of this slice

- The ten RESULT atoms listed above.
- `date/3` as END_DATE.

The not-final compounds are produced by queries.clausal from this slice's complete-profile ladder.

### Exported to the queries layer

The slice exports:
- `provider_side_duties_ladder_answer(CompleteProfile, Duty, AssessmentDate, Result, Citations)`
- `provider_side_duties_relevant_keys(Duty, AssessmentDate, Keys)`
- `provider_side_duties_duty/1`
- `provider_side_duties_keeping_duty/1`
- `provider_side_duties_referral_citation/3`
- `provider_side_duties_retention_end/3`
- `provider_side_duties_ladder_steps/4`, for the checklist

The slice shares only the kernel's date and type predicates. There is no other slice.

### Tests owned (seven modes, v2 manifest)

1. **Load.**
2. **Per-rule:** each of A1 to A5 and C1 to C9 positive, with a paired negative.
3. **Boundaries:** each date the day before and the day itself. The dates are 2025-02-02, 2026-07-27, 2027-12-02, 2028-08-02, 2030-08-02 and 2030-12-31.
4. **Statuses:**
   - a missing key and behind;
   - an unsure referral with PAIRS;
   - Q4 (a public-authority component in 2030);
   - Q7 (contradictory placing keys).
5. **Input check:** duplicate, unknown, non-atom key, unbound, attested, a non-list profile, a partial list.
6. **Retention:** the leap examples, year 9999+10, and bad arguments.
7. **Properties via validate_props:** totality, determinism (findall length 1), citation completeness.
