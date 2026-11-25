# SIGNATURE — eu/ai_act/serious_incident_reporting

## 1 Public query surface

The two contract predicates are the law. The scaffold facade wraps them without changing any answer. Every query yields **exactly one solution** (the COUNTING rule). There is no `!`, `->` or `*->`. Ground verdicts are folded into clause heads, one clause per disjoint route.

- `serious_incident_report_duty(Profile, AwarenessDate, Duty, Citations)`: whether the Art 73(1) report is due, to whom, by which last day, with which follow-up. The routes are steps (0) to (11).
  - Duty is one of:
    - `report_due(Recipient, Days, LastDay, FollowUp)`;
    - one of the five no-duty atoms;
    - `indeterminate([Key])`;
    - `needs_legal_review(open_textured(Key, cite(C)), [inputs_relied_on(Pairs)])`;
    - `input_problems(Problems)`.
  - Citations: art_73_1 / art_75_1a, art_73_2/3/4, art_73_6, art_73_9/10, art_3_49, art_3_49_c, art_111_2, art_113_c(_i/_ii).
- `serious_incident_report_timeliness(Profile, AwarenessDate, ReportDate, Verdict, Citations)`: whether the first report (Art 73(5)) made on ReportDate was in time.
  - The routes are steps (12) to (14). Step (13) passes a non-report_due duty through unchanged.
  - Citations are those of the duty.
- `serious_incident_reporting_input_problems(Profile, Problems)`: THE INPUT CHECK.
  - Problems is the bare flat list of `duplicate_key/1`, `wrong_type/1` and `unknown_key/1` terms, or `[wrong_type(profile)]`.
  - It never fails and never raises.
- `decide_serious_incident_reporting(Request, serious_incident_reporting_verdict(Status, Citations))`: the facade.
  - Request is `duty_request(Profile, AwarenessDate)` or `timeliness_request(Profile, AwarenessDate, ReportDate)`.
  - Status is the Duty or Verdict term itself; Citations is passed through.
  - Any other Request gives `input_problems([wrong_type(request)])` with `[]`.
- `serious_incident_reporting_status(Request, Status)`: the facade. Status is the principal functor name of the answer term, from the STATUS atoms below.
- `serious_incident_reporting_checklist(Request, Checklist)`: explanatory checklist.
  - Built with `formalize_lib:eval_requirements/4` over `serious_incident_reporting_requirement/4`.
  - Items are `item(RequirementId, met | unmet(Reason) | unknown([Key]), cite(Key))`.
  - It never decides the verdict.
- `serious_incident_reporting_what_if(Request, Key, Value, Result)`: the facade.
  - It replaces Key in the request's profile through `query_combinators:what_if/5`.
  - The closure is `serious_incident_reporting_decide_at(AwarenessDate)` or `serious_incident_reporting_decide_at(AwarenessDate, ReportDate)`, with the dates inside the closure.
  - Result is `serious_incident_reporting_verdict(Status, Citations)`.
- `serious_incident_reporting_fixture(Name, Request, ExpectedStatusTerm, ExpectedCitations)` (fixtures.clausal) with `serious_incident_reporting_fixture_names(Names)`.

