# SIGNATURE — eu/dora_rts_review_report_format

Package `eu/dora_rts_review_report_format`, predicate prefix `dora_rts_review_report_format_`. Shape family: deontic. The package layout is unchanged:

kernel -> citations -> parameters -> dora_rts_review_report_format (the one determination slice) -> queries -> fixtures -> package facade.

## Public query surface

Every public predicate yields exactly ONE solution for every input. It is cut-free: no `!`, no `->`, no `*->`. A constant RESULT is folded into the head, one clause per disjoint route.

### Contract queries (THE LIMBS)

- `ict_risk_framework_review_report_duties_required(Profile, Result, Citations)`: steps R0, R-G1 to R-G4, R1, R2. It reads only the gate, the request and the five triggers, and never refers. Cites the union of the citation keys of the duties that apply; Art 16(1) for an Art 16(1) entity.
- `ict_risk_framework_review_report_duties_complete(Profile, Result, Citations)`: steps S0, S-G1 to S-G4, S1 to S4. Cites THE FIXED CITATIONS for `complete` and `incomplete`.
- `ict_risk_framework_review_report_duties_outstanding(Profile, Result, Citations)`: steps M0, M-G1 to M-G4, M1 to M3. Cites THE FIXED CITATIONS for `none_outstanding`; the union of the outstanding duties' keys for `outstanding(Duties)`.
- `dora_rts_review_report_format_input_problems(Profile, Problems)`: THE INPUT CHECK. Never fails and never raises.

### Facade (scaffold names kept)

- `decide_dora_rts_review_report_format(Profile, dora_rts_review_report_format_verdict(Status, Citations))`: the completeness verdict.
  - It wraps `ict_risk_framework_review_report_duties_complete/3`, so Status and Citations are exactly that query's Result and Citations.
  - Cites Art 27(1) and Art 27(2), or Art 16(1).
