# SIGNATURE — eu/dora_rts_asset_management_and_cryptography

The public query surface is:

- `decide_dora_rts_asset_management_and_cryptography(PROFILE, dora_rts_asset_management_and_cryptography_verdict(STATUS, CITATIONS))`
- `dora_rts_asset_management_and_cryptography_status(PROFILE, STATUS)`

The facade delegates to the completeness query, which is the compliance check (#13) and the eligibility-style verdict (#2). It also exposes the three called-contract queries, the input check, the cited checklist (#7 justification) and what_if.

PROFILE is an attribute list `[attribute(KEY, VALUE), ...]`. It is read ONLY with `profile_get/3`: by presence first, then by value.

Totality and determinism:

- Every public predicate yields EXACTLY ONE solution for every term, unbound and ill-formed included (COUNTING).
- Every public predicate is cut-free, with no `->` and no `*->`. Ground verdicts are folded into clause heads, one clause per disjoint route (C17).
- Defeaters are guarded with `once/1` over `not_defeated/3`.

No figure is imported or re-declared. The domain has no numeric threshold, period or date (reading (19)).

## Verdict STATUS atoms (replacing the placeholder { required, permitted, not_applicable })

Final answers:

- `required(DUTIES)` — compound of arity 1, for the required query.
- `complete` and `incomplete` — for the completeness query.
- `none_outstanding` and `outstanding(DUTIES)` — compound of arity 1, for the outstanding query.
- `simplified_framework_entity` — for all three queries.

Status compounds (never final; CITATIONS []):

- `indeterminate([KEY])` — exactly one key. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(KEY, cite(CITATION_KEY)), [inputs_relied_on(PAIRS)])` — optionally followed by one unscored `provenance(CLAUSE, CITATIONS)`.
- `input_problems(PROBLEMS)` — PROBLEMS made of `duplicate_key(KEY)`, `wrong_type(KEY)` and `unknown_key(KEY)`.

The facade STATUS is the completeness RESULT. `dora_rts_asset_management_and_cryptography_status/2` returns the RESULT term itself.

Result constructors are exported and never called as queries:

- `required/1`, `outstanding/1`, `indeterminate/1`
- `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`
- `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`

The atoms `true`, `false` and `unsure` are values only. They are never pinned in verdict_vocabulary or root_exports.

## Profile keys (twenty-six, in root_exports / input_contract order)

No key is numeric and no key is a date.

Crisp facts (type `boolean` = the atoms true and false only; `unsure` is wrong_type):

1. `financial_entity_is_article_16_1_entity` — the GATE.
2. `financial_entity_is_microenterprise` — the only TRIGGER. NON-MICROENTERPRISE holds when it is false.

Judgement keys (type `one_of boolean or unsure` = the atoms true, false and unsure), in duty order:

3. `ict_asset_management_policy_developed_documented_and_implemented`
4. `asset_policy_prescribes_monitoring_and_management_of_asset_lifecycle`
5. `asset_policy_prescribes_records_of_ict_assets`
6. `asset_policy_prescribes_records_for_legacy_system_risk_assessment`
7. `ict_asset_management_procedure_developed_documented_and_implemented`
8. `asset_procedure_specifies_criticality_assessment_criteria`
9. `encryption_policy_developed_documented_and_implemented`
10. `encryption_policy_designed_on_data_classification_and_ict_risk_assessment`
11. `encryption_policy_has_rules_for_data_at_rest_and_in_transit`
12. `encryption_policy_has_rules_for_data_in_use_where_necessary`
13. `encryption_policy_has_rules_for_network_connections_and_external_traffic`
14. `encryption_policy_has_rules_for_cryptographic_key_management`
15. `data_in_use_protected_where_its_encryption_is_not_possible`
16. `encryption_policy_has_criteria_for_selecting_cryptographic_techniques`
17. `mitigation_and_monitoring_where_leading_practices_or_standards_not_followed`
18. `encryption_policy_has_provisions_for_updating_cryptographic_technology`
19. `mitigation_and_monitoring_where_cryptographic_technology_not_updated`
20. `encryption_policy_requires_recording_of_mitigation_measures_with_reasons`
21. `key_management_policy_has_requirements_for_whole_key_lifecycle`
22. `key_protection_controls_identified_and_implemented`
23. `key_protection_controls_designed_on_data_classification_and_ict_risk_assessment`
24. `key_replacement_methods_developed_and_implemented`
25. `certificate_register_created_maintained_and_kept_up_to_date`
26. `certificates_renewed_promptly_before_expiration`

## Citation-key atoms (canonical lexicon scheme, _lexicon/citations.yaml)

The FIXED CITATIONS, fourteen keys:

- `eu_reg_2024_1774_art_4_1`, `eu_reg_2024_1774_art_4_2`
- `eu_reg_2024_1774_art_5_1`, `eu_reg_2024_1774_art_5_2`
- `eu_reg_2024_1774_art_6_1`, `eu_reg_2024_1774_art_6_2`, `eu_reg_2024_1774_art_6_3`, `eu_reg_2024_1774_art_6_4`, `eu_reg_2024_1774_art_6_5`
- `eu_reg_2024_1774_art_7_1`, `eu_reg_2024_1774_art_7_2`, `eu_reg_2024_1774_art_7_3`, `eu_reg_2024_1774_art_7_4`, `eu_reg_2024_1774_art_7_5`

Point keys:

- `eu_reg_2024_1774_art_4_2_a`, `eu_reg_2024_1774_art_4_2_b`, `eu_reg_2024_1774_art_4_2_c`
- `eu_reg_2024_1774_art_6_2_a`, `eu_reg_2024_1774_art_6_2_b`, `eu_reg_2024_1774_art_6_2_c`, `eu_reg_2024_1774_art_6_2_d`

The gate key:

- `eu_reg_2022_2554_art_16_1`

No shortened citation atom is ever invented.

## Public predicates

- `rts_asset_management_and_cryptography_duties_required(Profile, Result, Citations)`
  - Result is one of `required(Duties)`, `simplified_framework_entity` or a status compound.
  - Steps: R0 input, R-G1 gate true, R-G2 gate absent, R1 trigger absent, R2 required.
  - It reads only the gate and the trigger and never refers.
  - Cites the FIXED CITATIONS, or `[cite(eu_reg_2022_2554_art_16_1)]`. Grounds: RTS Arts 4 to 7; DORA Art 16(1).
- `rts_asset_management_and_cryptography_duties_complete(Profile, Result, Citations)`
  - Result is one of `complete`, `incomplete`, `simplified_framework_entity` or a status compound.
  - Steps: S0, S-G1, S-G2, S1 a duty fails gives incomplete, S2 absent key per the behind test, S3 unsure gives a referral, S4 complete.
  - Cites the FIXED CITATIONS. Grounds: RTS Arts 4 to 7; DORA Art 16(1).
  - Serves query type #13, the compliance check.
- `rts_asset_management_and_cryptography_duties_outstanding(Profile, Result, Citations)`
  - Result is one of `none_outstanding`, `outstanding(Duties)`, `simplified_framework_entity` or a status compound.
  - Steps: M0, M-G1, M-G2, M1 absent key, M2 unsure, M3 final.
  - Citations are the FIXED CITATIONS for none_outstanding, or each failing duty's own key, written once. Grounds: RTS Arts 4 to 7; DORA Art 16(1).
- `dora_rts_asset_management_and_cryptography_input_problems(Profile, Problems)`
  - The typed input check. It yields one solution, never fails and never raises.
  - For each contract key, in contract order: duplicate_key if the key repeats, otherwise wrong_type if its value is outside its type.
  - Then unknown_key, in order of first occurrence (identity by ==, value not checked).
  - A non-attribute-list PROFILE gives `[wrong_type(profile)]`. This covers an unbound profile, a partial list and an unbound element.
  - Grounds: the input contract (no article).
- `decide_dora_rts_asset_management_and_cryptography(Profile, dora_rts_asset_management_and_cryptography_verdict(Status, Citations))`
  - The facade verdict: Status and Citations are the RESULT and CITATIONS of the completeness query.
  - Grounds: RTS Arts 4 to 7; DORA Art 16(1).
- `dora_rts_asset_management_and_cryptography_status(Profile, Status)`
  - The Status of the facade verdict only.
  - Grounds: RTS Arts 4 to 7; DORA Art 16(1).
- `dora_rts_asset_management_and_cryptography_checklist(Profile, Checklist)`
  - The justification query (#7) and eligibility checklist (#2).
  - It returns one `item(Duty, Status, cite(Key))` per applying duty, in duty order, built with `formalize_lib:eval_requirements/4` over `requirement/4`.
  - Status is one of:
    - `met`;
    - `unmet(duty_not_performed)`;
    - `unknown([Key])`, for an unsure or absent key.
  - Before the duty items, it carries one gate item: `item(title_two_applies, Status, cite(eu_reg_2022_2554_art_16_1))`.
  - A gate-true profile gives only that gate item, with `unmet(simplified_framework_entity)`.
  - Grounds: each item cites its duty's key.
- `dora_rts_asset_management_and_cryptography_what_if(Profile, Key, Value, Result)`
  - Overrides one key with `query_combinators:what_if/5` and re-runs the facade decision.
  - Result is the facade verdict term.
  - Grounds: RTS Arts 4 to 7; DORA Art 16(1).
- `dora_rts_asset_management_and_cryptography_fixture(Name, Profile)` and `dora_rts_asset_management_and_cryptography_fixture_expected(Name, Query, Result, Citations)` (module fixtures)
  - The named profiles, each paired with its expected answers.
  - Fixtures:
    - `gate_true`;
    - `gate_absent`;
    - `all_true_microenterprise`;
    - `all_true_non_microenterprise`;
    - `legacy_records_false_trigger_absent`;
    - `always_duty_absent_trigger_absent`;
    - `one_unsure`;
    - `two_false_outstanding`;
    - `duplicate_and_unknown_keys`;
    - `not_a_list`.

## Planned reuse (manifest `uses:`)

- **formalize_lib**:
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2` — presence first, then value.
  - `check_tri/4` — the met / unmet / unknown status of each tri-state judgement. It is not hand-rolled (C15).
  - `eval_requirements/4` and `item/3` — the checklist. Not hand-rolled (R1).
  - `not_defeated/3` — guarded defeaters: the gate defeats every duty, and microenterprise defeats Art 4(2)(c).
  - `memberd/2`, `not_member/2` — duplicate and unknown detection with == identity.
  - `attribute/2` and the vocabulary atoms `met`, `unmet/1`, `unknown/1`.