Result constructors (exported, never queried): `report_due/4`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`, `serious_incident_reporting_verdict/2`.

**Totality / determinism claims**, checked by `validate_props`:
- `prop_totality` and `prop_determinism`: every generated profile and date combination gives exactly one solution.
- `prop_citation_complete`: every final answer has a non-empty citation set drawn from the vocabulary, and every not-final answer has `[]`.
- `prop_boundary_coverage`: covers 2027-12-01/02, 2028-08-01/02, 2030-08-01/02, LastDay versus LastDay+1, and 2028-02-28+2 = 2028-03-01.
- `prop_missing_key_coverage`: each key the ladder reads, when removed, can be named.

## 2 STATUS atoms (replace the placeholders `satisfied` / `not_satisfied`)

**Final atoms:**
- Duty (the duty query only): `report_due`.
- Verdict (the timeliness query only): `report_in_time`, `report_after_time_limit`, `report_not_immediate`.
- No-duty (both queries): `not_applicable_on_date`, `not_a_high_risk_ai_system`, `not_covered_placed_before_application_date`, `not_a_serious_incident`, `not_a_reportable_incident`.

**Not-final** (the compound is the answer itself; the bare atom is never written): `indeterminate`, `needs_legal_review`, `input_problems`.

**Answer vocabulary:**
- Recipient atoms:
  - `market_surveillance_authority_of_member_state_where_incident_occurred`;
  - `national_competent_authority_chosen_by_member_state_where_incident_occurred`;
  - `ai_office`.
- FollowUp (always whole, in this order): `[perform_necessary_investigations_without_delay, risk_assessment_of_the_incident, corrective_action, cooperate_with_competent_authorities, inform_authorities_before_altering_the_system]`.
- Days is the integer 2, 10 or 15. LastDay is `date(Y, M, D)` of three integers.

## 3 Profile keys

The profile is `[attribute(Key, Value), ...]`, read only with `formalize_lib:profile_get/3`. The order below is the order of root_exports and input_contract, and the order of Pairs.

| # | Key | Type | Values |
|---|---|---|---|
| 1 | `high_risk_classification` | enumeration | `annex_iii_high_risk`, `annex_i_high_risk`, `not_high_risk` |
| 2 | `placed_before_chapter_iii_application_date` | crisp | `true`, `false` |
| 3 | `significant_change_in_design_since_that_date` | judgement | `true`, `false`, `unsure` |
| 4 | `intended_to_be_used_by_public_authorities` | judgement | `true`, `false`, `unsure` |
| 5 | `medical_device_or_safety_component_of_one` | crisp | `true`, `false` |
| 6 | `provider_subject_to_equivalent_union_reporting_obligations` | judgement | `true`, `false`, `unsure` |
| 7 | `harm_to_health` | enumeration | `death_of_a_person`, `serious_harm_to_health_without_death`, `no_death_or_serious_harm_to_health` |
| 8 | `critical_infrastructure_disruption` | crisp | `true`, `false` |
| 9 | `fundamental_rights_obligations_infringed` | crisp | `true`, `false` |
| 10 | `serious_harm_to_property_or_environment` | crisp | `true`, `false` |
| 11 | `widespread_infringement` | judgement | `true`, `false`, `unsure` |
| 12 | `report_made_immediately` | judgement | `true`, `false`, `unsure` (read by timeliness only) |
| 13 | `system_under_the_exclusive_competence_of_the_ai_office` | outside fact | `attested(true or false, attestation(By, At, Reason, Evidence))`; absent reads as false |

The two dates are arguments, not keys: AwarenessDate and ReportDate are ground `date(Year, Month, Day)` compounds of three integers. No value is a string or a Python boolean.

**Outside facts block** (manifest `outside_facts:`):
- `system_under_the_exclusive_competence_of_the_ai_office`:
  - citation `eu_reg_2024_1689_art_75_1`;
  - target `ai_office_exclusive_competence_under_article_75_1`;
  - kinds `[attested, fetched]`;
  - fetcher `none`.

**Referral rows** (judgement key, then the `citation` used in `open_textured(Key, cite(C))`):
- `significant_change_in_design_since_that_date`: `eu_reg_2024_1689_art_111_2`
- `intended_to_be_used_by_public_authorities`: `eu_reg_2024_1689_art_111_2`
- `provider_subject_to_equivalent_union_reporting_obligations`: `eu_reg_2024_1689_art_73_9`
- `widespread_infringement`: `eu_reg_2024_1689_art_3_61`
- `report_made_immediately`: `eu_reg_2024_1689_art_73_2`

## 4 Citation keys

These use the canonical `_lexicon/citations.yaml` scheme. Each is a `cite(Key)` and none is ever shortened.

| Key | Status |
|---|---|
| `eu_reg_2024_1689_art_3_49` | |
| `eu_reg_2024_1689_art_3_49_c` | |
| `eu_reg_2024_1689_art_3_61` | referral row only |
| `eu_reg_2024_1689_art_73_1` | |
| `eu_reg_2024_1689_art_73_2` | |
| `eu_reg_2024_1689_art_73_3` | |
| `eu_reg_2024_1689_art_73_4` | |
| `eu_reg_2024_1689_art_73_5` | documentary, in the vocabulary, never emitted in an answer |
| `eu_reg_2024_1689_art_73_6` | |
| `eu_reg_2024_1689_art_73_9` | |
| `eu_reg_2024_1689_art_73_10` | |
| `eu_reg_2024_1689_art_75_1` | outside-fact citation; never emitted in an answer |
| `eu_reg_2024_1689_art_75_1a` | |
| `eu_reg_2024_1689_art_111_2` | |
| `eu_reg_2024_1689_art_113_c` | |
| `eu_reg_2024_1689_art_113_c_i` | |
| `eu_reg_2024_1689_art_113_c_ii` | |

The citations module (citations.clausal) declares them as `serious_incident_reporting_citation(Key, UnitId, Gloss)`. UnitId is the pinned unit, for example `'02024R1689-20260727#parag_073.003'`.

## 5 Planned reuse (manifest `uses:`)

- **formalize_lib:**
  - `profile_get/3` is the only profile reader.
  - `eval_requirements/4`, `item/3`, `unknown/1` and `unmet/1` serve the checklist.
  - `first_applicable/2` is not used: ladder routes are disjoint clauses.
- **kit/deadline_lib:** `month_last_day/3`, for the real-calendar-day check of a `date(Y, M, D)` compound before conversion, so that it never raises.
- **library(datetime) (date_time):** `timedelta/3`, `date_add/3`, `ordinal/2`, and `date/4` (the constructor; `date/3` is not registered yet).
  - Conversion is done in the kernel: a ground validated `date(Y, M, D)` becomes `date(Y, M, D, Object)`.
  - LastDay is `date_add(Object, Td, LastObject)` with `timedelta(Days, 0, Td)`, read back to `date(Y2, M2, D2)` integers.
  - Before / on-or-after comparisons compare `ordinal/2` integers of the objects, never compound order.
- **kit/query_combinators:** `what_if/5` for `serious_incident_reporting_what_if/4`.
- **validate_props:** `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`, `bad_citation/1`.
- **Not used:** compliance_lib, rolling_window, currency_vocab, vat_category, country.
  - There are no money, VAT or country figures.
  - The Member State is not an input: the recipient atom stands for the authorities of each state concerned.

## 6 Package layout (unchanged)

The module chain is kernel, then citations, then parameters, then serious_incident_reporting, then queries, then fixtures, then the package facade.

- **parameters.clausal** holds only the pinned-source metadata:
  - `serious_incident_reporting_pinned_source('02024R1689-20260727', 'CL2024R1689EN0010010.0001.xml', Sha256)`.
  - It holds no statutory figure; figures live in the slice.
- **queries.clausal** holds the facade predicates of section 1 and the closures `serious_incident_reporting_decide_at/3,4`.
- **fixtures.clausal** holds the named cases of section 7.D.

## 7 Determination slices

### 7.0 kernel.clausal — the shared floor

Only predicates used by more than one module: the slice, queries and fixtures.

- `serious_incident_reporting_calendar_date(Term)`:
  - succeeds iff Term is a ground `date(Year, Month, Day)` of integers with Month in 1..12 and Day in 1..LastDay;
  - LastDay comes from `month_last_day/3`;
  - it fails (never raises) on anything else, unbound included, by guarding with `ground/1`, `integer/1` and range checks before any conversion.
- `serious_incident_reporting_date_ordinal(DateTerm, Ordinal)`: builds `date(Y, M, D, Object)` and calls `ordinal(Object, Ordinal)`.
- `serious_incident_reporting_date_before(Earlier, Later)` and `serious_incident_reporting_date_on_or_after(Later, Earlier)`: compare ordinals.
- `serious_incident_reporting_add_days(DateTerm, Days, LastDayTerm)`: `timedelta(Days, 0, Td)`, `date_add/3`, then read Y, M, D back from the result object into a plain three-integer `date/3` compound.
- `serious_incident_reporting_identical_member(Term, List)`: membership by `==`, for dedup of variable keys in the input check.

### 7.1 serious_incident_reporting.clausal — the one determination: Art 73 report duty and its timeliness

**A. Statutory VALUE facts owned by this slice.** They are declared once and read with `#Name` or the fact.

