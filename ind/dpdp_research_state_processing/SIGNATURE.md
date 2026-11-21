# SIGNATURE — ind/dpdp_research_state_processing

## 1. Public query surface

### 1.1 Contract queries

These are scored, and their layout is fixed by the brief. All four are exported from the slice and re-exported by the facade.

- `research_exemption(Profile, Result, Citations)`: whether s 17(2)(b) with rule 16 and the Second Schedule exempts the processing from the whole Act. Ladder steps (0) to (23).
  - Cites `in_dpdp_act_2023_s_17_2`, `in_dpdp_act_2023_s_17_2_b`, `in_dpdp_rules_2025_r_16`, `in_dpdp_rules_2025_r_1_4` and `in_dpdp_rules_2025_sch_2*`.
- `state_processing_standards(Profile, Result, Citations)`: whether State processing under s 7(b) follows the Second Schedule as rule 5(1) requires. Ladder steps (0) to (27).
  - Cites `in_dpdp_rules_2025_r_5_1`, `in_dpdp_act_2023_s_7_b`, `in_dpdp_rules_2025_r_1_4` and `in_dpdp_rules_2025_sch_2*`.
- `state_processing_disapplied_provisions(Profile, Result, Citations)`: which of s 8(7), s 12(2) and s 12(3) s 17(4) disapplies. Ladder steps (0) to (9).
  - Cites `in_dpdp_act_2023_s_17_4`.
- `dpdp_research_state_processing_input_problems(Profile, Problems)`: the typed input check. It yields exactly one solution for any term and never fails or raises.
  - Cites the input contract; it carries no citation output.

### 1.2 Facade (scaffold names kept)

- `decide_dpdp_research_state_processing(Profile, Verdict)`
  - Verdict is `dpdp_research_state_processing_verdict(determinations(ResearchResult, StateStandardsResult, DisappliedResult), Citations)`.
  - The three Results are exactly the contract RESULTs.
  - Citations is the set union, written once each, of the three CITATIONS lists.
  - One solution.
  - Cites as the three queries.
- `dpdp_research_state_processing_status(Profile, Status)`
  - Status is `determinations(ResearchResult, StateStandardsResult, DisappliedResult)`.
  - One solution.
  - Cites as above.
- `dpdp_research_state_processing_checklist(Profile, Checklist)`: query types #2 eligibility and #7 justification.
  - Checklist is `[checklist(research_exemption, Assessment), checklist(state_processing_standards, Assessment)]`.
  - Each Assessment is `assessment(Subject, Decision, Items)` from formalize_lib `assess/6`.
  - Labels are `labels(eligible, undetermined, ineligible)`. The bare atom `indeterminate` is never written (atom shadowing).
  - Every item is `item(RequirementId, Status, cite(Key))`, met items included. Status is `met`, `unmet(Reason)` or `unknown([Key])`. An unsure judgement gives `unknown([Key])`.
  - The checklist is justification only. The contract RESULT governs where the two differ, for example on precedence.
  - Cites per item (see the slice).
- `dpdp_research_state_processing_what_if(Profile, Key, Value, Verdict)`
  - Verdict is the facade verdict on the profile with `Key` overridden to `Value`.
  - Built with kit/query_combinators `what_if/5`, using the closure `decide_dpdp_research_state_processing`.
- `fixtures`: `dpdp_research_state_processing_fixture(Name, Profile)` and `dpdp_research_state_processing_fixture_expected(Name, Query, Result, Citations)`, in fixtures.clausal.

### 1.3 Totality and determinism

- Every query and facade predicate yields exactly ONE solution for every profile, including malformed ones. Malformed profiles give `input_problems/1`.
- No `!`, `->` or `*->`.
- Verdict constants are folded into clause heads (C17), one clause per disjoint route.

## 2. Verdict STATUS atoms

These replace the placeholders `required`, `permitted` and `not_applicable`.

- `research_exemption`: `exempt_from_act`, `not_exempt`, `not_in_force`.
- `state_processing_standards`: `follows_second_schedule`, `does_not_follow_second_schedule`, `not_applicable`, `not_in_force`.
- `state_processing_disapplied_provisions`: `sections_8_7_12_2_and_12_3_do_not_apply`, `sections_8_7_and_12_3_do_not_apply`, `not_applicable`, `not_in_force`.
- `not_in_force` and `not_applicable` are each ONE shared atom.
- Non-final statuses:
  - `indeterminate([Key])`;
  - `needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on([Key-unsure])])`;
  - `input_problems(Problems)`.
- Non-final statuses always carry Citations `[]`.
- Result constructors (exported, never called as queries): `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`, `inputs_relied_on/1`, `provenance/2`.
- Checklist decision labels (facade only): `eligible`, `undetermined`, `ineligible`.

## 3. Profile keys

