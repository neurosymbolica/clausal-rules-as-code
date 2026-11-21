# SIGNATURE — eu/data_protection/gdpr_common_definitions_roles_and_establishments

## Public query surface

The facade is:

`decide_gdpr_common_definitions_roles_and_establishments(PROFILE, gdpr_common_definitions_roles_and_establishments_verdict(DEFINITIONS, CITATIONS))`

- DEFINITIONS is the list of eleven `defined_term(NAME, ANSWER)` terms, in relation order (see Public predicates). Each ANSWER is `definition_answer(STATUS, GROUND, CITATIONS)`.
- CITATIONS is the set union of the per-definition citations, in citation_vocabulary order.

`gdpr_common_definitions_roles_and_establishments_status(PROFILE, STATUSES)` gives the eleven `defined_term(NAME, STATUS)` terms.

Totality and determinism: every public predicate yields EXACTLY ONE solution for every profile, unbound and malformed profiles included. Malformed input gives `input_problems`. The package is cut-free: no `!`, no `->`, no `*->`.

No figure is imported or declared. The pins contain no numeric thresholds, periods or dates.

## Verdict STATUS atoms (replacing the placeholder satisfied / not_satisfied)

- `met`: bare atom.
- `not_met`: bare atom.
- `indeterminate(MISSING_KEYS)`: compound only. The bare atom `indeterminate` is NEVER written.
- `needs_legal_review(REASON, CONTEXT)`, with two possible reasons:
  - REASON `open_textured(INPUT, cite(KEY))`, CONTEXT `[inputs_relied_on(PAIRS)]`.
  - REASON `cross_reference_unresolved(cite(CITATION), cite(TARGET))`, CONTEXT `[resolution(cite(TARGET), not_attempted), inputs_relied_on(PAIRS)]`.
- `input_problems(PROBLEMS)`: with GROUND `none` and CITATIONS `[]`.

GROUND is `none` for every non-final status.

## GROUND vocabulary (verdict_vocabulary)

| Relation | Ground atoms |
|---|---|
| party_is_controller | `determines_purposes_and_means`, `provided_for_by_law`, `none` |
| main_establishment | `not_established_in_more_than_one_member_state`, `establishment_taking_decisions`, `central_administration`, `establishment_of_main_processing_activities`, `no_main_establishment_identified`, `none` |
| supervisory_authority_concerned | `point_a`, `point_b`, `point_c`, `none` |
| cross_border_processing | `point_a`, `point_b`, `none` |
| all others | `none` |

## Profile keys (root_exports order — exactly twenty-six)

- Values are bare atoms.
- Judgement keys [J] take `true`, `false` or `unsure`.
- Crisp keys [C] take `true` or `false`.
- `party_role` takes `controller` or `processor`.
- There are no numeric keys and no date keys.

| # | Key | Type | Point |
|---|---|---|---|
| 1 | data_are_personal_data | J | 4(1) |
| 2 | party_determines_purposes_and_means | J | 4(7) |
| 3 | purposes_and_means_determined_by_law | C | 4(7) |
| 4 | party_provided_for_as_controller_by_law | OUTSIDE FACT | 4(7) |
| 5 | party_processes_on_behalf_of_controller | J | 4(8) |
| 6 | data_relate_to_genetic_characteristics_giving_unique_information | J | 4(13) |
| 7 | data_result_from_technical_processing_allowing_unique_identification | J | 4(14) |
| 8 | data_relate_to_health_and_reveal_health_status | J | 4(15) |
| 9 | party_role | ROLE | 4(16) |
| 10 | established_in_more_than_one_member_state | C | 4(16) |
| 11 | central_administration_in_union | C | 4(16) |
| 12 | decisions_taken_in_other_union_establishment | C | 4(16) |
| 13 | other_establishment_can_have_decisions_implemented | J | 4(16) |
| 14 | processor_subject_to_specific_obligations | C | 4(16) |
| 15 | entity_is_person_partnership_or_association | C | 4(18) |
| 16 | entity_engaged_in_economic_activity | J | 4(18) |
| 17 | controlling_undertaking_and_controlled_undertakings | J | 4(19) |
| 18 | party_established_in_authority_member_state | C | 4(22) |
| 19 | data_subjects_in_authority_member_state_substantially_affected | J | 4(22) |
| 20 | complaint_lodged_with_authority | C | 4(22) |
| 21 | processing_in_context_of_establishments_in_more_than_one_member_state | J | 4(23) |
| 22 | processing_in_context_of_single_union_establishment | J | 4(23) |
| 23 | substantially_affects_data_subjects_in_more_than_one_member_state | J | 4(23) |
| 24 | objection_to_draft_decision | C | 4(24) |
| 25 | objection_concerns_infringement_or_envisaged_action | C | 4(24) |
| 26 | objection_demonstrates_significance_of_risks | J | 4(24) |