- `:- constant_value(serious_incident_reporting_urgent_period_days, 2).` (Art 73(3))
- `:- constant_value(serious_incident_reporting_death_period_days, 10).` (Art 73(4))
- `:- constant_value(serious_incident_reporting_general_period_days, 15).` (Art 73(2))
- Date facts:
  - `serious_incident_reporting_date_value(annex_iii_classification_application, date(2027, 12, 2)).` (Art 113(c)(i); also the Art 111(2) Chapter III date for Annex III)
  - `serious_incident_reporting_date_value(annex_i_classification_application, date(2028, 8, 2)).` (Art 113(c)(ii); the Art 111(2) date for Annex I)
  - `serious_incident_reporting_date_value(public_authorities_compliance, date(2030, 8, 2)).` (Art 111(2), second sentence)
- `serious_incident_reporting_follow_up_duties([perform_necessary_investigations_without_delay, risk_assessment_of_the_incident, corrective_action, cooperate_with_competent_authorities, inform_authorities_before_altering_the_system]).` (Art 73(6))
- `serious_incident_reporting_contract_key(Position, Key, Type)`: thirteen rows, in the order of section 3.
  - Type is one of `enumeration(Atoms)`, `crisp`, `judgement` or `outside_fact`.
- `serious_incident_reporting_judgement_readable(duty, Keys)` and `serious_incident_reporting_judgement_readable(timeliness, Keys)`, for THE PAIRS RULE and the unsure runs.
  - duty: the four judgements of positions 3, 4, 6 and 11.
  - timeliness: those four plus `report_made_immediately`.