The profile is `[attribute(Key, Value), ...]`, read only with `profile_get/3`, presence first and then value. There are eighteen keys, listed here in root_exports and input_contract order. Short names from the brief are in brackets; they are documentation only and never identifiers.

1. `section_7_in_force_on_reference_date` [F7]: crisp, true or false.
2. `section_17_in_force_on_reference_date` [F17]: crisp.
3. `reference_date` [D]: `date(Year, Month, Day)`, bare integers, a real Gregorian day, Year at least 1, no upper bound.
4. `processing_necessary_for_research_archiving_or_statistical_purposes` [R]: judgement, true, false or unsure.
5. `personal_data_to_be_used_for_decision_specific_to_data_principal` [X]: crisp.
6. `processing_for_section_7_b_use` [S7]: judgement.
7. `lawful_manner` [A]: judgement.
8. `limited_to_necessary_personal_data` [C]: judgement.
9. `completeness_accuracy_and_consistency` [DC]: judgement.
10. `retention_only_while_required` [E]: judgement.
11. `reasonable_security_safeguards` [FS]: judgement.
12. `intimation_to_data_principal` [G]: crisp.
13. `business_contact_for_questions` [GI]: crisp.
14. `link_and_means_to_exercise_rights` [GII]: crisp.
15. `consistent_with_other_applicable_standards` [GIII]: judgement.
16. `accountability_for_observance` [H]: judgement.
17. `processing_by_state_or_instrumentality` [SI]: judgement.
18. `purpose_includes_decision_affecting_data_principal` [PD]: judgement.

There are no numeric or money keys, and no attested envelopes.

## 4. Citation-key atoms

These come from the canonical `_lexicon/citations.yaml`. They are never shortened or invented.

- `in_dpdp_act_2023_s_7_b`
- `in_dpdp_act_2023_s_17_2`
- `in_dpdp_act_2023_s_17_2_b`
- `in_dpdp_act_2023_s_17_4`
- `in_dpdp_rules_2025_r_1_4`
- `in_dpdp_rules_2025_r_5_1`
- `in_dpdp_rules_2025_r_16`
- `in_dpdp_rules_2025_sch_2`
- `in_dpdp_rules_2025_sch_2_a`
- `in_dpdp_rules_2025_sch_2_b`
- `in_dpdp_rules_2025_sch_2_c`
- `in_dpdp_rules_2025_sch_2_d`
- `in_dpdp_rules_2025_sch_2_e`
- `in_dpdp_rules_2025_sch_2_f`
- `in_dpdp_rules_2025_sch_2_g`
- `in_dpdp_rules_2025_sch_2_g_i`
- `in_dpdp_rules_2025_sch_2_g_ii`
- `in_dpdp_rules_2025_sch_2_g_iii`
- `in_dpdp_rules_2025_sch_2_h`

The citations module lists all nineteen in `citation_vocabulary`.

## 5. Planned reuse (manifest `uses:`)

**formalize_lib**
- `profile_get/3`, `profile_has/2` and `profile_lacks/2`: all key reads.
- `assess/6`, `item/3`, `unmet/1`, `unknown/1` and `labels/3`: the facade checklist. The requirement closure is `dpdp_research_state_processing_requirement`, called as `(RequirementId, Profile, Status, Citation)`.
- `memberd/2` and `not_member/2`: duplicate and unknown-key scans in the input check.
- `check_tri/4` and `check_tri_neg/4` are NOT used in the ladders. Unsure must refer, not count as Kleene unknown, so the ladder reads states directly. They MAY be used in checklist requirement rows, where unsure maps to `unknown([Key])`.

**kit/query_combinators**
- `what_if/5`, for `dpdp_research_state_processing_what_if/4`.

**validate_props** (tests only)
- `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2` and `prop_missing_key_coverage/3`.
- Boundary points for the commencement date: 12 May 2027, 13 May 2027 and 14 May 2027.

**Not used: library(datetime) and kit/deadline_lib, for dates**
- The contract allows Year above 9999, which `datetime.date` cannot hold.
- Calendar validation and comparison are integer-based in kernel.clausal.
- This is flagged in NOTES as a candidate kit module (`kit/calendar_day`).

**No `_common` backbone predicates are needed.**

## 6. kernel.clausal (shared floor — only what more than one query needs)

- `dpdp_research_state_processing_key_order(Keys)`: the eighteen keys in contract order.
- `dpdp_research_state_processing_key_type(Key, Type)`: Type is `judgement`, `crisp` or `calendar_day`.
- `dpdp_research_state_processing_key_state(Profile, Key, State)`: a total classifier for judgement and crisp keys. State is `absent`, `true`, `false` or `unsure`. It is called only after the input check is empty, so each key appears at most once.
- `dpdp_research_state_processing_valid_calendar_day(Term, Verdict)`:
  - Verdict is `valid` or `invalid`.
  - The predicate is total and two-route.
  - It checks a ground `date/3` of integers, Year at least 1, Month 1 to 12, and Day from 1 to the month length.
  - The leap rule is Gregorian: divisible by 4, except by 100, unless by 400.
