# SIGNATURE — sg/data_protection/pdpa_data_breach_notification

## Overview

This is the public query surface of a deontic domain over PDPA 2012 Part 6A and S 64/2021.

- **Called contract.** Eight queries plus the input check (INTERFACE - THE CALLED CONTRACT). They are exported under the exact names the contract gives. The input check carries the package prefix.
- **Scaffold facade.** The facade predicates wrap pdpa_breach_assessment/2.
- **Totality.** Every query, and the input check, yields exactly ONE solution for every term it is given.
- **Determinism without cuts.** Each ladder step is a clause whose guard negates every earlier step (or is written over disjoint values in the head). There is no cut, no if-then-else and no once/1.
- **Presence before value.** Every profile key is read with profile_get/3, presence first and then value. The input check rejects duplicates first, so profile_get/3 never returns two values.
- **No outside facts.** The order reads no outside facts. All statutory figures are declared once as constant_value/2 in the slice.
- **Native dates.** Date logic uses native library(datetime). The interface terms are date(Y, M, D). Internally the order builds date objects with date/4, because date/3 is not registered yet. It never hand-rolls a day count.

## Verdict STATUS atoms (replacing the placeholder required/permitted/not_applicable)

### Final statuses, by query

- **significant_harm/3:** significant_harm | no_significant_harm
- **significant_scale/3:** significant_scale | no_significant_scale
- **data_breach_notifiability/3:** notifiable | not_notifiable | not_applicable. This is the facade STATUS.
- **individual_notification/3:** required | not_required | prohibited | waived | not_applicable
- **breach_response_duty/3:** assessment_required | notify_organisation_without_undue_delay | notify_public_agency_without_undue_delay | no_duty_triggered | not_applicable
- **pdpa_breach_assessment/2:** the field atom n_a is used for 'not applicable to this field'.

### Non-final statuses

A non-final status always has CITATIONS []. It is EXACTLY ONE of:

- indeterminate([KEY]) — exactly one bare key atom. The bare atom indeterminate is never written.
- needs_legal_review(open_textured(KEY, cite(K)), [inputs_relied_on(PAIRS)])
- input_problems(PROBLEMS)

### Eligibility mapping (query type #2)

pdpa_data_breach_notification_status/2 returns the DECISION as is:

- notifiable is the positive label (the duty applies, i.e. 'eligible' for the duty);
- not_notifiable and not_applicable are the negative labels;
- indeterminate(...), needs_legal_review(...) and input_problems(...) are the indeterminate statuses.

### Result constructors

These are exported and never called as queries:

indeterminate/1, needs_legal_review/2, open_textured/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, inputs_relied_on/1, provenance/2, pdpa_breach/5, content_item/2, additional_item/3, date/3, cite/1, item/3, pdpa_data_breach_notification_verdict/2.

## Profile keys

The nineteen keys, in root_exports / input_contract order:

| # | Key | Type |
|---|-----|------|
| 1 | breach_occurred_date | date(Year, Month, Day), a real Gregorian day |
| 2 | within_organisation_only | crisp: true or false |
| 3 | breach_kinds | non-empty proper list of: unauthorised_access, unauthorised_collection, unauthorised_use, unauthorised_disclosure, unauthorised_copying, unauthorised_modification, unauthorised_disposal, loss_of_storage_medium |
| 4 | is_data_breach | judgement: true, false or unsure |
| 5 | breached_data | proper list (possibly empty) of the thirty data class atoms |
| 6 | publicly_available_or_lawfully_disclosed | proper list (possibly empty) of the twenty-five Schedule Part 1 atoms |
| 7 | assessed_likely_significant_harm | judgement |
| 8 | affected_individuals_count | non-negative integer (a count of persons, no unit suffix) |
| 9 | assessed_likely_significant_scale | judgement |
| 10 | prohibited_by_law_enforcement_agency | crisp |
| 11 | prohibited_by_commission_direction | crisp |
| 12 | commission_waiver_granted | crisp |
| 13 | remedial_action_renders_harm_unlikely | judgement |
| 14 | prior_technological_measure_renders_harm_unlikely | judgement |
| 15 | assessment_date | date(Year, Month, Day) |
| 16 | caller_role | organisation, data_intermediary_for_organisation or data_intermediary_for_public_agency |
| 17 | reason_to_believe_breach_occurred | judgement |
| 18 | personal_data_in_possession_or_control | crisp |
| 19 | notified_by_data_intermediary | crisp |