**outside_facts:** one row.

`outside_fact_row(party_provided_for_as_controller_by_law, eu_reg_2016_679_art_4_7, union_or_member_state_law_providing_for_controller)`

- Value: `attested(true|false, attestation(BY, AT, REASON, EVIDENCE))`.
- EVIDENCE is `url(URL, RETRIEVED_AT)`, `document(UPLOAD_ID, SHA256)` or `none`.
- Fetcher: `none`, so only `attested` is read.
- Attested true is MET, attested false is UNMET, absent is OPEN BY OUTSIDE FACT.
- The order copies the attestation and never inspects it.

## Citation-key atoms (citation_vocabulary order)

`eu_reg_2016_679_art_4_1`, `eu_reg_2016_679_art_4_7`, `eu_reg_2016_679_art_4_8`, `eu_reg_2016_679_art_4_13`, `eu_reg_2016_679_art_4_14`, `eu_reg_2016_679_art_4_15`, `eu_reg_2016_679_art_4_16`, `eu_reg_2016_679_art_4_16_a`, `eu_reg_2016_679_art_4_16_b`, `eu_reg_2016_679_art_4_18`, `eu_reg_2016_679_art_4_19`, `eu_reg_2016_679_art_4_22`, `eu_reg_2016_679_art_4_22_a`, `eu_reg_2016_679_art_4_22_b`, `eu_reg_2016_679_art_4_22_c`, `eu_reg_2016_679_art_4_23`, `eu_reg_2016_679_art_4_23_a`, `eu_reg_2016_679_art_4_23_b`, `eu_reg_2016_679_art_4_24`.

The outside-fact TARGET `union_or_member_state_law_providing_for_controller` is a lexicon entry, not in citation_vocabulary. It always sorts last.

Each lettered key is bound to its pinned unit, for example `point_004_16_a`, through the unit_keys rows of the Art 4 pin. Every key is written in answers as `cite(KEY)`.

## referrals: rows (input, citation, inputs in root_exports order)

- `data_are_personal_data` → `eu_reg_2016_679_art_4_1`; inputs `[data_are_personal_data]`.
- `party_determines_purposes_and_means` → `eu_reg_2016_679_art_4_7`; inputs `[party_determines_purposes_and_means, purposes_and_means_determined_by_law, party_provided_for_as_controller_by_law]`.
- `party_processes_on_behalf_of_controller` → `eu_reg_2016_679_art_4_8`; inputs `[party_processes_on_behalf_of_controller]`.
- `data_relate_to_genetic_characteristics_giving_unique_information` → `eu_reg_2016_679_art_4_13`; inputs: that key only.
- `data_result_from_technical_processing_allowing_unique_identification` → `eu_reg_2016_679_art_4_14`; inputs: that key only.
- `data_relate_to_health_and_reveal_health_status` → `eu_reg_2016_679_art_4_15`; inputs: that key only.
- `other_establishment_can_have_decisions_implemented` → `eu_reg_2016_679_art_4_16_a`; inputs: the six 4(16) keys, numbers 9 to 14.
- `entity_engaged_in_economic_activity` → `eu_reg_2016_679_art_4_18`; inputs: keys 15 and 16.
- `controlling_undertaking_and_controlled_undertakings` → `eu_reg_2016_679_art_4_19`; inputs: key 17.
- `data_subjects_in_authority_member_state_substantially_affected` → `eu_reg_2016_679_art_4_22_b`; inputs: keys 18 to 20.
- `processing_in_context_of_establishments_in_more_than_one_member_state` → `eu_reg_2016_679_art_4_23_a`; inputs: keys 21 to 23.
- `processing_in_context_of_single_union_establishment` → `eu_reg_2016_679_art_4_23_b`; inputs: keys 21 to 23.
- `substantially_affects_data_subjects_in_more_than_one_member_state` → `eu_reg_2016_679_art_4_23_b`; inputs: keys 21 to 23.
- `objection_demonstrates_significance_of_risks` → `eu_reg_2016_679_art_4_24`; inputs: keys 24 to 26.
- Outside fact `party_provided_for_as_controller_by_law` → citation `eu_reg_2016_679_art_4_7`, target `union_or_member_state_law_providing_for_controller`; inputs: keys 2 to 4.