- `dpdp_research_state_processing_day_before(DateOne, DateTwo, Verdict)`:
  - Verdict is `before` or `not_before`.
  - Lexicographic integer comparison of (Year, Month, Day).
- `dpdp_research_state_processing_input_problems/2`:
  - The input check of NOTES <<DNUM>>, shared by all three queries.
  - Built on helpers that classify the profile term as `attribute_list` or `not_attribute_list` without raising: unbound, partial or improper lists and non-`attribute/2` elements all classify as `not_attribute_list`.
- `dpdp_research_state_processing_first_step(Steps, Profile, Result, Citations)`: the cut-free decision-list walker.
  - Each step is `step(Test, Result, Citations)`.
  - Each Test is a closure called as `Test(Profile, Verdict)`, with Verdict `holds` or `does_not_hold`.
  - The walker returns the first step whose Test holds, so it yields exactly one solution.
- Referral-shape constructor helper: `dpdp_research_state_processing_referral(Key, CitationKey, Result)`. It builds `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on([Key-unsure])])`.

## 7. Slice: dpdp_research_state_processing.clausal

This slice is self-contained for all three determinations. It owns its value facts, its ladders, its checklist requirements and its per-rule tests.

### 7.1 Value facts owned here

- `:- constant_value(rules_five_and_sixteen_commencement_date, date(2027, 5, 13)).`
  - Source: rule 1(4), eighteen months after 13 November 2025.
  - The date is calculated, not stated (Q4).
  - Read with `constant(rules_five_and_sixteen_commencement_date)` and compared through kernel `day_before/3`. The test is: D before the constant means `not_in_force`; on the day or after means it passes.
- Citation-list facts, one per final outcome. These keep the citations the same however a result is reached:
  - `research_not_in_force_citations`: `[r_1_4, r_16, s_17_2, s_17_2_b]`.
  - `research_not_exempt_citations`: `[s_17_2, s_17_2_b, r_16]`.
  - `research_exempt_citations`: `[s_17_2, s_17_2_b, r_16, sch_2, sch_2_a, sch_2_b, sch_2_c, sch_2_d, sch_2_e, sch_2_f, sch_2_h]`.
  - `state_not_in_force_citations`: `[r_1_4, r_5_1, s_7_b]`.
  - `state_not_applicable_citations`: `[r_5_1, s_7_b]`.
  - `state_does_not_follow_citations`: `[r_5_1, sch_2]`.
  - `state_follows_citations`: `[r_5_1, sch_2, sch_2_a .. sch_2_h with g, g_i, g_ii, g_iii]`.
  - `disapplied_citations`: `[s_17_4]`, for all four outcomes.
  - The short names above are for this document only. In the code, every atom is the full `in_dpdp_..._*` key wrapped in `cite/1`.
- Referral-citation rows, `referral_citation(Query, Key, CitationKey)`:
  - research: R uses `s_17_2_b`; A uses `sch_2_a`; C uses `sch_2_c`; DC uses `sch_2_d`; E uses `sch_2_e`; FS uses `sch_2_f`; H uses `sch_2_h`.
  - state: S7 uses `s_7_b`; A, C, DC, E, FS and H use `sch_2_a`, `sch_2_c`, `sch_2_d`, `sch_2_e`, `sch_2_f` and `sch_2_h`; GIII uses `sch_2_g_iii`.
  - disapplied: SI and PD use `s_17_4`.
- Standard groups:
  - `research_standard_keys`: [A, C, DC, E, FS, H].
  - `state_standard_keys`: [A, C, DC, E, FS, G, GI, GII, GIII, H].
  - Both are in root order.

### 7.2 Rules / requirements (ladders exactly as in THE LIMBS)

**research_exemption** (reads F17, D, R, X, A, C, DC, E, FS, H)
- (0) Input problems are non-empty: `input_problems(Problems)`, `[]`.
- (1) F17 false: `not_in_force`.
- (2) D before the commencement constant: `not_in_force`.
- (3) F17 absent: `indeterminate([section_17_in_force_on_reference_date])`.
- (4) D absent: `indeterminate([reference_date])`.
- (5) R false: `not_exempt`.
- (6) X true: `not_exempt`.
- (7) Any research standard false: `not_exempt`.
- (8) to (15) The first absent key in the order R, X, A, C, DC, E, FS, H: `indeterminate([Key])`.
- (16) to (22) The first unsure key in the order R, A, C, DC, E, FS, H: the referral.
- (23) Otherwise: `exempt_from_act`.

