# SIGNATURE — eu/dora_rts_policies_and_risk_management

## Public query surface

**The contract queries**

The three contract queries each take one PROFILE and yield exactly one solution. They give RESULT and CITATIONS:

- `rts_policies_and_risk_management_duties_required/3`
- `rts_policies_and_risk_management_duties_complete/3`
- `rts_policies_and_risk_management_duties_outstanding/3`

The input check `dora_rts_policies_and_risk_management_input_problems/2` runs first in every query.

**The facade**

The facade keeps the scaffold names:

- `decide_dora_rts_policies_and_risk_management(Profile, dora_rts_policies_and_risk_management_verdict(Status, Citations))` is the eligibility verdict (query type #2). Status and Citations are exactly the RESULT and CITATIONS of `rts_policies_and_risk_management_duties_complete/3`.
- `dora_rts_policies_and_risk_management_status(Profile, Status)` projects Status alone.

**Totality and determinism**

- Every public predicate is total over every term, including unbound and malformed profiles.
- Every public predicate is deterministic: exactly one solution, never a failure, never an exception.
- Duplicate keys are refused by the input check, so `profile_get/3` sees each key at most once.
- All rules are cut-free:
  - no `!`, no `->`, no `*->`;
  - routes are disjoint, and ground outcomes are folded into clause heads (C17);
  - only guarded `once/1` is used, for the first-in-order search and the defeater.

**Figures**

There are no statutory figures (no threshold, period or table). Nothing is imported or declared with `constant_value`.

## Verdict STATUS atoms (replace the placeholder { required, permitted, not_applicable })

Final answers:

- `required(Duties)`, a compound of arity 1. Duties is the list of the twenty-seven duty atoms in duty order.
- `simplified_framework_entity` (atom).
- `complete` (atom).
- `incomplete` (atom).
- `none_outstanding` (atom).
- `outstanding(Duties)`, a compound of arity 1. Duties is a non-empty list in duty order.

Status compounds (never final; their Citations are always `[]`):

- `indeterminate([Key])`, with exactly one bare key atom. The bare atom `indeterminate` is NEVER written.
- `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`, optionally followed by one unscored `provenance(Clause, Citations)` item. Pairs is every present `Key-Value` in root_exports order.
- `input_problems(Problems)`, where Problems is a list of `duplicate_key(Key)`, `wrong_type(Key)` and `unknown_key(Key)` terms.

For the facade `_status/2` and `_verdict/2`, the status set is `complete`, `incomplete`, `simplified_framework_entity`, or one of the three status compounds above.

For `_compliance_check/4` (query type #13), the verdict atoms are `permitted` and `prohibited`, or one of the three status compounds.

Result constructors are exported and never called as queries: `required/1`, `outstanding/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

The atoms `true` and `false` are never pinned in `verdict_vocabulary` or `root_exports`.

## Profile keys (root_exports and input_contract order; none numeric; no dates)

PROFILE is `[attribute(Key, Value), ...]` and is read only with `profile_get/3`.

| # | key | type |
|---|-----|------|
| 1 | financial_entity_is_article_16_1_entity | fact: boolean (atoms true / false) — the GATE |
| 2 | size_risk_profile_and_complexity_taken_into_account | judgement: true / false / unsure |
| 3 | ict_security_policies_embedded_in_ict_risk_management_framework | judgement |
| 4 | security_policies_ensure_security_of_networks | judgement |
| 5 | security_policies_contain_safeguards_against_intrusions_and_data_misuse | judgement |
| 6 | security_policies_preserve_availability_authenticity_integrity_and_confidentiality_of_data | judgement |
| 7 | security_policies_guarantee_accurate_and_prompt_data_transmission | judgement |
| 8 | security_policies_aligned_to_information_security_objectives | judgement |
| 9 | security_policies_indicate_date_of_management_body_approval | judgement |
| 10 | security_policies_contain_indicators_and_measures_for_implementation_and_exceptions | judgement |
| 11 | security_policies_specify_staff_responsibilities_for_ict_security | judgement |
| 12 | security_policies_specify_consequences_of_staff_non_compliance | judgement |
| 13 | security_policies_list_documentation_to_be_maintained | judgement |
| 14 | security_policies_specify_segregation_of_duties_arrangements | judgement |
| 15 | security_policies_consider_leading_practices_and_standards | judgement |
| 16 | security_policies_identify_roles_for_development_implementation_and_maintenance | judgement |
| 17 | security_policies_reviewed_in_accordance_with_article_6_5 | judgement |
| 18 | security_policies_take_material_changes_into_account | judgement |
| 19 | ict_risk_management_policies_and_procedures_developed_documented_and_implemented | judgement |
| 20 | risk_management_policies_indicate_approval_of_risk_tolerance_level | judgement |
| 21 | risk_management_policies_contain_risk_assessment_procedure_and_methodology | judgement |
| 22 | risk_management_policies_contain_risk_treatment_procedure | judgement |
| 23 | risk_management_policies_contain_residual_risk_provisions | judgement |
| 24 | risk_management_policies_contain_risk_monitoring_provisions | judgement |
| 25 | risk_management_policies_contain_process_for_strategy_changes | judgement |
| 26 | risk_treatment_procedure_ensures_monitoring_of_treatment_effectiveness | judgement |
| 27 | risk_treatment_procedure_ensures_assessment_of_risk_tolerance_attainment | judgement |
| 28 | risk_treatment_procedure_ensures_assessment_of_corrective_actions | judgement |

The typed input_contract has two types:

- `judgement`: `one_of [boolean, unsure]`.
- `fact`: `boolean`.

Here `boolean` means the two atoms `true` and `false`, never a Python boolean. No attested wrapper is used (ruling 2 does not apply).

## Citation-key atoms (canonical lexicon scheme; citation_vocabulary)

**Fixed four** (used for `required`, `complete`, `incomplete` and `none_outstanding`):

- `eu_reg_2024_1774_art_1`
- `eu_reg_2024_1774_art_2_1`
- `eu_reg_2024_1774_art_2_2`
- `eu_reg_2024_1774_art_3`

**Gate:**

- `eu_reg_2022_2554_art_16_1`

**Point keys** (used for duty citations, referral citations and outstanding citations):

- Art 2(1): `eu_reg_2024_1774_art_2_1_a`, `eu_reg_2024_1774_art_2_1_b`, `eu_reg_2024_1774_art_2_1_c`, `eu_reg_2024_1774_art_2_1_d`
- Art 2(2): `eu_reg_2024_1774_art_2_2_a`, `eu_reg_2024_1774_art_2_2_b`, `eu_reg_2024_1774_art_2_2_c`, `eu_reg_2024_1774_art_2_2_d`, `eu_reg_2024_1774_art_2_2_e`, `eu_reg_2024_1774_art_2_2_f`, `eu_reg_2024_1774_art_2_2_g`, `eu_reg_2024_1774_art_2_2_h`, `eu_reg_2024_1774_art_2_2_i`, `eu_reg_2024_1774_art_2_2_j`, `eu_reg_2024_1774_art_2_2_k`
- Art 3, first paragraph: `eu_reg_2024_1774_art_3_a`, `eu_reg_2024_1774_art_3_b`, `eu_reg_2024_1774_art_3_c`, `eu_reg_2024_1774_art_3_d`, `eu_reg_2024_1774_art_3_e`, `eu_reg_2024_1774_art_3_f`
- Art 3, second paragraph: `eu_reg_2024_1774_art_3_a_run2`, `eu_reg_2024_1774_art_3_b_run2`, `eu_reg_2024_1774_art_3_c_run2`

No shortened citation atom is ever invented.

## Public predicates

**Input check**

- `dora_rts_policies_and_risk_management_input_problems(Profile, Problems)`: THE INPUT CHECK, one solution for every term.
  - Problems lists, per contract key in contract order, `duplicate_key(Key)` if the key repeats, else `wrong_type(Key)` if its value is outside its type.
  - Then `unknown_key(Key)` per non-contract key, in first-occurrence order, with identity by `==`. Unbound variables are kept as given.
  - A profile that is not an attribute list gives `[wrong_type(profile)]`.
  - Citation: input_contract, the INTERFACE - THE INPUT CHECK section.

**Contract queries**

- `rts_policies_and_risk_management_duties_required(Profile, Result, Citations)`: limbs R0, R-G1, R-G2 and R1. It reads the gate only and never refers.
  - Citations: `[cite(eu_reg_2022_2554_art_16_1)]` for the gate, or the fixed four.
- `rts_policies_and_risk_management_duties_complete(Profile, Result, Citations)`: limbs S0, S-G1, S-G2, then:
  - S1: any false duty gives `incomplete`;
  - S2: the first absent duty key gives `indeterminate([Key])`;
  - S3: the first unsure duty key gives `needs_legal_review`;
  - S4: otherwise `complete`.
  - Citation: the fixed four, the gate cite, or `[]`.
- `rts_policies_and_risk_management_duties_outstanding(Profile, Result, Citations)`: limbs M0, M-G1, M-G2, then:
  - M1: the first absent duty key, even when a duty is false;
  - M2: the first unsure duty key;
  - M3: `none_outstanding` with the fixed four, or `outstanding(FailingDutiesInOrder)` citing each failing duty's own key once.

**Facade and query types**

- `decide_dora_rts_policies_and_risk_management(Profile, Verdict)`: query type #2 eligibility. Verdict is `dora_rts_policies_and_risk_management_verdict(Status, Citations)`, delegating to `rts_policies_and_risk_management_duties_complete/3`.
  - Citation: the fixed four, or `eu_reg_2022_2554_art_16_1`.
- `dora_rts_policies_and_risk_management_status(Profile, Status)`: the Status of the verdict alone. Citation: as for decide.
- `dora_rts_policies_and_risk_management_checklist(Profile, Checklist)`: query type #7 justification.
  - Checklist is the list of `item(DutyAtom, Status, cite(CitationKey))` in duty order, built by `formalize_lib:eval_requirements/4` over the slice's `dora_rts_policies_and_risk_management_requirement/4`. Status is `met`, `unmet(Reason)` or `unknown([Key])`.
  - If the gate is true, Checklist is `[item(simplified_framework_entity, met, cite(eu_reg_2022_2554_art_16_1))]`.
  - If there are input problems, Checklist is `[]`.
  - Every item, met ones included, carries its `cite(...)`.
- `dora_rts_policies_and_risk_management_what_if(Profile, Key, Value, Result)`: the verdict of decide after setting Key to Value. It uses `kit/query_combinators:what_if/5` with the closure `decide_dora_rts_policies_and_risk_management`. Citation: as for decide.
- `dora_rts_policies_and_risk_management_compliance_check(Profile, Action, Verdict, Citations)`: query type #13. Action is `certify_duty(DutyAtom)` or `certify_all_duties`.
  - `permitted`: the certified duty's key is true, or (for `certify_all_duties`) the complete query gives `complete`.
  - `prohibited`: the key is false, or the complete query gives `incomplete`. The modality is deny-overrides, through `kit/compliance_lib:compliance_check/7` with closed world `false`.
  - Otherwise the same status compound as the limbs give, with Citations `[]`.
  - Citations: the duty's own key for `certify_duty`, the fixed four for `certify_all_duties`, or `eu_reg_2022_2554_art_16_1` when the gate is true. When the gate is true the Verdict is `prohibited`, because Title II does not apply.

**Fixtures**

- `dora_rts_policies_and_risk_management_fixture(FixtureName, Profile)`: the named test profiles.
- `dora_rts_policies_and_risk_management_fixture_expected(FixtureName, QueryName, Result, Citations)`: the gold answers for fixtures.

## Planned reuse (manifest `uses:`)

- `formalize_lib`:
  - `profile_get/3` for all profile reads, by presence first and then by value;
  - `check_tri/4` for the true/false/unsure-to-met/unmet/unknown mapping in `requirement/4` (no hand-rolled clone, C15);
  - `eval_requirements/4` for the checklist (no findall row-helper clone, R1);
  - `not_defeated/3` for the gate defeater;
  - `memberd/2`, `not_member/2` and `profile_keys/2`;
  - the constructors `item/3`, `unmet/1`, `unknown/1` and `attribute/2`.
- `kit/query_combinators`: `what_if/5` (for `_what_if/4`).
- `kit/compliance_lib`: `nm/2`, `compliance_check/7` and `resolve_modality/3` (for `_compliance_check/4`).
- `validate_props` (tests only):
  - `run_props/1`;
  - `prop_totality/3` and `prop_determinism/3`, over the fixture generator;
  - `prop_citation_complete/3`;
  - `prop_missing_key_coverage/3`, over the twenty-eight keys.
- Not used: `deadline_lib`, `date_time`, `rolling_window` (no dates), `currency_vocab`, `vat_category`, `country`.
- Candidate kit module (noted in NOTES.md): an ordered-duty-table library offering first absent, first unsure and failing in order.

## Layout (unchanged)

`kernel -> citations -> parameters -> dora_rts_policies_and_risk_management -> queries -> fixtures -> package facade`. All file and module names are kept.

- `parameters` holds no figures. It stays an empty, documented module, because there is nothing to parameterise.
- `citations` holds the 29 citation facts listed above. They are the citation_vocabulary.

## Slice: dora_rts_policies_and_risk_management.clausal

**Owns: statutory VALUE facts**

There are no thresholds, periods or monetary tables. The slice owns these tables as plain facts:

- `dora_rts_policies_and_risk_management_gate_key(financial_entity_is_article_16_1_entity).`
- `dora_rts_policies_and_risk_management_gate_citation(eu_reg_2022_2554_art_16_1).`
- `dora_rts_policies_and_risk_management_fixed_citations([cite(eu_reg_2024_1774_art_1), cite(eu_reg_2024_1774_art_2_1), cite(eu_reg_2024_1774_art_2_2), cite(eu_reg_2024_1774_art_3)]).`
- `dora_rts_policies_and_risk_management_duty(Position, DutyAtom, ProfileKey, CitationKey)`: 27 rows, Position 1 to 27, in DUTY ORDER, for example:
  - `duty(1, risk_profile_and_complexity_consideration, size_risk_profile_and_complexity_taken_into_account, eu_reg_2024_1774_art_1)`
  - and so on, through `duty(27, assessment_of_corrective_actions, risk_treatment_procedure_ensures_assessment_of_corrective_actions, eu_reg_2024_1774_art_3_c_run2)`.
  - The table in NOTES.md, In-scope rules 1 to 27, is the source.
  - The referral citation of each judgement key is that row's CitationKey.
- `dora_rts_policies_and_risk_management_referral(ProfileKey, CitationKey, Inputs)`: one row per judgement key. Inputs is all twenty-eight keys in root_exports order.

**Rules and requirements**

- R-gate (defeater): `dora_rts_policies_and_risk_management_defeater(title_ii_duties, Profile)` holds when `profile_get(Profile, financial_entity_is_article_16_1_entity, true)`. It is guarded by `once/1` and checked through `not_defeated/3`. Citation `eu_reg_2022_2554_art_16_1`.
- Requirement: `dora_rts_policies_and_risk_management_requirement(DutyAtom, Profile, Status, Citation)`. The RequirementId comes FIRST.
  - It looks up the duty row and calls `check_tri(Profile, ProfileKey, not_performed(DutyAtom), Status)`.
  - Citation is `cite(CitationKey)`.
  - It gives exactly one of met / unmet / unknown per duty.
  - There are 27 independent requirements, and the kit aggregates them.
- Ordered scans over the duty table, each deterministic and cut-free:
  - `dora_rts_policies_and_risk_management_failing_duties(Profile, Duties)`: the duties whose key is `false`, in position order.
  - `dora_rts_policies_and_risk_management_first_absent_key(Profile, Key)`: the first duty key absent from Profile (`once/1` over the ordered table, guarded by `profile_lacks/2`).
  - `dora_rts_policies_and_risk_management_first_unsure_key(Profile, Key, CitationKey)`: the first duty key whose value is `unsure`.
  - `dora_rts_policies_and_risk_management_no_absent_key(Profile)` and `dora_rts_policies_and_risk_management_no_unsure_key(Profile)`: the negative guards that keep routes disjoint.
  - `dora_rts_policies_and_risk_management_inputs_relied_on(Profile, Pairs)`: every present `Key-Value` in root_exports order, with values as given.
  - `dora_rts_policies_and_risk_management_outstanding_citations(Duties, Citations)`: each duty's own cite, once, in duty order.
- Phase classifiers, which fold the limbs into disjoint clause heads (C17):
  - `dora_rts_policies_and_risk_management_complete_phase(Profile, Phase)`, with Phase in `failing`, `missing(Key)`, `unsure(Key, CitationKey)`, `all_performed`.
  - `dora_rts_policies_and_risk_management_outstanding_phase(Profile, Phase)`, with Phase in `missing(Key)`, `unsure(Key, CitationKey)`, `settled([])`, `settled([First | Rest])`.

**Verdict atoms produced**

`required/1`, `simplified_framework_entity`, `complete`, `incomplete`, `none_outstanding`, `outstanding/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`. Problems from the kernel are wrapped as `input_problems/1`.

**Per-rule tests (tests/)**

Each negative test is paired with a positive test over the same case.

- Input-check tests:
  - each of the 28 keys present twice gives `duplicate_key`;
  - `unsure` on the gate gives `wrong_type`;
  - a number, a string or an unbound value on a duty key gives `wrong_type`;
  - an unknown key with any value gives only `unknown_key`;
  - two distinct unbound keys give two `unknown_key` terms;
  - the same variable used as a key twice gives one;
  - `7` and `7.0` are two keys;
  - a non-list, a partial list or an unbound profile gives `[wrong_type(profile)]`;
  - an element that is not `attribute/2` gives `[wrong_type(profile)]`;
  - problem order: contract keys first, then unknown keys in first-occurrence order.
- Gate tests:
  - gate true with all duties absent gives `simplified_framework_entity` in all three queries;
  - gate absent with duties false gives `indeterminate([financial_entity_is_article_16_1_entity])`.
- Required: gate false gives all 27 duties in order, with the fixed four citations, even when duty keys are unsure.
- Complete:
  - one false duty plus earlier absent and unsure keys gives `incomplete`;
  - no false, with key 5 absent and key 3 unsure, gives `indeterminate([security_policies_contain_safeguards_against_intrusions_and_data_misuse])`;
  - all true except key 10 unsure gives `needs_legal_review(open_textured(security_policies_contain_indicators_and_measures_for_implementation_and_exceptions, cite(eu_reg_2024_1774_art_2_2_c)), [inputs_relied_on(AllPairs)])`;
  - all true gives `complete`.
- Outstanding:
  - a false key plus an absent key gives `indeterminate` (the absent key);
  - false keys 2 and 26, all others true, gives `outstanding([embedding_of_security_policies, monitoring_of_treatment_effectiveness])` with cites `art_2_1` and `art_3_a_run2`;
  - all true gives `none_outstanding` with the fixed four.
- Run-2 ordering: the second-paragraph duties come after `strategy_change_process`.
- Counting: `findall` over each query gives a list of length 1 for every fixture.
- Properties: totality, determinism, citation completeness, and missing-key coverage over the 28 keys.

**Checklist and verdict**

- The checklist is built with `eval_requirements/4` over the 27 duty atoms in order.
- The verdict comes from the phase classifiers, not from `decide_labeled/3`. This keeps the bare atom `indeterminate` out of the output and keeps the needs_legal_review contract.

**Shares with other slices**

NONE: it is the only slice.

## kernel.clausal (shared floor only)

The kernel holds what every query needs before the slice is reached:

- the typed key table `dora_rts_policies_and_risk_management_contract_key(Key, Type)`, 28 rows in root_exports order, with Type `fact` or `judgement`;
- `dora_rts_policies_and_risk_management_value_has_type(Type, Value)`, with three clauses for the three judgement atoms and two for the fact atoms;
- the input check `dora_rts_policies_and_risk_management_input_problems/2`, with its attribute-list well-formedness test, duplicate counting, wrong_type and unknown_key collection (identity by `==`, first-occurrence order).

No domain law lives in the kernel.