The thirty data classes are:

- **Identity anchors:** full_name_or_alias, identification_number.
- **Account pair:** account_identifier, account_access_credential.
- **Schedule Part 1 items:** remuneration, income_from_sale_of_goods_or_property, payment_card_number, bank_or_finance_company_account_number, child_or_young_person_information, vulnerable_adult_information, specified_offence_victim_identification, place_of_safety_resident_identification, private_key, net_worth, deposit_of_moneys, withdrawal_of_moneys, credit_facilities, other_liabilities_incurred, payments_or_property_received, creditworthiness, capital_markets_investment, debts, insurance_policy_information, specified_medical_condition_treatment, reproductive_or_contraceptive_treatment, organ_donation_or_transplant, suicide_or_attempted_suicide, domestic_child_or_sexual_abuse, adoption_information.
- **Residual:** other_personal_data.

## Citation-key atoms

These follow the canonical scheme of _lexicon/citations.yaml. Each is written inside cite/1, and no shortened atom is ever invented. The atoms def and n_a are mandated by the lexicon and the contract; record a C6 allow-pragma for them.

**PDPA 2012:**

- sg_pdpa_2012_s26a_def_databreach
- sg_pdpa_2012_s26b_1_a, sg_pdpa_2012_s26b_1_b, sg_pdpa_2012_s26b_2_a, sg_pdpa_2012_s26b_3_a, sg_pdpa_2012_s26b_4
- sg_pdpa_2012_s26c_1, sg_pdpa_2012_s26c_2, sg_pdpa_2012_s26c_3, sg_pdpa_2012_s26c_3_a, sg_pdpa_2012_s26c_3_b
- sg_pdpa_2012_s26d_1, sg_pdpa_2012_s26d_2, sg_pdpa_2012_s26d_5_a, sg_pdpa_2012_s26d_5_b, sg_pdpa_2012_s26d_6_a, sg_pdpa_2012_s26d_6_b, sg_pdpa_2012_s26d_7
- sg_pdpa_2012_s26e_a, sg_pdpa_2012_s26e_b

**S 64/2021, regulations:**

- sg_pdpa_2012_s64_2021_reg_3_1_a, sg_pdpa_2012_s64_2021_reg_3_1_b, sg_pdpa_2012_s64_2021_reg_3_2
- sg_pdpa_2012_s64_2021_reg_4
- sg_pdpa_2012_s64_2021_reg_5_1_a, _5_1_b, _5_1_c, _5_1_d, _5_1_e, _5_1_f, _5_1_g, _5_1_h, _5_1_i
- sg_pdpa_2012_s64_2021_reg_5_2, sg_pdpa_2012_s64_2021_reg_5_3
- sg_pdpa_2012_s64_2021_reg_6_a, _6_b, _6_c, _6_d, _6_e, _6_f

**S 64/2021, Schedule:**

- sg_pdpa_2012_s64_2021_sched_1_item_1 to sg_pdpa_2012_s64_2021_sched_1_item_23, including sg_pdpa_2012_s64_2021_sched_1_item_6a and sg_pdpa_2012_s64_2021_sched_1_item_6b
- sg_pdpa_2012_s64_2021_sched_2_item_1, sg_pdpa_2012_s64_2021_sched_2_item_2

The abbreviated forms above (for example _5_1_b) stand for the full atom with the same prefix, for example sg_pdpa_2012_s64_2021_reg_5_1_b. Every atom is spelled in full in the code.

Citations deliberately NOT given a key: s 26C(4), s 26D(3), (4), (8), (9), reg 1, reg 2, Schedule Part 2 paragraph 3, and Interpretation Act s 50. None of them is load-bearing; see NOTES S3.

## Public predicates (one line each)

### The called contract