- **kit.query_combinators**: `what_if/5`, used by the what_if facade.
- **validate_props**:
  - `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `bad_citation/1`.
  - Used in tests across the seven test modes.
- **Not used**, each with its reason:
  - kit.compliance_lib — its deny-overrides modality lattice does not fit a duty-completeness ladder with <<DNUM>> ordering. Query #13 is served directly by the completeness query.
  - deadline_lib, date_time, rolling_window — no dates (reading (19)).
  - currency_vocab, vat_category, country — no such values.
- **Family backbone (`_common`, deontic)**: none is advertised for this ladder shape, so it is authored locally. NOTES.md records it as a candidate kit module.

## kernel.clausal — the shared floor (the ONLY things shared)

There is one determination slice, so the kernel holds only what the facade, the queries, the fixtures and the slice all need.

- `dora_rts_asset_management_and_cryptography_contract_key(Key, Type)` — the twenty-six rows in contract order. Type is `fact` or `judgement`.
- `dora_rts_asset_management_and_cryptography_input_problems/2` — the typed input check.
- `dora_rts_asset_management_and_cryptography_relied_pairs(Profile, Pairs)` — every present `Key-Value` in contract order, values as given.
- No statutory value facts are placed in the kernel.

## Slice: dora_rts_asset_management_and_cryptography.clausal

### Value facts it owns

No numeric thresholds, periods or dates; no `constant_value`.

- `duty(Position, DutyAtom, ProfileKey, CitationKey)` — twenty-four rows in DUTY ORDER, as in the interface table:
  1. `ict_asset_management_policy` — key 3 — art_4_1
  2. `ict_asset_lifecycle_monitoring_and_management` — key 4 — art_4_2_a
  3. `ict_asset_records` — key 5 — art_4_2_b
  4. `legacy_ict_system_risk_assessment_records` — key 6 — art_4_2_c
  5. `ict_asset_management_procedure` — key 7 — art_5_1
  6. `criticality_assessment_criteria` — key 8 — art_5_2
  7. `encryption_and_cryptographic_controls_policy` — key 9 — art_6_1
  8. `encryption_policy_design_basis` — key 10 — art_6_2
  9. `rules_for_encryption_of_data_at_rest_and_in_transit` — key 11 — art_6_2_a
  10. `rules_for_encryption_of_data_in_use` — key 12 — art_6_2_b
  11. `rules_for_encryption_of_network_connections_and_external_traffic` — key 13 — art_6_2_c
  12. `rules_for_cryptographic_key_management` — key 14 — art_6_2_d
  13. `protection_of_data_in_use_where_encryption_not_possible` — key 15 — art_6_2
  14. `cryptographic_technique_selection_criteria` — key 16 — art_6_3
  15. `mitigation_where_leading_practices_not_followed` — key 17 — art_6_3
  16. `cryptographic_technology_update_provisions` — key 18 — art_6_4
  17. `mitigation_where_cryptographic_technology_not_updated` — key 19 — art_6_4
  18. `recording_of_mitigation_and_monitoring_measures` — key 20 — art_6_5
  19. `cryptographic_key_lifecycle_requirements` — key 21 — art_7_1
  20. `cryptographic_key_protection_controls` — key 22 — art_7_2
  21. `key_protection_controls_design_basis` — key 23 — art_7_2
  22. `cryptographic_key_replacement_methods` — key 24 — art_7_3
  23. `certificate_register` — key 25 — art_7_4
  24. `prompt_certificate_renewal` — key 26 — art_7_5
- `duty_condition(DutyAtom, financial_entity_is_microenterprise, false)` — a single row, for `legacy_ict_system_risk_assessment_records`. Every other duty has no condition.
- `fixed_citation(Key)` — the fourteen paragraph keys.
- `referral(JudgementKey, cite(CitationKey), Inputs)` — twenty-four rows.
  - Each citation is as listed in THE LIMBS: the duty's own key, or art_6_2 for key 15.
  - Inputs is all twenty-six keys in every row.

### Rules / requirements

Duty states, condition states and defeaters:

- `duty_applies/2` — every condition holds.
- `duty_open/2` — no condition fails.
- `duty_fails/2` — the duty applies and its key is false.
- `condition_holds/2`, `condition_fails/2` and `condition_open/2` — read from the crisp trigger.
- `requirement(DutyAtom, Profile, Status, cite(Key))` — `check_tri/4` on the duty key. It has three mutually exclusive clauses (met, unmet, unknown) and is defeated through `not_defeated/3` when its condition fails.

The required query:

- Steps R-G1, R-G2, R1 and R2, each one clause with its verdict in the head.
- DUTIES are collected with findall over `duty/4`, ordered by Position.

The completeness query:

- S1 is a guarded `once/1` existence of a failing duty.
- S2 computes the set of absent keys that can still change the answer, as THE LIMBS define it in (a) and (b). It then selects the first in contract order that is not BEHIND another, by <<DNUM>> conditions (i) and (ii).
  - In this table that comes to the following. The Art 4(2)(c) key is eligible only when NON-MICROENTERPRISE holds.
  - While any always-applying duty key is absent, the trigger is named only when the Art 4(2)(c) key is false (it then decides alone).
  - When the trigger is absent and every always-applying duty key is present, the trigger comes before the Art 4(2)(c) key.
- S3 refers the first unsure key of an open duty that can still change the answer, by (a), in contract order.
- S4 gives complete.

The outstanding query:

- M1 selects the first absent key that can still change the list and is not BEHIND another.
  - A duty key of an applying duty changes the list alone.
  - The trigger changes the list alone when the Art 4(2)(c) key is not true.
  - The Art 4(2)(c) key is behind an absent trigger.
- M2 refers the first unsure key of an open duty.
- M3 gives none_outstanding, or outstanding(the failing duties in duty order) with each one's own citation, deduplicated.

The referral:

- `needs_legal_review(open_textured(Key, Cite), [inputs_relied_on(Pairs)])`.
- Pairs comes from the kernel `relied_pairs/2`.

Every step is a disjoint guarded clause. Each query is wrapped so that it yields exactly one solution.

### Verdict atoms of this slice

- `required/1`
- `complete`, `incomplete`
- `none_outstanding`, `outstanding/1`
- `simplified_framework_entity`
- `indeterminate/1`
- `needs_legal_review/2` with `open_textured/2`, `inputs_relied_on/1`, `provenance/2`
- `input_problems/1` (from the kernel check)

### Shared with other slices

None beyond the kernel floor above: the contract key rows, the input check and relied_pairs. There is no other slice.

## queries.clausal / facade / fixtures

- queries.clausal re-exports the three queries and adds the checklist and what_if.
- The package facade maps `decide_dora_rts_asset_management_and_cryptography/2` and `dora_rts_asset_management_and_cryptography_status/2` onto the completeness query.
- fixtures.clausal holds the named profiles listed above, with their expected answers for every query. They cover the gate, the trigger in all three states, a false duty before an absent key, <<DNUM>> behind-key cases, <<DNUM>> missing-before-unsure, citations by point for outstanding, and every input-problem class.
