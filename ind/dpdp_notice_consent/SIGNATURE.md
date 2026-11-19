# SIGNATURE — ind/dpdp_notice_consent

## Public query surface (summary)

The package facade exposes these predicates.

Eligibility (query type #2):

- `decide_dpdp_notice_consent(Profile, dpdp_notice_consent_verdict(Status, Citations))`
- `dpdp_notice_consent_status(Profile, Status)`

Justification (query type #7):

- `dpdp_notice_consent_checklist(Profile, Checklist)`, with cite(...) on every item

Counterfactual:

- `dpdp_notice_consent_what_if(Profile, Key, Value, Status)`

The six contract queries are also exported. Each takes one input and gives two outputs, except provision_lists, which gives one output:

- `consent_ground/3`
- `legitimate_use_ground/3`
- `consent_notice/3`
- `withdrawal_effect/3`
- `consent_manager_status/3`
- `provision_lists/2`

The input check is `dpdp_notice_consent_input_problems/2`.

Guarantees:

- Every query is total and deterministic. It yields EXACTLY ONE solution for every input. This is achieved by mutually exclusive guarded clauses, with no `!`, `->` or `*->`, and with ground outputs folded into clause heads (C17).
- The domain imports no figures. Its single statutory value fact lives in the slice.

## Verdict STATUS atoms (replace scaffold placeholders)

The placeholders `{ required, permitted, not_applicable }` are replaced.

The facade Status is one of `eligible`, `ineligible` or `indeterminate`. These are `labels(eligible, indeterminate, ineligible)`. The question is: may the processing rely on the Data Principal's consent on the day asked about (s 4(1)(a))?

The facade Status is mapped from the consent_ground RESULT:

| consent_ground RESULT | Facade Status | Facade Citations |
|---|---|---|
| `lawful_on_consent` | `eligible` | consent_ground CITATIONS |
| `not_lawful_on_consent` | `ineligible` | consent_ground CITATIONS |
| `not_in_force` | `ineligible` | consent_ground CITATIONS |
| `indeterminate(_)` | `indeterminate` | `[]` |
| `needs_legal_review(_, _)` | `indeterminate` | `[]` |
| `input_problems(_)` | `indeterminate` | `[]` |

Contract RESULT atoms (unchanged from the order), by query:

- consent_ground: `lawful_on_consent`, `not_lawful_on_consent`
- legitimate_use_ground: `lawful_on_legitimate_use`, `not_lawful_on_legitimate_use`
- consent_notice: `notice_with_request_required`, `notice_with_request_required_before_rule_3`, `notice_for_earlier_consent_required`, `notice_for_earlier_consent_required_before_rule_3`, `not_required`
- withdrawal_effect: `cease_processing_required`, `processing_may_continue_without_consent`, `not_required`
- consent_manager_status: `may_act_as_consent_manager`, `may_not_act_as_consent_manager`
- every PROFILE query: `not_in_force`
- non-final statuses: `indeterminate([Key])`, `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`, `input_problems(Problems)`

## Profile keys (fourteen, in root_exports / input_contract order)

PROFILE is `[attribute(Key, Value), ...]`. It is read only with `profile_get/3`: presence first (`profile_has/2` / `profile_lacks/2`), then value.

| # | Key | Kind | Values |
|---|---|---|---|
| 1 | `sections_4_to_7_in_force` | crisp | `true` / `false` |
| 2 | `section_6_9_in_force` | crisp | `true` / `false` |
| 3 | `question_date` | date | ground `date(Year, Month, Day)`, a real Gregorian day, Year 1..9999 |
| 4 | `acts_as_data_fiduciary` | judgement | `true` / `false` / `unsure` |
| 5 | `lawful_purpose` | judgement | `true` / `false` / `unsure` |
| 6 | `consent_given` | crisp | `true` / `false` |
| 7 | `consent_withdrawn` | crisp | `true` / `false` |
| 8 | `consent_meets_section_6_1` | judgement | `true` / `false` / `unsure` |
| 9 | `legitimate_use_clause` | enumeration | see below |
| 10 | `legitimate_use_conditions_met` | judgement | `true` / `false` / `unsure` |
| 11 | `notice_occasion` | enumeration | `request_for_consent`, `consent_given_before_commencement`, `no_notice_occasion` |
| 12 | `processing_required_or_authorised_by_law` | judgement | `true` / `false` / `unsure` |
| 13 | `registered_with_board_as_consent_manager` | crisp | `true` / `false` |
| 14 | `consent_manager_registration_suspended_or_cancelled` | crisp | `true` / `false` |

The values of `legitimate_use_clause` are, in this order:

`voluntarily_provided_for_specified_purpose`, `state_subsidy_benefit_service_certificate_licence_or_permit`, `state_function_or_sovereignty_integrity_or_security`, `legal_obligation_to_disclose_to_state`, `compliance_with_judgment_decree_or_order`, `medical_emergency`, `epidemic_outbreak_or_public_health_threat`, `disaster_or_breakdown_of_public_order`, `employment_purposes`, `no_listed_use`.

Other profile rules:

- The domain has no numeric or money key, so no unit suffix applies.
- No `attested(...)` wrapper is used. There are no outside facts.
- Every key states the fact on the day the question is about.

## Citation-key atoms (canonical lexicon, _lexicon/citations.yaml; never shortened)

Each key maps to the pinned unit with the same suffix: `in_dpdp_act_2023_s_X` maps to `in-dpdp-act-2023-meity-pdf#sX`, and `in_dpdp_rules_2025_...` maps to `in-dpdp-rules-2025-meity-pdf#...`.

Act:

- s 2: `in_dpdp_act_2023_s_2_g`, `in_dpdp_act_2023_s_2_i`
- s 4: `in_dpdp_act_2023_s_4_1`, `in_dpdp_act_2023_s_4_1_a`, `in_dpdp_act_2023_s_4_1_b`, `in_dpdp_act_2023_s_4_2`
- s 5: `in_dpdp_act_2023_s_5_1`, `in_dpdp_act_2023_s_5_1_i`, `in_dpdp_act_2023_s_5_1_ii`, `in_dpdp_act_2023_s_5_1_iii`, `in_dpdp_act_2023_s_5_2`, `in_dpdp_act_2023_s_5_2_a`, `in_dpdp_act_2023_s_5_2_a_i`, `in_dpdp_act_2023_s_5_2_a_ii`, `in_dpdp_act_2023_s_5_2_a_iii`, `in_dpdp_act_2023_s_5_3`
- s 6: `in_dpdp_act_2023_s_6_1`, `in_dpdp_act_2023_s_6_3`, `in_dpdp_act_2023_s_6_4`, `in_dpdp_act_2023_s_6_5`, `in_dpdp_act_2023_s_6_6`, `in_dpdp_act_2023_s_6_7`, `in_dpdp_act_2023_s_6_8`, `in_dpdp_act_2023_s_6_9`
- s 7: `in_dpdp_act_2023_s_7`, `in_dpdp_act_2023_s_7_a`, `in_dpdp_act_2023_s_7_b`, `in_dpdp_act_2023_s_7_c`, `in_dpdp_act_2023_s_7_d`, `in_dpdp_act_2023_s_7_e`, `in_dpdp_act_2023_s_7_f`, `in_dpdp_act_2023_s_7_g`, `in_dpdp_act_2023_s_7_h`, `in_dpdp_act_2023_s_7_i`

Rules:

- rule 1: `in_dpdp_rules_2025_r_1_4`
- rule 3: `in_dpdp_rules_2025_r_3`, `in_dpdp_rules_2025_r_3_a`, `in_dpdp_rules_2025_r_3_b`, `in_dpdp_rules_2025_r_3_b_i`, `in_dpdp_rules_2025_r_3_b_ii`, `in_dpdp_rules_2025_r_3_c_i`, `in_dpdp_rules_2025_r_3_c_ii`, `in_dpdp_rules_2025_r_3_c_iii`
- rule 4: `in_dpdp_rules_2025_r_4_2_a`, `in_dpdp_rules_2025_r_4_3`, `in_dpdp_rules_2025_r_4_5_a`
- Second Schedule: `in_dpdp_rules_2025_sch_2_a`, `in_dpdp_rules_2025_sch_2_b`, `in_dpdp_rules_2025_sch_2_c`, `in_dpdp_rules_2025_sch_2_d`, `in_dpdp_rules_2025_sch_2_e`, `in_dpdp_rules_2025_sch_2_f`, `in_dpdp_rules_2025_sch_2_g`, `in_dpdp_rules_2025_sch_2_g_i`, `in_dpdp_rules_2025_sch_2_g_ii`, `in_dpdp_rules_2025_sch_2_g_iii`, `in_dpdp_rules_2025_sch_2_h`
- First Schedule Part A: `in_dpdp_rules_2025_sch_1_parta_1` to `in_dpdp_rules_2025_sch_1_parta_8` (each written out in full: `_1`, `_2`, `_3`, `_4`, `_5`, `_6`, `_7`, `_8`), then `in_dpdp_rules_2025_sch_1_parta_9_a`, `in_dpdp_rules_2025_sch_1_parta_9_b`
- First Schedule Part B: `in_dpdp_rules_2025_sch_1_partb_1`, `in_dpdp_rules_2025_sch_1_partb_2`, `in_dpdp_rules_2025_sch_1_partb_3_a`, `in_dpdp_rules_2025_sch_1_partb_3_b`, `in_dpdp_rules_2025_sch_1_partb_3_c`, `in_dpdp_rules_2025_sch_1_partb_4_a`, `in_dpdp_rules_2025_sch_1_partb_4_b`, `in_dpdp_rules_2025_sch_1_partb_4_c`, `in_dpdp_rules_2025_sch_1_partb_5`, `in_dpdp_rules_2025_sch_1_partb_6`, `in_dpdp_rules_2025_sch_1_partb_7`, `in_dpdp_rules_2025_sch_1_partb_8`, `in_dpdp_rules_2025_sch_1_partb_9`, `in_dpdp_rules_2025_sch_1_partb_10`, `in_dpdp_rules_2025_sch_1_partb_11_a`, `in_dpdp_rules_2025_sch_1_partb_11_b`, `in_dpdp_rules_2025_sch_1_partb_11_c`, `in_dpdp_rules_2025_sch_1_partb_11_d`, `in_dpdp_rules_2025_sch_1_partb_12_a`, `in_dpdp_rules_2025_sch_1_partb_12_b`, `in_dpdp_rules_2025_sch_1_partb_12_c`, `in_dpdp_rules_2025_sch_1_partb_13`

This set is `citation_vocabulary` in citations.clausal. Every cite in every list and step is drawn from it.

## Public predicates (one line each)

Facade:

- `decide_dpdp_notice_consent(Profile, Verdict)`: Verdict = `dpdp_notice_consent_verdict(Status, Citations)`. Status is from the mapping of consent_ground. Citations are those of consent_ground (s 4(1), s 4(1)(a), s 4(2), s 6(1), s 6(4)), or [] when indeterminate. One solution.
- `dpdp_notice_consent_status(Profile, Status)`: the Status of decide_dpdp_notice_consent/2 alone (s 4(1)(a)).
- `dpdp_notice_consent_checklist(Profile, Checklist)`: a list of `item(RequirementId, Status, cite(Key))`, built with `eval_requirements/4` over `dpdp_notice_consent_requirement/4`. If the input check fails, the list is `[item(input_check, unknown(Problems), cite(in_dpdp_act_2023_s_4_1))]`. The items are, in order:
  - `sections_in_force`: s 4(1)
  - `purpose_lawful`: s 4(2)
  - `consent_given_for_purpose`: s 4(1)(a)
  - `consent_not_withdrawn`: s 6(4)
  - `consent_meets_section_6_1`: s 6(1)
- `dpdp_notice_consent_what_if(Profile, Key, Value, Status)`: replaces Key's value with `profile_set/3` and returns `dpdp_notice_consent_status/2` of the result. Same citation as status.

Fixtures:

- `dpdp_notice_consent_fixture(Name, Profile)` in fixtures.clausal: named, ground profiles for every step of every ladder, plus one malformed profile per input-problem kind.

Contract queries:

- `consent_ground(Profile, Result, Citations)`: the s 4(1)(a) ground, ladder steps 0 to 13 (s 4(1), (1)(a), (2), s 6(1), (4)).
- `legitimate_use_ground(Profile, Result, Citations)`: the s 4(1)(b) ground, ladder steps 0 to 11. The final cite is the clause named (s 4(1)(b), s 4(2), s 7, s 7(a) to (i)).
- `consent_notice(Profile, Result, Citations)`: the s 5 notice, ladder steps 0 to 12, with the rule 3 date switch (s 2(i), s 5(1), (2), (2)(a), (3), rule 1(4), rule 3).
- `withdrawal_effect(Profile, Result, Citations)`: the s 6(6) cessation, ladder steps 0 to 11 (s 2(i), s 6(4), (5), (6)).
- `consent_manager_status(Profile, Result, Citations)`: Consent Manager standing, ladder steps 0 to 7 (s 2(g), s 6(7) to (9), rule 4(2)(a), (3), (5)(a)).
- `provision_lists(Topic, Items)`: one fixed list of `content_item(Name, cite(Key))` per topic. Topic is never checked.
- `dpdp_notice_consent_input_problems(Profile, Problems)`: the typed input check. It never fails or raises. It cites the input contract, not a provision.

The result constructors are exported and are never called as queries: `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`, `inputs_relied_on/1`, `provenance/2`, `content_item/2`, `date/3`.

## Planned reuse (manifest `uses:`)

**formalize_lib**

- `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`, `profile_keys/2`
- `check_true/4`, `check_false/4`, `check_tri/4` (judgements: unsure gives unknown)
- `eval_requirements/4` (checklist), `item/3`, `unmet/1`, `unknown/1`, `attribute/2`, `labels/3`
- `memberd/2`, `not_member/2`
- Not re-implemented locally: ratio helpers, check_tri, or the requirement aggregation (lint rules C14, C15, R1).

**kit.deadline_lib**

- `date_before/2` and `date_on_or_after/2`, for question_date against rule_3_commencement_date.
- `month_last_day/3`, for the Gregorian real-day check in the input check.
- No deadline is computed. The two periods in this order have no number (Q9).

**library(datetime)**

- Native date handling. No hand-rolled day count.
- If kit date comparison needs a datetime object, convert with `date_string_iso/2` at the profile boundary. The profile form stays `date(Y, M, D)`.

**validate_props**

- `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2` (12, 13 and 14 May 2027), `prop_missing_key_coverage/3`, `bad_citation/1`.

**Not used**

- compliance_lib: the modality lattice adds nothing to fixed ladders.
- rolling_window.
- currency_vocab, vat_category, country.

**`_common` family backbone (deontic)**

- None beyond formalize_lib. The referral builder is local (see the kernel).

## Layout

```
kernel -> citations -> parameters -> dpdp_notice_consent -> queries -> fixtures -> package facade
```

**kernel.clausal** (the shared floor; only what the slice and the facade both need):

- `dpdp_notice_consent_input_problems/2` and the typed contract: key order, the kind per key, enumeration atom lists, the real-day date check.
- `key_state(Profile, Key, State)`: State is `absent` or `value(V)`. Two exclusive clauses, on `profile_lacks` and `profile_get`. This is safe because duplicates are excluded by the input check run first.
- `relied_pairs(Profile, PairsListKeys, Pairs)`: present judgement keys as `Key-Value`, in root_exports order.
- `referral(Key, CitationKey, Profile, PairsListKeys, needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]))`.
- The result constructors.

**citations.clausal**: `citation_vocabulary/1` and `provenance(Key, Unit)` facts.

**parameters.clausal**: declares no figure of its own. The slice owns its value fact, and nothing is duplicated.

**queries.clausal**: re-exports the six queries. **The facade** holds the eligibility, checklist and what_if predicates.

## Slice: dpdp_notice_consent.clausal

### Value facts owned

- `:- constant_value(rule_3_commencement_date, date(2027, 5, 13)).`
  - Source: rule 1(4), calculated from the 13 November 2025 Gazette header (Q2).
  - It is read only via `constant(rule_3_commencement_date)`.
  - The boundary is inclusive: on or after means rule 3 applies.
- Rule 4's date, 13 November 2026, is NOT declared, because no limb reads it (Q11).
- The provision_lists tables, eight `list_items(Topic, Items)` facts in text order:

| Topic | Items |
|---|---|
| notice_with_request | 4 |
| notice_for_earlier_consent | 4 |
| rule_3_notice | 7 |
| consent_request | 3 |
| legitimate_uses | 9 |
| state_use_standards | 11 |
| consent_manager_conditions | 10 |
| consent_manager_obligations | 22 |

  NAME atoms are exactly as in the order's THE LIMBS, with shared atoms per reading (13).
- The clause-to-citation table, `legitimate_use_citation(ClauseAtom, CitationKey)`: nine facts, s 7(a) to s 7(i).

### Rules / requirements (ladders; first applicable step decides)

Each query reads the states of its keys once with key_state. Each ladder is then a set of mutually exclusive clauses, each guarded by the negation of all earlier steps. The guards are written as state patterns and `dif/2`, never `!` or `->`. Every final head carries its ground RESULT and CITATIONS.

Step 0 in every PROFILE query: if the input check gives a non-empty list, the answer is `input_problems(Problems)` with `[]`.

**consent_ground**

1. sections_4_to_7_in_force absent: `indeterminate([sections_4_to_7_in_force])`.
2. sections_4_to_7_in_force false: `not_in_force`, cite [s_4_1].
3. to 6. Any of the following gives `not_lawful_on_consent`, cite [s_4_1, s_4_1_a, s_4_2, s_6_1, s_6_4]:
   - lawful_purpose false;
   - consent_given false;
   - consent_withdrawn true;
   - consent_meets_section_6_1 false.
7. to 10. The first absent of lawful_purpose, consent_given, consent_withdrawn, consent_meets_section_6_1.
11. lawful_purpose unsure: referral, cite s_4_2.
12. consent_meets_section_6_1 unsure: referral, cite s_6_1.
13. Otherwise: `lawful_on_consent`, cite [s_4_1, s_4_1_a, s_6_1].

PAIRS LIST: lawful_purpose, consent_meets_section_6_1.

**legitimate_use_ground**

1. and 2. As in consent_ground. not_in_force cites [s_4_1].
3. to 5. Any of the following gives `not_lawful_on_legitimate_use`, cite [s_4_1, s_4_1_b, s_4_2, s_7]:
   - lawful_purpose false;
   - legitimate_use_clause no_listed_use;
   - legitimate_use_conditions_met false.
6. to 8. The first absent of lawful_purpose, legitimate_use_clause, legitimate_use_conditions_met.
9. lawful_purpose unsure: referral, cite s_4_2.
10. legitimate_use_conditions_met unsure: referral, cite s_7.
11. Otherwise: `lawful_on_legitimate_use`, cite [s_4_1_b, s_7, CLAUSE] via legitimate_use_citation.

PAIRS LIST: lawful_purpose, legitimate_use_conditions_met.

**consent_notice**

1. sections_4_to_7_in_force absent: `indeterminate([sections_4_to_7_in_force])`.
2. sections_4_to_7_in_force false: `not_in_force`, cite [s_5_1, s_5_2_a].
3. and 4. acts_as_data_fiduciary false, or notice_occasion no_notice_occasion: `not_required`, cite [s_2_i, s_5_1, s_5_2_a].
5. to 7. The first absent of acts_as_data_fiduciary, notice_occasion, question_date.
8. acts_as_data_fiduciary unsure: referral, cite s_2_i.
9. request_for_consent, date before 2027-05-13: `notice_with_request_required_before_rule_3`, cite [s_5_1, s_5_3, r_1_4].
10. request_for_consent, date on or after: `notice_with_request_required`, cite [s_5_1, s_5_3, r_3].
11. consent_given_before_commencement, date before: `notice_for_earlier_consent_required_before_rule_3`, cite [s_5_2, s_5_2_a, s_5_3, r_1_4].
12. consent_given_before_commencement, date on or after: `notice_for_earlier_consent_required`, cite [s_5_2, s_5_2_a, s_5_3, r_3].

PAIRS LIST: acts_as_data_fiduciary.

**withdrawal_effect**

1. sections_4_to_7_in_force absent: `indeterminate([sections_4_to_7_in_force])`.
2. sections_4_to_7_in_force false: `not_in_force`, cite [s_6_6].
3. and 4. acts_as_data_fiduciary false, or consent_withdrawn false: `not_required`, cite [s_2_i, s_6_4, s_6_6].
5. to 7. The first absent of acts_as_data_fiduciary, consent_withdrawn, processing_required_or_authorised_by_law.
8. acts_as_data_fiduciary unsure: referral, cite s_2_i.
9. processing_required_or_authorised_by_law unsure: referral, cite s_6_6.
10. processing_required_or_authorised_by_law true: `processing_may_continue_without_consent`, cite [s_6_6].
11. Otherwise: `cease_processing_required`, cite [s_6_4, s_6_5, s_6_6].

PAIRS LIST: acts_as_data_fiduciary, processing_required_or_authorised_by_law.

**consent_manager_status**

1. section_6_9_in_force absent: `indeterminate([section_6_9_in_force])`.
2. section_6_9_in_force false: `not_in_force`, cite [s_6_9].
3. and 4. registered_with_board_as_consent_manager false, or consent_manager_registration_suspended_or_cancelled true: `may_not_act_as_consent_manager`, cite [s_2_g, s_6_9, r_4_5_a].
5. and 6. The first absent of registered_with_board_as_consent_manager, consent_manager_registration_suspended_or_cancelled.
7. Otherwise: `may_act_as_consent_manager`, cite [s_2_g, s_6_7, s_6_8, s_6_9, r_4_2_a, r_4_3].

This query never refers.

**provision_lists(Topic, Items)**: one `list_items/2` fact per topic, so there is exactly one solution.

**Facade requirement predicate** `dpdp_notice_consent_requirement(RequirementId, Profile, Status, Citation)`. RequirementId comes first, and each requirement has three exclusive clauses (met, unmet, unknown):

| RequirementId | Check | Citation |
|---|---|---|
| `sections_in_force` | check_true on sections_4_to_7_in_force | cite(in_dpdp_act_2023_s_4_1) |
| `purpose_lawful` | check_tri on lawful_purpose | cite(in_dpdp_act_2023_s_4_2) |
| `consent_given_for_purpose` | check_true on consent_given | cite(in_dpdp_act_2023_s_4_1_a) |
| `consent_not_withdrawn` | check_false on consent_withdrawn | cite(in_dpdp_act_2023_s_6_4) |
| `consent_meets_section_6_1` | check_tri on consent_meets_section_6_1 | cite(in_dpdp_act_2023_s_6_1) |

### Verdict atoms

- The slice produces the contract RESULT atoms listed above.
- The facade maps consent_ground to `eligible` / `ineligible` / `indeterminate`.

### Shared with another slice (kernel)

There is only one slice. The kernel holds only what the facade also needs:

- the input check and contract tables;
- `key_state/3`;
- `relied_pairs/3` and `referral/5`;
- the result constructors.

No value fact is shared.

## Tests (seven modes; v2 manifest)

1. **Unit, per ladder step**: one positive case per step, each paired with a negative case over the same fixture.
2. **Counting**: `findall` plus `length(_, 1)` for every query on every fixture.
3. **Boundary**: question_date on 2027-05-12, 2027-05-13 and 2027-05-14.
4. **Missing-key precedence**: the first-missing-key rule, first key only.
5. **Referral**: PAIRS order and unsure inclusion.
6. **Input check**:
   - wrong_type and duplicate_key, including that a duplicate is never also wrong_type;
   - unknown_key ordering, including non-atom keys;
   - wrong_type(profile) for a non-list, a partial list, an unbound element, or a non-attribute element;
   - an unbound value;
   - invalid dates: 2027-02-29, year 0, year 10000.
7. **Properties via validate_props**:
   - totality, determinism and citation completeness;
   - facade and consent_ground consistency;
   - provision_lists lengths 4, 4, 7, 3, 9, 11, 10 and 22, in text order.