PAIRS are the `Key-Value` pairs of those inputs that are present in the profile, in that order. The unsure key is included, and outside facts appear as their attested term.

## deferred_set rows

- `deferred_point(eu_reg_2016_679_art_4_17, deferred, none)`
- `deferred_point(eu_reg_2016_679_art_4_20, in_sibling, decided_in(gdpr_binding_corporate_rules, binding_corporate_rules_definition/3))`
- `deferred_point(eu_reg_2016_679_art_4_21, deferred, none)`
- The remaining Art 4 points: `in_sibling`, `decided_in(gdpr_common_definitions_data_and_processing)`.

## Public predicates

All predicates below carry the prefix `gdpr_common_definitions_roles_and_establishments_` where the scaffold does, and have exactly one solution.

**Definition relations**

- `party_is_controller(Profile, Answer)`: 4(7). The formula is D OR (L AND F), with D = `party_determines_purposes_and_means`, L = `purposes_and_means_determined_by_law` and F the outside fact. GROUND `determines_purposes_and_means` / `provided_for_by_law`. Cites `eu_reg_2016_679_art_4_7`.
- `party_is_processor(Profile, Answer)`: 4(8). The formula is the judgement `party_processes_on_behalf_of_controller`. Cites `eu_reg_2016_679_art_4_8`.
- `genetic_data(Profile, Answer)`: 4(13). `data_are_personal_data` AND the genetic judgement. Cites `eu_reg_2016_679_art_4_13`.
- `biometric_data(Profile, Answer)`: 4(14). `data_are_personal_data` AND the technical-processing judgement. Cites `eu_reg_2016_679_art_4_14`.
- `data_concerning_health(Profile, Answer)`: 4(15). `data_are_personal_data` AND the health judgement. Cites `eu_reg_2016_679_art_4_15`.
- `main_establishment(Profile, Answer)`: 4(16). The procedure of reading 5 with reading 13. Cites `eu_reg_2016_679_art_4_16` plus `_16_a` for a controller or `_16_b` for a processor.
- `enterprise(Profile, Answer)`: 4(18). Person, partnership or association AND engaged in an economic activity. Cites `eu_reg_2016_679_art_4_18`.
- `group_of_undertakings(Profile, Answer)`: 4(19). One judgement. Cites `eu_reg_2016_679_art_4_19`.
- `supervisory_authority_concerned(Profile, Answer)`: 4(22). A OR B OR C; GROUND is the first MET point. Cites `eu_reg_2016_679_art_4_22` plus the lettered key of the GROUND.
- `cross_border_processing(Profile, Answer)`: 4(23). (M AND P1) OR (P2 AND S); GROUND `point_a` before `point_b`. Cites `eu_reg_2016_679_art_4_23` plus the lettered key of the GROUND.
- `relevant_and_reasoned_objection(Profile, Answer)`: 4(24). Three-way AND. Cites `eu_reg_2016_679_art_4_24`.

**Other relations**

- `roles_and_establishments_outside_facts(Profile, OutsideFacts)`: gives `[outside_fact(party_provided_for_as_controller_by_law, Attested)]`, where Attested is the term as given or `absent`; or gives `input_problems(Problems)`. Cites `eu_reg_2016_679_art_4_7`.
- `gdpr_common_definitions_roles_and_establishments_input_problems(Profile, Problems)`: the typed input check. Problems are listed in contract-key order (`duplicate_key` before `wrong_type`), then `unknown_key` in first-occurrence order. A non-attribute-list profile gives `[wrong_type(profile)]`, and an empty list means well-formed. Cites the input_contract.

**Facade**