- `serious_incident_reporting_referral_citation(Key, CitationKey)`: five rows (section 3).

**B. Rules / requirements, in ladder order.** The first step that answers decides; each is a disjoint clause with a ground head.

1. **(0 / 12) Input.**
   - Run `serious_incident_reporting_input_problems/2`.
   - Append `wrong_type(awareness_date)`, then (timeliness only) `wrong_type(report_date)`, for a date failing `serious_incident_reporting_calendar_date/1`.
   - A non-empty list gives `input_problems(Problems)`, `[]`.
   - The input check walks the raw list:
     - Any element that is not `attribute(_, _)`, an unbound element, a partial list or an unbound profile gives `[wrong_type(profile)]`.
     - Contract keys are taken in contract order, each yielding `duplicate_key` if it occurs more than once (values unread), else `wrong_type` if its value is ill-typed. An unbound value is ill-typed. The outside fact needs `attested(true|false, attestation(A, B, C, D))` with A to D ground, and `attested(...)` given to any other key is ill-typed.
     - Then `unknown_key(K)` once per distinct non-contract key (`==` identity), in first-occurrence order, its value never checked.
2. **(1) Date floor.** AwarenessDate before 2027-12-02 gives `not_applicable_on_date`, [113_c, 113_c_i]. No key is read.
3. **(2) Classification.** `high_risk_classification` absent gives `indeterminate([high_risk_classification])`.
4. **(3) Not high-risk.** `not_high_risk` gives `not_a_high_risk_ai_system`, [73_1].
5. **(4) Annex I date.** `annex_i_high_risk` with AwarenessDate before 2028-08-02 gives `not_applicable_on_date`, [113_c, 113_c_ii].
6. **(5) Art 111(2).**
   - NOT COVERED gives `not_covered_placed_before_application_date`, [111_2].
   - COVERED continues.
   - Neither gives `indeterminate` on the first absent key of placed_before, significant_change, then intended_public (the last only from 2030-08-02).
7. **(6) Device key.** `medical_device_or_safety_component_of_one` absent gives `indeterminate([medical_device_or_safety_component_of_one])`.
8. **(7) Equivalent obligations.** The condition for `indeterminate([provider_subject_to_equivalent_union_reporting_obligations])`:
   - the system is not a device;
   - it is Annex III;
   - provider_equivalent is absent;
   - fundamental_rights is false, or fundamental_rights is absent while another harm is serious.
9. **(8) Limited regime.** The regime holds for a device, or for Annex III with provider_equivalent true.
   - fundamental_rights absent gives `indeterminate`.
   - fundamental_rights false gives `not_a_reportable_incident`, [73_10, 3_49_c] for a device, else [73_9, 3_49_c].
   - fundamental_rights true continues.