- `significant_harm(Profile, Result, Citations)`: the nine-step SIGNIFICANT_HARM ladder (deemed routes reg 3(1)(b), reg 3(2), reg 3(1)(a) with Schedule Part 2; then the judgement). Cites s 26B(1)(a), s 26B(2)(a), reg 3, and Schedule Parts 1 and 2.
- `significant_scale(Profile, Result, Citations)`: the six-step SIGNIFICANT_SCALE ladder (count >= 500, then the judgement). Cites s 26B(1)(b), s 26B(3)(a), reg 4.
- `data_breach_notifiability(Profile, Result, Citations)`: the thirteen-step ladder (commencement, data breach, the s 26B(4) exclusion, both grounds). Cites s 26C(1), s 26A, s 26B, plus the ground citations.
- `individual_notification(Profile, Result, Citations)`: the fourteen-step ladder with the exception answer E1 to E13. Cites s 26D(2), (5)(a), (5)(b), (6)(a), (6)(b), (7), and s 26B(1)(a), s 26B(4), s 26A, s 26C(1).
- `breach_response_duty(Profile, Result, Citations)`: the role ladder. Cites s 26C(2), s 26C(3), (3)(a), (3)(b), s 26E(a), (b), s 26C(1).
- `commission_notification_period_end(AssessedDate, EndDate)`: the assessed date plus 3 calendar days, with no move for holidays (main reading, Q1); input_problems([wrong_type(assessed_date)]) if the date is not a real day. Cites s 26D(1); the citation is added by pdpa_breach_assessment.
- `notification_contents(Topic, Items)`: one fixed list per topic (commission, affected_individual, commission_additional), returned as a single solution. Cites reg 5(1)(a) to (i), reg 6(a) to (f), reg 5(2), reg 5(3).
- `pdpa_breach_assessment(Profile, Result)`: the combined answer pdpa_breach(Decision, Grounds, CommissionDeadline, Individuals, Citations). Cites the union of the citations of the parts plus s 26D(1).
- `pdpa_data_breach_notification_input_problems(Profile, Problems)`: THE INPUT CHECK. It reports duplicate_key, then wrong_type per key in contract order, then unknown_key in first-occurrence order, or [wrong_type(profile)]. It never fails and never raises.

### Scaffold facade (names kept)