- `dora_rts_review_report_format_status(Profile, Status)`: Status only, from the same query.
- `dora_rts_review_report_format_checklist(Profile, Checklist)`: query types #2 and #7, the eligibility and justification view.
  - Checklist is `assessment(Profile, Decision, Items)`, built by `formalize_lib:assess/6` over the duty atoms that apply, with `labels(complete, indeterminate, incomplete)`.
  - Each item is `item(DutyAtom, met | unmet(Reason) | unknown([Key]), cite(CitationKey))`, so every item carries provenance (#7).
  - Returns `[]` items with Decision equal to the gate or request answer when the gate or request decides.
  - The checklist is the justification; the contract verdict is always the limbs query.
- `dora_rts_review_report_format_what_if(Profile, Key, Value, Status)`: recomputes the completeness Status after an override.
  - It replaces or sets `attribute(Key, Value)` with `formalize_lib:profile_set/3`, then calls `dora_rts_review_report_format_status/2`.
  - Cites as that query does.
- `dora_rts_review_report_format_compliance_check(Profile, submit_review_report, Verdict)`: query type #13. Is submitting the report, as it stands, compliant with Art 27?
  - Verdict `compliant` when complete is `complete`.
  - Verdict `non_compliant` when complete is `incomplete`.
  - Otherwise the final atom or status compound of the completeness query is passed through unchanged.
  - Cites Art 27(1) and Art 27(2).
- `dora_rts_review_report_format_fixture(FixtureName, Profile)`: the named fixture profiles listed below.

## Verdict STATUS atoms (these replace the placeholders)

The placeholder set `{ required, permitted, not_applicable }` is replaced as follows.

### Final atoms

- `complete`
- `incomplete`
- `none_outstanding`
- `simplified_framework_entity`
- `framework_review_report_not_requested`

### Final compounds

- `required(Duties)`
- `outstanding(Duties)`

In both, Duties is a non-empty list in DUTY ORDER.

### Status compounds (CITATIONS always [])

- `indeterminate([Key])`: exactly one bare key. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`: may carry an optional, unscored `provenance(Clause, Citations)` after the context item.
- `input_problems(Problems)`

### Problem terms

- `duplicate_key(Key)`
- `wrong_type(Key)`
- `unknown_key(Key)`
- `wrong_type(profile)`

### Compliance-check atoms (facade only)

- `compliant`
- `non_compliant`
- action atom `submit_review_report`

### Checklist label atoms

- `complete`
- `indeterminate`: used only as a `labels/3` argument inside the checklist view, never as a Result.
- `incomplete`

### The twenty-nine duty atoms, in DUTY ORDER

These are result atoms only, never profile keys.

1. `report_in_searchable_electronic_format`
2. `report_identifies_entity_and_group_structure`
3. `report_describes_context`
4. `report_summarises_changes_since_previous_report`
5. `report_gives_executive_summary`
6. `report_states_approval_date`
7. `report_describes_reason_for_review`
8. `report_references_initiating_instructions_or_conclusions`
9. `report_lists_incidents_with_root_cause_analysis`
10. `report_states_review_period_dates`
11. `report_indicates_responsible_function`
12. `report_describes_major_changes_and_improvements`
13. `report_analyses_impact_of_changes`
14. `report_summarises_findings_and_severity`
15. `report_summarises_remediation_measures`
16. `report_gives_measure_dates_and_progress`
17. `report_gives_measure_tools_and_functions`
18. `report_describes_resource_impact`
19. `report_informs_on_authority_information_process`
20. `report_explains_residual_risk_acceptance`
21. `report_informs_on_planned_developments`
22. `report_states_conclusions`
23. `report_lists_past_reviews`
24. `report_states_corrective_measure_implementation`
25. `report_describes_corrective_measure_improvements`
26. `report_uses_internal_audit_results`
27. `report_uses_compliance_assessments`
28. `report_uses_resilience_testing_results`
29. `report_uses_external_sources`

## Profile keys

PROFILE is `[attribute(Key, Value), ...]`, read only with `profile_get/3`, by presence and then by value. There are thirty-six keys, given here in root_exports and input_contract order. No key is numeric and no key is a date, so no unit suffix and no `date(Y, M, D)` term appears.

### Fact keys (type `fact`: the atom `true` or the atom `false`)

1. `financial_entity_is_article_16_1_entity`: the GATE.
2. `authority_requested_framework_review_report`: the REQUEST.
3. `financial_entity_is_microenterprise`: TRIGGER; NON-MICROENTERPRISE when false.
4. `review_initiated_following_supervisory_instructions_or_testing_or_audit_conclusions`: TRIGGER; SUPERVISORY-INITIATION when true.
5. `review_initiated_following_ict_related_incidents`: TRIGGER; INCIDENT-INITIATION when true.
6. `identified_weaknesses_not_subject_to_corrective_measures`: TRIGGER; UNCORRECTED-WEAKNESSES when true.
7. `past_corrective_measures_proved_ineffective_or_created_unexpected_challenges`: TRIGGER; INEFFECTIVE-MEASURES when true.

### Judgement keys (type `judgement`: `true`, `false` or `unsure`)

The list follows DUTY ORDER; key N+7 is the key of duty N.

8. `review_report_in_searchable_electronic_format`
9. `review_report_identifies_entity_and_group_structure`
10. `review_report_describes_context`
11. `review_report_summarises_changes_since_previous_report`
12. `review_report_gives_executive_summary`
13. `review_report_states_approval_date`
14. `review_report_describes_reason_for_review`
15. `review_report_references_initiating_instructions_or_conclusions`
16. `review_report_lists_incidents_with_root_cause_analysis`
17. `review_report_states_review_period_dates`
18. `review_report_indicates_responsible_function`
19. `review_report_describes_major_changes_and_improvements`
20. `review_report_analyses_impact_of_changes`
21. `review_report_summarises_findings_and_severity`
22. `review_report_summarises_remediation_measures`
23. `review_report_gives_measure_dates_and_progress`
24. `review_report_gives_measure_tools_and_functions`
25. `review_report_describes_resource_impact`
26. `review_report_informs_on_authority_information_process`
27. `review_report_explains_residual_risk_acceptance`
28. `review_report_informs_on_planned_developments`
29. `review_report_states_conclusions`
30. `review_report_lists_past_reviews`
31. `review_report_states_corrective_measure_implementation`
32. `review_report_describes_corrective_measure_improvements`
33. `review_report_uses_internal_audit_results`
34. `review_report_uses_compliance_assessments`
35. `review_report_uses_resilience_testing_results`
36. `review_report_uses_external_sources`

### Value rules

- `boolean` means the two atoms `true` and `false`, never a Python boolean or a string.
- `unsure` given to a fact key is `wrong_type`.

## Citation-key atoms

These come from the canonical lexicon `_lexicon/citations.yaml` and are pinned in citation_vocabulary. No shortened atom is ever invented.

**Regulation (EU) 2022/2554 (DORA)**

- `eu_reg_2022_2554_art_16_1`: DORA Art 16(1), first subparagraph. The gate.

**Commission Delegated Regulation (EU) 2024/1774 (RTS)**

- `eu_reg_2024_1774_art_27_1`: RTS Art 27(1).
- `eu_reg_2024_1774_art_27_2`: RTS Art 27(2), lead words and second subparagraph.
- `eu_reg_2024_1774_art_27_2_a_i`, `eu_reg_2024_1774_art_27_2_a_ii`, `eu_reg_2024_1774_art_27_2_a_iii`, `eu_reg_2024_1774_art_27_2_a_iv`
- `eu_reg_2024_1774_art_27_2_b`
- `eu_reg_2024_1774_art_27_2_c`
- `eu_reg_2024_1774_art_27_2_d`
- `eu_reg_2024_1774_art_27_2_e`
- `eu_reg_2024_1774_art_27_2_f`
- `eu_reg_2024_1774_art_27_2_g`
- `eu_reg_2024_1774_art_27_2_h_i`, `eu_reg_2024_1774_art_27_2_h_ii`, `eu_reg_2024_1774_art_27_2_h_iii`, `eu_reg_2024_1774_art_27_2_h_iv`, `eu_reg_2024_1774_art_27_2_h_v`, `eu_reg_2024_1774_art_27_2_h_vi`
- `eu_reg_2024_1774_art_27_2_i`
- `eu_reg_2024_1774_art_27_2_j`
- `eu_reg_2024_1774_art_27_2_k_i`, `eu_reg_2024_1774_art_27_2_k_ii`, `eu_reg_2024_1774_art_27_2_k_iii`
- `eu_reg_2024_1774_art_27_2_l_i`, `eu_reg_2024_1774_art_27_2_l_ii`, `eu_reg_2024_1774_art_27_2_l_iii`, `eu_reg_2024_1774_art_27_2_l_iv`

Deferred provisions (DORA Art 6, RTS Art 42) get no citation key, because no query cites them. Their units are recorded in `citations.clausal` as pinned-but-unread source rows only.

## Planned reuse (manifest `uses:`)

### formalize_lib

- **Profile access:** `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`, `profile_keys/2`.
- **Duty statuses:** `check_tri/4`. It maps a judgement key's true, false, unsure or absent value to met, `unmet/1` or `unknown/1` for the checklist view. It is not re-implemented, because the C15 lint forbids that.
- **Checklist:** `assess/6` and `eval_requirements/4`, with requirement closure `dora_rts_review_report_format_requirement/4`, whose head is `(DutyAtom, Profile, Status, Citation)` with the RequirementId first.
- **Labels and items:** `labels/3`, `item/3`, `assessment/3`.
- **Defeasible gate:** `not_defeated/3`. A duty's `applies` rule is the default, defeated by `dora_rts_review_report_format_defeater/2`: gate true or request false. Each defeater check is guarded with `once/1`, cut-free.
- **List helpers:** `memberd/2`, `not_member/2`, `first_applicable/2`.
- **Vocabulary atoms:** `met`, `applicable`, `inapplicable`.

### kit/query_combinators

- `what_if/5` is considered, but its Dict form does not fit attribute lists. what_if/4 is therefore built on `profile_set/3`.
- `failing_ids/4`, with the requirement closure, serves as a test oracle for the outstanding list.

### validate_props (tests)

- `prop_totality/3` and `prop_determinism/3` check exactly one solution over the fixture generator.
- `prop_citation_complete/3` checks every citation against `bad_citation/1`.
- `prop_missing_key_coverage/3` checks that each of the 36 keys can be named.
- `run_props/1`.

### Not used

- kit/compliance_lib: its deny-overrides modality lattice adds nothing to a single-action content check. The compliance verdict maps the limbs answer directly; this is noted in NOTES.
- kit/deadline_lib, date_time, rolling_window, currency_vocab, vat_category, country: no dates, money, plans or places are involved.

## kernel.clausal (shared floor)

Only what the slice AND the queries and facade both need:

- `dora_rts_review_report_format_contract_key(Index, Key, Type)`: thirty-six rows. Type is `fact` or `judgement`; Index is the root_exports position.
- `dora_rts_review_report_format_input_problems/2`: THE INPUT CHECK, as specified below.
- `dora_rts_review_report_format_value_of(Profile, Key, Value)`: present-and-single read via `profile_get/3`. It is absent when the key is lacking.
- `dora_rts_review_report_format_defeater(Profile, Reason)`:
  - `article_16_1_entity` when the gate is true;
  - `report_not_requested` when the request is false.

The input check is cut-free and has three branches:

1. If the profile is not a proper list of `attribute(_, _)` (including an unbound profile, a partial list or an unbound element): `[wrong_type(profile)]`.
2. Otherwise, walk the contract keys in Index order: `duplicate_key(K)` if K occurs more than once (counted by `==`, with no value read); else `wrong_type(K)` if the value is outside its type (an unbound value included); else nothing.
3. Then add `unknown_key(K)` for each non-contract key in order of first occurrence, deduplicated by `==`. This includes unbound variables kept as the same variable, numbers, strings and compounds. An unknown key's value is never checked.

## Slice — dora_rts_review_report_format.clausal

This slice is self-contained for the concept 'duties on the Art 27 review report'.

### Statutory VALUE facts it owns

There are no numeric thresholds, periods or money figures, so there is no `constant_value/2`. The tables are:

- `dora_rts_review_report_format_duty(Order, DutyAtom, ProfileKey, Conditions, CitationKeys)`: twenty-nine rows in DUTY ORDER.
  - Conditions is `[]` or a single-element list `[condition(TriggerKey, Value)]`.
  - The four conditioned rows are:
    - order 8: `[condition(review_initiated_following_supervisory_instructions_or_testing_or_audit_conclusions, true)]`, cites `[eu_reg_2024_1774_art_27_2_c, eu_reg_2024_1774_art_27_2]`;
    - order 9: `[condition(review_initiated_following_ict_related_incidents, true)]`, same two citations;
    - order 20: `[condition(identified_weaknesses_not_subject_to_corrective_measures, true)]`;
    - order 25: `[condition(past_corrective_measures_proved_ineffective_or_created_unexpected_challenges, true)]`.
  - Order 26 has `[condition(financial_entity_is_microenterprise, false)]`.
  - Order 13 cites `[eu_reg_2024_1774_art_27_2_f, eu_reg_2024_1774_art_27_2]`.
  - Every other row cites its single point key.
  - Twenty-four rows have no condition.
- `dora_rts_review_report_format_referral_citation(ProfileKey, CitationKey)`: twenty-nine rows, as in THE LIMBS. Keys 15 and 16 both refer to `27_2_c`; key 20 refers to `27_2_f`.
- `dora_rts_review_report_format_fixed_citations([cite(eu_reg_2024_1774_art_27_1), cite(eu_reg_2024_1774_art_27_2)])`.
- `dora_rts_review_report_format_trigger(Key)`: five rows, in root order.

### Rules and requirements

All rules are cut-free, and each status is decided by mutually exclusive clauses.

- `condition_state(Profile, condition(T, V), State)`: `holds` / `fails` / `open`, by presence and then by value.
- `duty_state(Profile, Duty, State)`:
  - `applies` when all conditions hold and the duty is not defeated (`not_defeated/3` over the kernel defeater);
  - `open` when no condition fails and some condition is open;
  - `inapplicable` when a condition fails.
- `duty_fails(Profile, Duty)`: applies and key `false`.
- `dora_rts_review_report_format_requirement(Duty, Profile, Status, Citation)`: the `assess/6` closure over duties that apply.
  - Status comes from `check_tri/4` on the duty key.
  - Citation is `cite(FirstCitationKey)`; the full keys come from the table.
- **R1:** the first absent trigger in root order. Every absent trigger's single duty is open.
- **R2:** the duties that apply, in order, with the union of their citations, deduplicated.
- **S1:** some duty fails, giving `incomplete`.
- **S2:** the general can-change, decides-alone and BEHIND relations are implemented as written in THE LIMBS, over the duty table. Because each duty has at most one condition and each trigger conditions exactly one duty, they reduce to the closed form below, which serves as the test oracle:
  - (i) If any absent key DECIDES ALONE, name the first such key in root order. A key decides alone when it is the key of a duty that applies, or a trigger whose duty's key is false.
  - (ii) Else name the first in root order among:
    - absent triggers whose duty's key is not true;
    - absent keys of open conditional duties.
    The trigger always comes first, being earlier in root order.
- **S3:** the first unsure key of a duty that applies, giving `needs_legal_review`. Its Citation comes from the referral table and its Pairs are all present pairs in root order.
- **S4:** `complete`.
- **M1:** the first in root order among:
  - absent keys of duties that apply;
  - absent triggers whose open duty's key is not true.
  The key of a conditional duty with an absent trigger is BEHIND that trigger.
- **M2:** the first unsure key of a duty that applies.
- **M3:** the duties that fail. If there are none, `none_outstanding` with the fixed citations; otherwise `outstanding(List)` with the union of its duties' keys.
- **Pairs:** every `Key-Value` present in the profile, in contract order, with the value exactly as given.

### Verdict atoms it produces

- `required/1`
- `complete`
- `incomplete`
- `none_outstanding`
- `outstanding/1`
- `simplified_framework_entity`
- `framework_review_report_not_requested`
- `indeterminate/1`
- `needs_legal_review/2` with `open_textured/2` and `inputs_relied_on/1`
- `input_problems/1` (passed through from the kernel)

### Predicates shared with another slice

There are none, because this is the only slice. The kernel holds only the contract table, the input check, the value read and the defeater, which the queries and facade also need.

### Per-rule tests, checklist and verdict

Each is shown in this file's own test block.

- **Gate:** gate true gives Art 16(1).
- **Missing gate:** gate absent names the gate.
- **Missing request:** request absent names the request.
- **Request false:** gives `framework_review_report_not_requested` with [].
- **Each trigger in each value:** adds or removes exactly its duty.
- **Failing duty:** a false duty key with absent others gives `incomplete`.
- **Absent key versus unsure:** an absent key beats an unsure one.
- **BEHIND cases:** an absent always-duty key beats an absent trigger; an absent trigger with a false duty key beats an absent always-duty key.
- **Count:** every query yields exactly one solution, tested with `findall` and `length/2`.
- **Negatives:** each negative test is paired with a positive one over the same case.

## queries.clausal

The three contract queries plus the input check re-export. Each query runs its steps in order as disjoint clauses with guarded preconditions: a later step's clause requires the earlier steps' conditions to fail, computed positively, with no cut.

## fixtures.clausal — `dora_rts_review_report_format_fixture/2`

| Fixture | Profile | Expected answer |
|---|---|---|
| `article_16_1_entity` | gate true | `simplified_framework_entity` |
| `gate_absent` | gate absent | `indeterminate([financial_entity_is_article_16_1_entity])` |
| `request_absent` | request absent | `indeterminate([authority_requested_framework_review_report])` |
| `not_requested` | request false | `framework_review_report_not_requested` |
| `scheduled_review_microenterprise_complete` | all triggers set so no conditional duty applies, microenterprise; all 24 duty keys true | `complete`; required lists 24 duties |
| `all_triggers_complete` | all conditions hold; all 29 keys true | `complete`; required lists 29 duties |
| `missing_executive_summary` | one key false | `incomplete`; `outstanding([report_gives_executive_summary])` |
| `trigger_absent` | microenterprise absent | required gives `indeterminate([financial_entity_is_microenterprise])` |
| `unsure_format` | format unsure, all else true | `needs_legal_review(open_textured(review_report_in_searchable_electronic_format, cite(eu_reg_2024_1774_art_27_1)), ...)` |
| `false_beats_absent` | false always-duty key plus absent others | `incomplete` |
| `input_duplicate_and_unknown` | a duplicated contract key and a key outside the contract | `input_problems([duplicate_key(...), unknown_key(...)])` |
| `not_attribute_list` | a profile that is not an attribute list | `input_problems([wrong_type(profile)])` |

## Totality and determinism claims

- Every one of the four contract predicates, and every facade predicate, yields exactly one solution for every term, an unbound term included.
- There are no floats, strings or records in any output.
- DUTIES lists are in DUTY ORDER, with each atom once.
- CITATIONS are set-like, with each `cite(K)` once.