10. **(9) Serious incident test**, outside the limited regime.
    - The incident is serious if harm_to_health is death or serious harm without death, or one of the three crisp harms is true.
    - Otherwise an absent harm key gives `indeterminate` in the BEHIND order stated in NOTES S4 point 15.
    - Otherwise `not_a_serious_incident`, [3_49].
11. **(10) Limit.**
    - critical_infrastructure true or widespread true: 2 days, [73_3].
    - Else the first absent of critical_infrastructure, widespread, harm_to_health gives `indeterminate`.
    - Else death: 10 days, [73_4].
    - Else 15 days, [73_2].
12. **(11) Report.**
    - `report_due(Recipient, Days, LastDay, FollowUp)`, with Recipient `ai_office` when the outside fact is attested true, else the national competent authority for a device, else the market surveillance authority.
    - LastDay = `serious_incident_reporting_add_days(AwarenessDate, Days, LastDay)`.
    - Citations: [75_1a or 73_1] + limit citations + [73_6] + [73_10 if device].
13. **(13–14) Timeliness.**
    - Pass through any non-report_due duty.
    - ReportDate after LastDay gives `report_after_time_limit`.
    - Otherwise `report_made_immediately`: absent gives `indeterminate`; false gives `report_not_immediate`; true gives `report_in_time`. The duty citations are carried.
14. **THE UNSURE RULE wrapper.**
    - `serious_incident_reporting_ladder/5` (Query, Profile, Dates, Answer, Citations) runs on a profile with no unsure judgements.
    - The wrapper collects the unsure readable judgements and builds every true/false setting with `profile_set/3`-style replacement (local, pure). It findalls the run answers and folds them:
      - U1: all runs equal, compared as sets on the citations;
      - U2: some run is `indeterminate`; take the first key in root_exports order, with exceptions (i) and (ii);
      - U3: `needs_legal_review(open_textured(J, cite(C)), [inputs_relied_on(Pairs)])`.
    - Pairs are the present readable judgements in root_exports order, values as given.
    - The three folds are disjoint clauses guarded by complementary tests, so exactly one solution results.

**C. Verdict atoms of this slice.** All atoms of section 2, plus the recipient and follow-up atoms.

**D. Per-rule tests and fixtures.** Seven modes: load, unit, boundary, negative-paired, determinism, citation, unsure. Representative fixtures:

- 2027-12-01, any profile: `not_applicable_on_date`, [113_c, 113_c_i].
- 2027-12-02, Annex III, not placed before, not device, provider_equivalent false, death, other harms false, widespread false: `report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 10, date(2027, 12, 12), FollowUp)`, [73_1, 73_4, 73_6].
- Annex I, 2028-08-01: `not_applicable_on_date`, [113_c, 113_c_ii].
- critical_infrastructure true, awareness 2028-02-28: 2 days, LastDay `date(2028, 3, 1)` (2028 is a leap year), [73_1, 73_3, 73_6].
- Serious harm without death only, awareness 2027-12-20: 15 days, `date(2028, 1, 4)`, [73_1, 73_2, 73_6].
- Device, fundamental_rights false, death: `not_a_reportable_incident`, [73_10, 3_49_c].
- Device, fundamental_rights true, AI Office attested true: recipient `ai_office`, [75_1a, 73_2, 73_6, 73_10].
- Placed before, significant change false, 2029-01-01: `not_covered_placed_before_application_date`, [111_2].
- Placed before, significant change false, intended_public unsure, 2031-01-01: `needs_legal_review(open_textured(intended_to_be_used_by_public_authorities, cite(eu_reg_2024_1689_art_111_2)), [inputs_relied_on([significant_change_in_design_since_that_date-false, intended_to_be_used_by_public_authorities-unsure])])`.
- Timeliness: report on LastDay with immediately true gives `report_in_time`. LastDay+1 gives `report_after_time_limit`. Immediately false gives `report_not_immediate`.
- Input: `date(2027, 2, 29)` gives `wrong_type(awareness_date)`. A duplicate harm key gives `duplicate_key(harm_to_health)`. `[attribute(X, 1), attribute(Y, 2)]` gives `[unknown_key(X), unknown_key(Y)]`. `foo` gives `[wrong_type(profile)]`.

**E. Predicates shared with another slice.** None beyond the kernel date helpers and `serious_incident_reporting_identical_member/2` of 7.0. Everything else above lives in this file.