- `decide_pdpa_data_breach_notification(Profile, pdpa_data_breach_notification_verdict(Status, Citations))`: Status is the Decision of pdpa_breach_assessment/2 and Citations its Citations (verdict with justification, query type #7).
- `pdpa_data_breach_notification_status(Profile, Status)`: the Decision only (eligibility verdict, query type #2).
- `pdpa_data_breach_notification_checklist(Profile, Checklist)`: a list of item(RequirementIdentifier, Status, cite(Key)), one per requirement, in this order:
  - commencement — s 26C(1);
  - data_breach — s 26A;
  - not_excluded_within_organisation — s 26B(4);
  - significant_harm_ground — s 26B(1)(a);
  - significant_scale_ground — s 26B(1)(b);
  - individual_notice — s 26D(2);
  - response_duty — s 26C(2).

  Each Status is met, unmet(Reason) or unknown([Key]). Every item carries cite(...), met items included. The checklist is built with eval_requirements/4; the verdict always comes from the ladder, never from decide_labeled.
- `pdpa_data_breach_notification_what_if(Profile, Key, Value, Status)`: the Status after overriding Key with Value, via what_if/5 with the closure pdpa_data_breach_notification_status.
- `pdpa_data_breach_notification_fixture(Name, Profile)` and `pdpa_data_breach_notification_fixture_expected(Name, Query, Expected)`: the named fixtures in fixtures.clausal (see 'Fixtures').

## Planned reuse (manifest uses:)

- **formalize_lib:**
  - profile_get/3, profile_has/2, profile_lacks/2 — presence and value reads;
  - memberd/2 and not_member/2 — deterministic membership over list keys with repeats;
  - eval_requirements/4 and item/3 — the checklist;
  - attribute/2 — the profile shape.

  check_tri/4 and check_tri_neg/4 are used for the judgement-valued checklist items, so no tri-valued check is hand-rolled (C15).
- **library(datetime):**
  - date_add/3 and timedelta/3 — the plus-3-days arithmetic;
  - ordinal/2 — the chronological comparison against 2021-02-01, integer ordinals of date objects, never @< on a compound;
  - date_string_iso/2 — reading the result back to Y, M, D if date/4 does not decompose an object.

  The date object is built with date/4, date(Y, M, D, Object).
- **kit/deadline_lib:** month_last_day/3, to check that a date(Y, M, D) is a real Gregorian day in the input check WITHOUT constructing an object (construction could raise; the check must never raise).
- **kit/query_combinators:** what_if/5, for the what_if facade.
- **validate_props (tests only):** run_props/1, prop_totality/3, prop_determinism/3, prop_citation_complete/3, prop_boundary_coverage/2, prop_missing_key_coverage/3, bad_citation/1.

Not used: kit/compliance_lib. Its deny-overrides modality lattice would impose a priority the text does not state; the drafter's priority is explicit in the ladder (Q2). Also not used: currency_vocab, vat_category, country, rolling_window.

## Package layout (unchanged)

kernel -> citations -> parameters -> pdpa_data_breach_notification -> queries -> fixtures -> package facade.

- **citations.clausal:** the citation vocabulary, one fact per atom.
- **parameters.clausal:** stays a re-export point only. The figures live in the slice (see below).
- **queries.clausal:** the facade and checklist.
- **fixtures.clausal:** the fixtures.

## kernel.clausal (shared floor — only what more than one module needs)

- **pdpa_data_breach_notification_input_problems/2** — THE INPUT CHECK. Every slice query runs it as step (0), and the facade calls it too.
  - It walks the raw list structurally, using var/1 and nonvar/1 at every cell, so it never unifies a partial list.
  - The profile shape is tested first: an unbound profile, a partial list, an unbound element, or any non-attribute(K, V) element gives [wrong_type(profile)].
  - Then duplicate_key or wrong_type per contract key, then unknown_key (a non-atom key is kept as given).
- **Type predicates:** `real_gregorian_date(Term)`, `judgement_value(Value)`, `crisp_value(Value)`, `breach_kind(Atom)`, `data_class(Atom)`, `schedule_part_one_class(Atom, CitationKey)`.
- **`relied_on_pairs(Profile, JudgementKeys, Pairs)`** — THE PAIRS RULE: Key-Value pairs of the present judgement keys, in root_exports order.
- **`citation_set(Lists, Set)`** — sort/2 over cite/1 terms (set-like, deduplicated).
- **`date_object(date(Y, M, D), Object)`** — the date/4 bridge.

## Slice: pdpa_data_breach_notification.clausal

This is the self-contained determination: notifiability, notice to individuals, response duty, the Commission's period, notice contents, and the combined assessment.

### Value facts owned here

- `:- constant_value(prescribed_number_of_affected_individuals, 500).` — reg 4; compared with >=.
- `:- constant_value(commission_notification_calendar_days, 3).` — s 26D(1).
- `:- constant_value(commencement_year, 2021).`, `:- constant_value(commencement_month, 2).`, `:- constant_value(commencement_day, 1).` — s 26C(1), 'on or after'.
- The six excludable breach kinds (s 26B(4)): `excludable_breach_kind/1` facts for the first six breach kinds.
- The Schedule Part 1 table: `schedule_part_one_item(DataClass, CitationKey)`, twenty-five rows in item order 1, 2, 3, 4, 5, 6, 6a, 6b, 7 to 23.
- The identity anchors: `identity_anchor/1` for full_name_or_alias and identification_number.
- The notice content tables:
  - `commission_content_item/2`, nine rows;
  - `individual_content_item/2`, six rows;
  - `commission_additional_item/3`, two rows;

  with the atoms and citations exactly as the contract lists them.

### Rules (each a ladder; first applicable step decides; guard clauses mutually exclusive)

1. **significant_harm.** The steps are 1 to 9 of the contract.
   - In step 3 the Schedule citations are cite(K) for each Part 1 atom of breached_data not in publicly_available_or_lawfully_disclosed. Repeats are removed by citation_set.
   - Step 6 fires only when the anchor and a Part 1 atom are present and the exclusion list is absent.
   - The PAIRS list is [assessed_likely_significant_harm].
2. **significant_scale.** The steps are 1 to 6. N >= constant(prescribed_number_of_affected_individuals). The PAIRS list is [assessed_likely_significant_scale].
3. **data_breach_notifiability.** The steps are 1 to 13.
   - The predicates `exclusion_applies/1` and `exclusion_settled_not_to_apply/1` are defined as in the contract.
   - Step 5 merges the citations of both 'no' grounds.
   - Step 12 merges the citations of each significant ground.
   - Step 13 copies the REASON of HARM first, else of SCALE, and rebuilds CONTEXT with this query's PAIRS list: [is_data_breach, assessed_likely_significant_harm, assessed_likely_significant_scale].
4. **individual_notification.** The steps are 1 to 14. The `exception_answer(Profile, Answer, Citations)` predicate gives E1 to E13. SCALE is never read. The PAIRS list is [is_data_breach, assessed_likely_significant_harm, remedial_action_renders_harm_unlikely, prior_technological_measure_renders_harm_unlikely].
5. **breach_response_duty.**
   - The steps are 1 to 6, with 6(a) to 6(h) for the organisation role.
   - The public-agency branch (step 2) comes before the date steps and never reads the date.
   - No answer carries a period end.
   - The PAIRS list is [reason_to_believe_breach_occurred].
6. **commission_notification_period_end.** This rule has two clauses.
   - If `real_gregorian_date(Assessed)` fails, the end is input_problems([wrong_type(assessed_date)]).
   - Otherwise the rule builds the date object with date/4, applies date_add/3 with timedelta(constant(commission_notification_calendar_days), 0, Delta), and reads the result back to date(Y, M, D) with bare integers.
   - Expected boundaries:
     - 2026-01-01 -> 2026-01-04
     - 2026-02-27 -> 2026-03-02
     - 2028-02-27 -> 2028-03-01
     - 2026-12-30 -> 2027-01-02
     - 2026-01-02 -> 2026-01-05 (no holiday move)
7. **notification_contents.** One clause per topic. A findall over the table builds a single list, giving one solution. The topic is never checked.
8. **pdpa_breach_assessment.**
   - (1) Input problems.
   - (2) The DECISION.
   - (3) GROUNDS, in the order significant_harm then significant_scale, only when the DECISION is notifiable.
   - (4) The DEADLINE: the period end, or indeterminate([assessment_date]), or n_a.
   - (5) INDIVIDUALS: the individual_notification result, or n_a.
   - (6) The citation set, adding cite(sg_pdpa_2012_s26d_1) only when the deadline is a date.
   - A non-final DECISION gives [], n_a, n_a, [].

### Verdict atoms

The atoms are those of 'Verdict STATUS atoms' above. The facade STATUS is the DECISION of data_breach_notifiability.

### Shared predicates

This slice must SHARE (and so takes from kernel) only: the input check, the type predicates, relied_on_pairs/3, citation_set/2 and date_object/2. Everything else is local.

## Fixtures (fixtures.clausal) and the seven test modes

### Named fixtures

Each is a minimal profile reaching one step.

**Commencement:**

- fixture_pre_commencement — date 2021-01-31: not_applicable.
- fixture_commencement_day — date 2021-02-01: in scope.

**Deemed harm:**

- fixture_deemed_harm_account_pair — reg 3(1)(b).
- fixture_deemed_harm_bank_account_number — reg 3(2).
- fixture_deemed_harm_identity_and_schedule — reg 3(1)(a).
- fixture_schedule_data_all_publicly_available — route (a) is defeated, so the judgement is read.

**Scale:**

- fixture_scale_499 and fixture_scale_500 — the reg 4 boundary.

**Within-organisation exclusion:**

- fixture_within_organisation_excluded
- fixture_within_organisation_with_disposal — not excluded.

**Grounds:**

- fixture_scale_only_no_individual_notice

**Exceptions to the notice to individuals:**

- fixture_law_enforcement_and_waiver — prohibited (Q2).
- fixture_waiver_only — waived.
- fixture_remedial_action — not_required.
- fixture_exception_settles_with_harm_unsure — not_required with only the s 26D(5)(a) citation (Q4).

**Referrals:**

- fixture_unsure_is_data_breach — needs_legal_review.

**Missing keys:**

- fixture_missing_breach_date_first — indeterminate([breach_occurred_date]).

**Response duty:**

- fixture_public_agency_intermediary_no_date
- fixture_intermediary_for_organisation
- fixture_organisation_notified_by_intermediary

**Input check:**

- fixture_duplicate_key
- fixture_unknown_key_non_atom
- fixture_partial_list_profile
- fixture_invalid_date_2026_02_30

**Combined assessment:**

- fixture_full_notifiable_with_deadline

### Test modes

1. **Unit:** per-rule tests, one or more per ladder step.
2. **Boundary:** 499 and 500; 2021-01-31 and 2021-02-01; the month, year and leap-year carry of the period end.
3. **Missing-key:** each key named alone and first (prop_missing_key_coverage).
4. **Referral:** each unsure judgement gives needs_legal_review with the exact PAIRS.
5. **Input-check:** duplicate, wrong type, unknown key, a malformed profile, unbound terms; never fails and never raises.
6. **Counting/determinism:** findall length 1 for every query on every fixture (prop_totality, prop_determinism), including profiles with repeated list atoms.
7. **Citation-completeness:** every final result carries only atoms of the citation vocabulary, and every non-final result carries [] (prop_citation_complete, bad_citation).

Every `fail` test is paired with a positive test over the same fixture.