- `decide_gdpr_common_definitions_roles_and_establishments(Profile, Verdict)`: query #3, status_determination. Gives `gdpr_common_definitions_roles_and_establishments_verdict(Definitions, Citations)` over the eleven relations. Cites every citation used.
- `gdpr_common_definitions_roles_and_establishments_status(Profile, Statuses)`: query #3. Gives `[defined_term(Name, Status), ...]` in relation order. Cites per definition.
- `gdpr_common_definitions_roles_and_establishments_checklist(Profile, Checklist)`: query #7, justification. Gives one `item(Name, Status, Citations)` per definition (formalize_lib `item/3`), each carrying `cite(...)` provenance, met items included. Cites per item.
- `gdpr_common_definitions_roles_and_establishments_what_if(Profile, Key, Value, Verdict)`: the facade verdict after overriding one key. It uses kit `what_if/5` with the closure `decide_gdpr_common_definitions_roles_and_establishments`. If `override_key/4` does not accept attribute lists, the fallback is formalize_lib `profile_set/3`. Cites as the facade does.
- `gdpr_common_definitions_roles_and_establishments_fixture(Name, Profile)` and `gdpr_common_definitions_roles_and_establishments_fixture_expected(Name, Relation, Answer)`: named example situations with expected answers.

**Result constructors** (exported, never called as queries)

`definition_answer/3`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `cross_reference_unresolved/2`, `resolution/2`, `inputs_relied_on/1`, `provenance/2`, `outside_fact/2`, `attested/2`, `attestation/4`, `url/2`, `document/2`, plus `defined_term/2` and `gdpr_common_definitions_roles_and_establishments_verdict/2`.

## Planned reuse (manifest uses:)

**formalize_lib**

- `profile_get/3`, `profile_has/2` and `profile_lacks/2`: all key reads, presence first, then value.
- `profile_keys/2`: the input check's key enumeration.
- `profile_set/3`: the what_if fallback.
- `not_defeated/3`: the defeasible GROUND rules and the 4(16)(a) unless-clause.
- `item/3`: checklist rows.
- `not_member/2` and `memberd/2`: deduplicating MISSING_KEYS and unknown keys.
- The vocabulary atom `met`.

**Other kit modules**