**state_processing_standards** (reads F7, D, S7 and the ten standard keys)
- (0) Input problems.
- (1) F7 false: `not_in_force`.
- (2) D before the constant: `not_in_force`.
- (3) F7 absent: `indeterminate([section_7_in_force_on_reference_date])`.
- (4) D absent: `indeterminate([reference_date])`.
- (5) S7 false: `not_applicable`.
- (6) S7 absent: `indeterminate([processing_for_section_7_b_use])`.
- (7) S7 unsure and any standard false: the referral on S7.
- (8) Any standard false: `does_not_follow_second_schedule`.
- (9) to (18) The first absent standard in root order: `indeterminate([Key])`.
- (19) S7 unsure: the referral.
- (20) to (26) The first unsure judgement standard in the order A, C, DC, E, FS, GIII, H: the referral.
- (27) Otherwise: `follows_second_schedule`.

**state_processing_disapplied_provisions** (reads F17, SI and PD; never D)
- (0) Input problems.
- (1) F17 false: `not_in_force`.
- (2) F17 absent: `indeterminate([section_17_in_force_on_reference_date])`.
- (3) SI false: `not_applicable`.
- (4) SI absent: `indeterminate([processing_by_state_or_instrumentality])`.
- (5) PD absent: `indeterminate([purpose_includes_decision_affecting_data_principal])`.
- (6) SI unsure: the referral.
- (7) PD unsure: the referral.
- (8) PD false: `sections_8_7_12_2_and_12_3_do_not_apply`.
- (9) Otherwise: `sections_8_7_and_12_3_do_not_apply`.

### 7.3 Step tests

Each test is local to the slice and total, with two routes each.

- `key_has_state(Key, State, Profile, Verdict)`.
- `date_before_commencement(Profile, Verdict)`. When D is absent, the verdict is `does_not_hold`.
- `any_key_false(Keys, Profile, Verdict)`.
- `first_key_in_state(Keys, State, Profile, Found)`. Found is `found(Key)` or `none`. It drives the grouped absent and unsure steps, which keeps the steps as one decision list.
- `key_unsure_and_any_false(Key, Keys, Profile, Verdict)`.

### 7.4 Checklist requirements (facade #2 / #7)

The predicate is `dpdp_research_state_processing_requirement(RequirementId, Profile, Status, Citation)`, with three mutually exclusive clauses per check: met, unmet or unknown.

**Research requirement IDs**
- `section_seventeen_in_force`: cites `s_17_2`.
- `rule_sixteen_in_force`: cites `r_1_4`.
- `research_archiving_or_statistical_purpose`: cites `s_17_2_b`.
- `no_decision_specific_to_data_principal`: cites `s_17_2_b`.
- `standard_lawful_manner`: cites `sch_2_a`.
- `standard_necessary_data_only`: cites `sch_2_c`.
- `standard_completeness_accuracy_consistency`: cites `sch_2_d`.
- `standard_retention`: cites `sch_2_e`.
- `standard_security_safeguards`: cites `sch_2_f`.
- `standard_accountability`: cites `sch_2_h`.

**State requirement IDs**
- `section_seven_in_force`: cites `s_7_b`.
- `rule_five_in_force`: cites `r_1_4`.
- `section_seven_b_use`: cites `s_7_b`.
- The ten standards, including `standard_intimation` (`sch_2_g`), `standard_business_contact` (`sch_2_g_i`), `standard_link_and_means` (`sch_2_g_ii`) and `standard_other_applicable` (`sch_2_g_iii`).

**Statuses**
- Absent or unsure gives `unknown([Key])`.
- False, or a date before the constant, gives `unmet(Reason)`. Reasons are full-word atoms, for example `not_in_force_on_reference_date` and `standard_not_observed`.

### 7.5 Shared with kernel

These are the only shared predicates:
- key state;
- calendar-day validity and comparison;
- the input check;
- the decision-list walker;
- the referral constructor.

Everything else (the constant, the citation lists, the ladders and the requirements) stays in this slice.

### 7.6 Tests (seven modes, v2 manifest)

1. **load**: the package loads.
2. **unit**: one test per ladder step per query. That is 24 for research, 28 for state and 10 for disapplied, each pairing a positive with a `fail` negative over the same case.
3. **boundary**: 12 May 2027 gives `not_in_force`. 13 May 2027 and 14 May 2027 proceed. Year 10000 is valid. Year 0 and 29 February 2027 give `wrong_type(reference_date)`. 29 February 2028 is valid.
4. **counting**: `findall` with `length(_, 1)` for every fixture and every query.
5. **input check**: duplicate, wrong type, unknown key in first-occurrence order, non-list, partial list, unbound element, non-atom key, unbound value, and checks for no failure and no raising.
6. **property**: validate_props totality, determinism, citation completeness and missing-key coverage.
7. **fixtures/golden**: expected (Result, Citations) per fixture. Citations are compared as sorted sets.