- kit.query_combinators: `what_if/5`.
- validate_props, in the tests: `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `run_props/1`.
- Not used: currency_vocab, vat_category, deadline_lib, date_time, rolling_window, compliance_lib, country. There is no money, date, country or norm-modality content.

**Kit pieces considered and rejected**

- `check_tri/4`, `and_status/2` and `or_status/2` are three-valued and cannot carry OPEN BY OUTSIDE FACT or OPEN BY JUDGEMENT. A local five-state evaluator is required; it is noted in NOTES.md as a kit candidate.
- `assess/6` and `decide_labeled/3` produce a single labeled decision. This order produces eleven independent answers, so they are not used.

## Module layout

The chain is kernel → citations → parameters → slice → queries → fixtures → facade. File and module names are unchanged.

- **kernel.clausal**: the shared floor only. No domain predicate is shared, because there is only one slice. It keeps the scaffold's floor declarations.
- **citations.clausal**: the citation_vocabulary facts `gdpr_common_definitions_roles_and_establishments_citation(Key, Unit)` in the order above, plus the target lexicon entry.
- **parameters.clausal**: no statutory figure exists in these pins. The module stays as a documented, empty module.
- **queries.clausal**: status, checklist and what_if over the slice.
- **fixtures.clausal**: the named situations listed in the slice section.
- **Facade**: re-exports the public surface.

## Slice: gdpr_common_definitions_roles_and_establishments.clausal

**Value facts it owns** (tables, not numbers; they live in this file):

- `..._contract_key(Key, Type)`: the twenty-six rows in root_exports order. Type is `judgement`, `crisp`, `role` or `outside_fact`.
- `..._outside_fact_row(Key, Citation, Target)`: one row.
- `..._referral_row(Input, Citation, Inputs)`: fourteen rows plus the outside-fact row.
- `..._ground_vocabulary(Relation, Ground)`: the GROUND vocabulary table.
- `..._deferred_point(Citation, Kind, DecidedIn)`.
- `..._relation_point(Relation, CitationKey)`.
- `..._relation_order(Index, Relation)`.

**Rules and requirements**

1. **Input check** (first, whole profile):
   - attribute-list recognition: an unbound key is allowed; any other non-ground key gives `[wrong_type(profile)]`;
   - per contract key, `duplicate_key` before `wrong_type`;
   - `unknown_key` once per distinct key, unbound variables compared with `==`.
2. **Element evaluation**, `..._element(Profile, Key, State)`, with State in `met`, `unmet`, `open(absence, Key)`, `open(judgement, Key)`, `open(outside_fact, Key)`. There is one clause per disjoint value case.
3. **Formula terms**: `all_of(List)`, `any_of(List)`, `key(Key)`. `..._formula_state/3` applies strong Kleene: in `all_of`, unmet dominates, then open, else met; in `any_of`, met dominates, then open, else unmet.
4. **Descent**, `..._descent(Profile, Formula, Leaves)`. It enters only open nodes and never enters an unmet child of an open `any_of`. It yields the open leaves reached.
5. **Status from leaves**, by precedence:
   - absent keys, in root_exports order and deduplicated, give `indeterminate(MissingKeys)`;
   - else the first absent outside fact gives `cross_reference_unresolved` with its CONTEXT;
   - else the first unsure judgement, in root_exports order, gives `open_textured` with CONTEXT `[inputs_relied_on(Pairs)]`.
6. **Pairs**, `..._pairs(Profile, Inputs, Pairs)`: the present inputs, in order.
7. **Citations**, `..._citations(Relation, Ground, Profile, Status, Citations)`:
   - for final and indeterminate statuses, the point, the lettered GROUND point, and the 4(16) role letter, in vocabulary order;
   - for `open_textured`, `[Citation]`;
   - for `cross_reference_unresolved`, `[Citation, Target]`;
   - for `input_problems`, `[]`.
8. **Defeasible GROUND rules.** Each later GROUND is a default with a defeater checked under a guarded `once/1`, through `not_defeated/3`:
   - `provided_for_by_law` is defeated by D MET;
   - `point_b` is defeated by `point_a` MET;
   - `point_c` is defeated by `point_a` or `point_b` MET;
   - main-establishment `central_administration` (controller) is defeated by E MET.
   - Clauses are mutually exclusive, and ground outputs are folded into the heads (C17).
9. **The eleven definition relations and the outside-facts relation**, each with an `input_problems` clause guarded by non-empty Problems, and the remaining clauses guarded by `Problems = []`.
10. **main_establishment routes**, one clause each:
    - Step 1: M false; M or role absent.
    - Controller: E met; E unmet with the central administration true, false or absent; E open only by the unsure power with the central administration absent; E open otherwise.
    - Processor: the central administration true or absent; the central administration false with specific obligations true, false or absent.

**Verdict atoms**: `met`, `not_met`, `indeterminate/1`, `needs_legal_review/2`, `input_problems/1`, with the GROUND atoms of the table above.

**Shared predicates**: none. Nothing from this slice belongs in kernel.clausal.

**Per-rule tests** (seven test modes, v2 manifest):

1. Per relation: every route of the formula.
   - Example: `party_is_controller` with D unsure, L true and F absent gives `cross_reference_unresolved`, not `open_textured`.
   - Example: D false, L absent and F absent gives `indeterminate([purposes_and_means_determined_by_law])`.
2. Main-establishment routes, including:
   - the reading 13 case;
   - decisions absent with power false, giving E UNMET and then the central administration;
   - M false with role absent, giving not_met cited `[4_16]`.
3. GROUND precedence and reading 12: `supervisory_authority_concerned` with A absent, B unsure and C true gives met with `point_c`.
4. Input check: unknown, wrong_type, duplicate, an unbound key repeated, a non-ground compound key, an unbound profile.
5. Irrelevance (reading 1): adding a well-formed key a relation does not read leaves its answer unchanged.
6. One-solution: `findall` length is 1 for every relation over every fixture.
7. Citation completeness, using `prop_citation_complete/3`.

Every `fail` test is paired with a positive test over the same case.

**Fixtures** (named situations):

- `cloud_processor_two_member_states`
- `controller_with_deciding_establishment`
- `controller_power_to_implement_unsure`
- `hospital_health_data`
- `biometric_access_control`
- `law_designated_controller_attested`
- `law_designated_controller_unattested`
- `complaint_only_authority`
- `single_establishment_cross_border`
- `objection_incomplete`
- `malformed_profile_duplicate_and_unknown`
